import 'package:trackfit_core/trackfit_core.dart';
import 'package:ucum/ucum.dart';

import 'coding.dart';
import 'terminology.dart';

/// Codes readings by their name, then picks the variant by unit.
///
/// The name says which analyte a reading is; the printed unit says whether
/// it is the mass or the substance concentration. A reading is only coded
/// when both are clear; otherwise it needs input from a person.
class LexicalCoder implements Coder {
  LexicalCoder(this.terminology);

  final Terminology terminology;

  static const codeSystem = 'http://loinc.org';

  @override
  String get release => terminology.release;

  @override
  CodingResult code({
    required String nameKey,
    required String unitUcum,
    required ValueKind valueKind,
  }) {
    if (terminology.isCategory(nameKey)) {
      return const CodingResult.uncoded(
        CodingOutcome.refused,
        'engine:refused',
        rule: 'engine:lexical',
      );
    }
    final groups = _resolveGroups(nameKey);
    if (groups is _Conflict) {
      return CodingResult(
        outcome: CodingOutcome.needsInput,
        rule: 'engine:lexical',
        reason: 'name:ambiguous',
        candidates: [
          for (final g in groups.groups)
            ...terminology.membersOf(g).map((e) => e.code),
        ],
      );
    }
    if (groups is! _Found) {
      return const CodingResult.uncoded(
        CodingOutcome.needsInput,
        'engine:no-match',
        rule: 'engine:lexical',
      );
    }
    final results = [
      for (final group in groups.groups)
        codeInGroup(
          group,
          unitUcum: unitUcum,
          valueKind: valueKind,
          rule: 'engine:lexical',
        ),
    ];
    final coded = results.where((r) => r.isCoded).toList();
    if (coded.length == 1) return coded.single;
    if (coded.length > 1) {
      return CodingResult(
        outcome: CodingOutcome.needsInput,
        rule: 'engine:lexical',
        reason: 'name:ambiguous',
        candidates: [for (final r in coded) r.code!],
      );
    }
    // Nothing fits: report the reason all analytes agree on, if any.
    final reasons = {for (final r in results) r.reason};
    return CodingResult.uncoded(
      CodingOutcome.needsInput,
      reasons.length == 1 ? reasons.single : 'unit:conflict',
      rule: 'engine:lexical',
    );
  }

  /// Picks the code of [groupId] that fits the unit and the kind of value.
  CodingResult codeInGroup(
    String groupId, {
    required String unitUcum,
    required ValueKind valueKind,
    required String rule,
  }) {
    final members = terminology.membersOf(groupId);
    if (members.isEmpty) {
      return CodingResult.uncoded(
        CodingOutcome.needsInput,
        'engine:no-match',
        rule: rule,
      );
    }
    // A test that was not done has no value, so its scale says nothing:
    // it gets the code of the test, chosen by unit like a number.
    final absent = valueKind == ValueKind.absent;
    final quantitative = valueKind == ValueKind.quantity || absent;
    final quantitativeMembers = members.where((m) => m.scale == 'Qn');
    final scaled = absent && quantitativeMembers.isEmpty
        ? members
        : members
              .where((m) => quantitative ? m.scale == 'Qn' : m.scale != 'Qn')
              .toList();
    if (scaled.isEmpty) {
      return CodingResult.uncoded(
        CodingOutcome.needsInput,
        'scale:${valueKind.wire}-vs-${members.first.scale}',
        rule: rule,
      );
    }
    if (!quantitative) return _coded(scaled.first, rule, ['name', 'scale']);

    if (unitUcum.isEmpty) {
      if (scaled.length == 1 && (scaled.first.units.isEmpty || absent)) {
        return _coded(scaled.first, rule, ['name']);
      }
      return CodingResult.uncoded(
        CodingOutcome.needsInput,
        'unit:missing',
        rule: rule,
      );
    }
    for (final member in scaled) {
      if (member.units.contains(unitUcum)) {
        return _coded(member, rule, ['name', 'unit']);
      }
    }
    for (final member in scaled) {
      if (member.units.any((u) => canConvert(unitUcum, u))) {
        return _coded(member, rule, ['name', 'property']);
      }
    }
    return CodingResult.uncoded(
      CodingOutcome.needsInput,
      'unit:conflict',
      rule: rule,
    );
  }

  CodingResult _coded(TerminologyEntry entry, String rule, List<String> why) =>
      CodingResult(
        outcome: CodingOutcome.coded,
        rule: rule,
        codeSystem: codeSystem,
        code: entry.code,
        groupId: entry.groupId,
        canonicalUnit: entry.canonicalUnit,
        molarMass: entry.molarMass,
        evidence: why,
        concept: entry.concept,
      );

