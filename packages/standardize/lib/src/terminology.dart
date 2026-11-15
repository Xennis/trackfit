import 'coding.dart';
import 'fold.dart';

/// One code of the terminology, e.g. iron as mass concentration in serum.
class TerminologyEntry {
  const TerminologyEntry({
    required this.code,
    required this.groupId,
    required this.property,
    required this.scale,
    required this.units,
    required this.concept,
    this.canonicalUnit,
    this.molarMass,
  });

  /// LOINC code.
  final String code;

  /// Analyte, shared by its mass and substance codes, e.g. `iron`.
  final String groupId;

  /// LOINC property, e.g. `MCnc` (mass concentration), `SCnc`, `NCnc`.
  final String property;

  /// LOINC scale, e.g. `Qn` (quantitative), `Ord`.
  final String scale;

  /// UCUM units readings of this code are printed in.
  final Set<String> units;

  /// Unit all readings of the group are shown in.
  final String? canonicalUnit;

  /// Molar mass of the analyte in g/mol.
  final double? molarMass;
  final ConceptInfo concept;
}

/// The codes, names and categories the resolver knows.
class Terminology {
  Terminology({
    required this.release,
    required List<TerminologyEntry> entries,
    required Map<String, String> aliases,
    required Set<String> categories,
  }) : _aliases = aliases,
       _categories = categories,
       _groups = {
         for (final entry in entries)
           entry.groupId: [
             ...entries.where((e) => e.groupId == entry.groupId),
           ],
       },
       _byCode = {for (final entry in entries) entry.code: entry};

  /// Reads the seed tables: one row per code and one row per category.
  ///
  /// `lab_tests.tsv` columns: code, group, property, scale, units (comma
  /// separated UCUM), canonical unit, molar mass, category, short name,
  /// German name, LOINC long common name, component, system, aliases
  /// (`|` separated). `categories.tsv`: one term per row.
  factory Terminology.fromSeed({
    required String release,
    required String labTests,
    required String categories,
  }) {
    final entries = <TerminologyEntry>[];
    final aliases = <String, String>{};
    for (final row in _rows(labTests)) {
      if (row.length < 14) {
        throw FormatException('lab test row needs 14 columns', row.join('\t'));
      }
      final [
        code,
        group,
        property,
        scale,
        units,
        canonical,
        molarMass,
        category,
        shortName,
        displayDe,
        display,
        component,
        system,
        names,
        ...,
      ] = row;
      entries.add(
        TerminologyEntry(
          code: code,
          groupId: group,
          property: property,
          scale: scale,
          units: {
            for (final unit in units.split(','))
              if (unit.trim().isNotEmpty) unit.trim(),
          },
          canonicalUnit: canonical.isEmpty ? null : canonical,
          molarMass: molarMass.isEmpty ? null : double.parse(molarMass),
          concept: ConceptInfo(
            display: display,
            displayDe: displayDe,
            shortName: shortName,
            category: category,
            component: component,
            property: property,
            system: system,
            scale: scale,
          ),
        ),
      );
      for (final name in [shortName, displayDe, ...names.split('|')]) {
        final key = nameKey(name);
        if (key.isEmpty) continue;
        final existing = aliases[key];
        if (existing != null && existing != group) {
          throw FormatException('"$name" names $existing and $group');
        }
        aliases[key] = group;
      }
    }
    return Terminology(
      release: release,
      entries: entries,
      aliases: aliases,
      categories: {for (final row in _rows(categories)) nameKey(row.first)},
    );
  }

  final String release;
  final Map<String, String> _aliases;
  final Set<String> _categories;
  final Map<String, List<TerminologyEntry>> _groups;
  final Map<String, TerminologyEntry> _byCode;

  /// Analyte a folded name stands for, if known.
  String? groupOf(String nameKey) => _aliases[nameKey];

  /// Whether a folded name is a category such as "Blutbild", not one test.
  bool isCategory(String nameKey) => _categories.contains(nameKey);

  /// Codes of an analyte.
  List<TerminologyEntry> membersOf(String groupId) =>
      _groups[groupId] ?? const [];

  TerminologyEntry? entry(String code) => _byCode[code];

  /// All codes, e.g. for choosing one by hand.
  Iterable<TerminologyEntry> get entries => _byCode.values;

  /// Folded names and the analyte they stand for.
  Map<String, String> get aliases => Map.unmodifiable(_aliases);

  Set<String> get categories => Set.unmodifiable(_categories);

  static Iterable<List<String>> _rows(String tsv) sync* {
    for (final line in tsv.split('\n')) {
      if (line.trim().isEmpty || line.startsWith('#')) continue;
      yield [for (final cell in line.split('\t')) cell.trim()];
    }
  }
}
