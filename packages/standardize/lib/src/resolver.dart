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
    final group = _resolveGroup(nameKey);
    if (group is _Conflict) {
      return CodingResult(
        outcome: CodingOutcome.needsInput,
        rule: 'engine:lexical',
        reason: 'name:ambiguous',
        candidates: [
          for (final g in group.groups)
            ...terminology.membersOf(g).map((e) => e.code),
        ],
      );
    }
    if (group is! _Found) {
      return const CodingResult.uncoded(
        CodingOutcome.needsInput,
        'engine:no-match',
        rule: 'engine:lexical',
      );
    }
    return codeInGroup(
      group.groupId,
      unitUcum: unitUcum,
      valueKind: valueKind,
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
    final quantitative = valueKind == ValueKind.quantity;
    final scaled = members
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
      if (scaled.length == 1 && scaled.first.units.isEmpty) {
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
  String? groupOf(String nameKey) => switch (_resolveGroup(nameKey)) {
    _Found(:final groupId) => groupId,
    _ => null,
  };

  /// The analyte a folded name stands for.
  ///
  /// Tries the name as printed, then spelling variants, then a trailing
  /// mark such as `*` or `↑` removed. `Name (ABBR)` must agree: when name
  /// and abbreviation name two analytes, it is ambiguous.
  _Resolution _resolveGroup(String nameKey) {
    final direct = _lookup(nameKey);
    if (direct != null) return _Found(direct);

    final paren = RegExp(r'^(.+?)\s*\(([^()]+)\)$').firstMatch(nameKey);
    if (paren != null) {
      final stem = _lookup(paren.group(1)!);
      final abbreviation = _lookup(paren.group(2)!);
      if (stem != null && abbreviation != null && stem != abbreviation) {
        return _Conflict([stem, abbreviation]);
      }
      final found = stem ?? abbreviation;
      if (found != null) return _Found(found);
    }

    final stripped = nameKey
        .replaceAll(RegExp(r'[\s*↑↓!+]+$'), '')
        .replaceAll(RegExp(r'\s*(bestimmung|gesamt|i\.s\.|im serum)$'), '');
    if (stripped != nameKey && stripped.isNotEmpty) {
      return _resolveGroup(stripped);
    }
    return const _NotFound();
  }

  String? _lookup(String key) {
    for (final variant in _variants(key)) {
      final group = terminology.groupOf(variant);
      if (group != null) return group;
    }
    return null;
  }

  static Iterable<String> _variants(String key) sync* {
    yield key;
    final spaced = key.replaceAll(RegExp(r'[-_/]'), ' ').trim();
    yield spaced.replaceAll(RegExp(r'\s+'), ' ');
    yield key.replaceAll(RegExp(r'[\s\-_.]'), '');
  }
}

sealed class _Resolution {
  const _Resolution();
}

class _Found extends _Resolution {
  const _Found(this.groupId);
  final String groupId;
}

class _Conflict extends _Resolution {
  const _Conflict(this.groups);
  final List<String> groups;
}

class _NotFound extends _Resolution {
  const _NotFound();
}