  /// The analyte a folded name stands for, null when unknown or ambiguous.
  String? groupOf(String nameKey) => switch (_resolveGroups(nameKey)) {
    _Found(:final groups) when groups.length == 1 => groups.single,
    _ => null,
  };

  /// Words a report adds after the name that do not change the test, e.g.
  /// the lab section (`Zentrallabor`) or the purpose (`Freigabe`).
  static const _qualifiers = [
    'zentrallabor',
    'freigabeparameter',
    'freigabe',
    'screening',
    'suchtest',
    'pool',
    'bestimmung',
    'quantitativ',
    'qualitativ',
    'im serum',
    'i.s.',
    'i.s',
    'serum',
    'plasma',
    'vollblut',
    'edta',
    'gesamt',
    'absolut',
    'abs',
    'relativ',
    'rel',
  ];

  /// Measure words at the end of a compound, as in `Leukozytenzahl`.
  static const _measureSuffixes = ['konzentration', 'anzahl', 'zahl'];

  /// The analytes a folded name stands for.
  ///
  /// Tries the name as printed (and spelling variants), then `Name (ABBR)`,
  /// which must agree, then the name with trailing marks and qualifiers
  /// removed one by one.
  _Resolution _resolveGroups(String nameKey) {
    final direct = _lookup(nameKey);
    if (direct.isNotEmpty) return _Found(direct);

    // A short code in front, e.g. `(GB) Vitamin D (25-OH-…)`: resolve the
    // rest as a whole, so its own brackets are read as usual.
    final leading = RegExp(r'^\([^()]{1,8}\)\s*(.+)$').firstMatch(nameKey);
    if (leading != null) return _resolveGroups(leading.group(1)!);

    final paren = RegExp(r'^(.+?)\s*\(([^()]+)\)$').firstMatch(nameKey);
    if (paren != null) {
      final stem = _lookupReduced(paren.group(1)!);
      final abbreviation = _lookup(paren.group(2)!);
      if (stem.isNotEmpty &&
          abbreviation.isNotEmpty &&
          stem.intersection(abbreviation).isEmpty) {
        return _Conflict([...stem, ...abbreviation]);
      }
      if (stem.isNotEmpty) return _Found(stem);
      if (abbreviation.isNotEmpty) return _Found(abbreviation);
    }
    final reduced = _lookupReduced(nameKey);
    return reduced.isEmpty ? const _NotFound() : _Found(reduced);
  }

  Set<String> _lookupReduced(String key) {
    for (final candidate in _reductions(key)) {
      final groups = _lookup(candidate);
      if (groups.isNotEmpty) return groups;
    }
    return const {};
  }

  /// [key], then shorter forms without one trailing mark, bracket,
  /// qualifier or measure word each.
  static Iterable<String> _reductions(String key) sync* {
    var current = key.trim();
    yield current;
    for (var i = 0; i < 8; i++) {
      final next = _reduceOnce(current)?.trim();
      if (next == null || next.isEmpty || next == current) return;
      current = next;
      yield current;
    }
  }

  static String? _reduceOnce(String key) {
    final marks = key.replaceAll(RegExp(r'[\s*↑↓!+]+$'), '');
    if (marks != key) return marks;
    // A short code in front of the name, e.g. the material `(GB) Ferritin`.
    final leading = RegExp(r'^\([^()]{1,8}\)\s*(.+)$').firstMatch(key);
    if (leading != null) return leading.group(1);
    final bracket = RegExp(r'^(.+?)\s*\([^()]*\)$').firstMatch(key);
    if (bracket != null) return bracket.group(1);
    for (final qualifier in _qualifiers) {
      for (final separator in [' - ', ' -', '-', ' ', ', ']) {
        if (key.endsWith('$separator$qualifier')) {
          return key.substring(
            0,
            key.length - separator.length - qualifier.length,
          );
        }
      }
    }
    for (final suffix in _measureSuffixes) {
      if (key.endsWith(suffix) && key.length > suffix.length + 2) {
        return key
            .substring(0, key.length - suffix.length)
            .replaceAll(RegExp(r'[-\s]+$'), '');
      }
    }
    return null;
  }

  Set<String> _lookup(String key) {
    for (final variant in _variants(key)) {
      final groups = terminology.groupsOf(variant);
      if (groups.isNotEmpty) return groups;
    }
    return const {};
  }

  static Iterable<String> _variants(String key) sync* {
    yield key;
    final spaced = key.replaceAll(RegExp(r'[-_/]'), ' ').trim();
    yield spaced.replaceAll(RegExp(r'\s+'), ' ');
  }
}

sealed class _Resolution {
  const _Resolution();
}

class _Found extends _Resolution {
  const _Found(this.groups);
  final Set<String> groups;
}

class _Conflict extends _Resolution {
  const _Conflict(this.groups);
  final List<String> groups;
}

class _NotFound extends _Resolution {
  const _NotFound();
}
