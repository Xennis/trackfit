import 'package:trackfit_core/trackfit_core.dart';

/// Display data of a code, as stored next to the readings that use it.
class ConceptInfo {
  const ConceptInfo({
    required this.display,
    this.displayDe = '',
    this.shortName = '',
    this.category = '',
    this.component = '',
    this.property = '',
    this.timeAspect = '',
    this.system = '',
    this.scale = '',
    this.method = '',
  });

  final String display;
  final String displayDe;
  final String shortName;
  final String category;
  final String component;
  final String property;
  final String timeAspect;
  final String system;
  final String scale;
  final String method;
}

/// What a reading was coded as, and why.
class CodingResult {
  const CodingResult({
    required this.outcome,
    required this.rule,
    this.reason = '',
    this.codeSystem,
    this.code,
    this.groupId,
    this.canonicalUnit,
    this.molarMass,
    this.evidence = const [],
    this.concept,
    this.candidates = const [],
  });

  /// No code: [reason] says why, e.g. `engine:no-match`.
  const CodingResult.uncoded(this.outcome, this.reason, {this.rule = 'none'})
    : codeSystem = null,
      code = null,
      groupId = null,
      canonicalUnit = null,
      molarMass = null,
      evidence = const [],
      concept = null,
      candidates = const [];

  final CodingOutcome outcome;

  /// e.g. `alias:person`, `engine:lexical`.
  final String rule;
  final String reason;
  final String? codeSystem;
  final String? code;

  /// Analyte across mass and substance codes, e.g. `iron`.
  final String? groupId;

  /// Unit all readings of the group are shown in, e.g. `ug/dL`.
  final String? canonicalUnit;

  /// Molar mass of the analyte in g/mol, to convert mass and substance.
  final double? molarMass;
  final List<String> evidence;
  final ConceptInfo? concept;

  /// Codes a person may choose from when the name was ambiguous.
  final List<String> candidates;

  bool get isCoded => outcome == CodingOutcome.coded;
}

/// Assigns codes to readings.
abstract interface class Coder {
  /// Version of the terminology, stored with every coding.
  String get release;

  CodingResult code({
    required String nameKey,
    required String unitUcum,
    required ValueKind valueKind,
  });
}

/// A [Coder] that codes nothing, e.g. before the terminology is loaded.
class NoCoder implements Coder {
  const NoCoder();

  @override
  String get release => 'none';

  @override
  CodingResult code({
    required String nameKey,
    required String unitUcum,
    required ValueKind valueKind,
  }) => const CodingResult.uncoded(CodingOutcome.needsInput, 'engine:no-match');
}
