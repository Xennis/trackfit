import 'observation_draft.dart';

/// What a language model read from a lab report: the readings as printed,
/// plus the date and laboratory of the report.
final class ExtractionResult {
  const ExtractionResult({
    required this.results,
    this.reportDate,
    this.labName = '',
  }) : skipped = 0;

  /// Reads a result from its JSON form.
  ///
  /// Drafts that are not valid are skipped and counted in [skipped], so one
  /// broken row does not lose the whole report. Throws a [FormatException]
  /// when the JSON has no `results` list.
  factory ExtractionResult.fromJson(Map<String, Object?> json) {
    final results = json['results'];
    if (results is! List) {
      throw FormatException('"results" must be a list', json);
    }
    final drafts = <ObservationDraft>[];
    var skipped = 0;
    for (final item in results) {
      try {
        if (item is! Map<String, Object?>) throw const FormatException();
        drafts.add(ObservationDraft.fromJson(item));
      } on FormatException {
        skipped++;
      }
    }
    final date = json['report_date'];
    final lab = json['lab_name'];
    return ExtractionResult._withSkipped(
      results: drafts,
      reportDate: date is String && isIsoDate(date) ? date : null,
      labName: lab is String ? lab.trim() : '',
      skipped: skipped,
    );
  }

  const ExtractionResult._withSkipped({
    required this.results,
    required this.reportDate,
    required this.labName,
    required this.skipped,
  });

  final List<ObservationDraft> results;

  /// Date printed on the report as `YYYY-MM-DD`, null when not found.
  final String? reportDate;

  final String labName;

  /// Number of rows that were dropped because they were not valid.
  final int skipped;

  /// Whether [value] is a valid calendar date as `YYYY-MM-DD`.
  static bool isIsoDate(String value) {
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) return false;
    final parsed = DateTime.tryParse(value);
    return parsed != null &&
        parsed.toIso8601String().startsWith(value) &&
        parsed.year >= 1900;
  }

  Map<String, Object?> toJson() => {
    'report_date': reportDate,
    'lab_name': labName,
    'results': [for (final draft in results) draft.toJson()],
  };

  /// JSON schema of the answer a language model must give.
  static const Map<String, Object?> jsonSchema = {
    'type': 'object',
    'additionalProperties': false,
    'required': ['report_date', 'lab_name', 'results'],
    'properties': {
      'report_date': {
        'type': 'string',
        'description': 'Date of the report as YYYY-MM-DD, empty if not printed',
      },
      'lab_name': {'type': 'string'},
      'results': {
        'type': 'array',
        'items': {
          'type': 'object',
          'additionalProperties': false,
          'required': [
            'name',
            'value',
            'unit',
            'reference',
            'flag',
            'specimen',
            'panel',
            'page',
          ],
          'properties': {
            'name': {'type': 'string'},
            'value': {'type': 'string'},
            'unit': {'type': 'string'},
            'reference': {'type': 'string'},
            'flag': {'type': 'string'},
            'specimen': {'type': 'string'},
            'panel': {'type': 'string'},
            'page': {'type': 'integer'},
          },
        },
      },
    },
  };
}
