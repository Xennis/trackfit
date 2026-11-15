import 'dart:convert';

import 'package:trackfit_core/trackfit_core.dart';

import 'mistral_chat.dart';

/// One recognized page handed to the extractor.
class ExtractorPage {
  const ExtractorPage({required this.number, required this.markdown});

  /// Page of the report, starting at 1.
  final int number;
  final String markdown;
}

/// Reads the readings of a lab report from its recognized text.
///
/// The model copies names, values and units as printed. It never assigns
/// codes; that is done later from bundled tables.
class LabReportExtractor {
  LabReportExtractor(this._chat);

  final MistralChat _chat;

  /// Version of the prompt, stored with every extraction.
  static const promptVersion = 'lab-report-v1';

  String get id => 'llm:mistral/${_chat.model}@$promptVersion';

  static const systemPrompt = '''
You read lab reports and return their test results as JSON.

Rules:
- Copy test names, values and units exactly as printed. Do not translate,
  do not convert units, do not correct spelling, keep the decimal separator.
- Only actual results are results. Reference ranges, page numbers, dates,
  addresses and phone numbers are not results.
- "reference" is the reference range as printed, e.g. "60 - 170" or "< 5,0".
- "flag" is an abnormal marker as printed, e.g. "H", "L", "+", "*", "↑".
- "panel" is the heading the result is listed under, e.g. "Blutbild".
- A value such as "120/80" with two parts is two results.
- "page" is the number of the page marker the result appears under.
- Leave a field empty when it is not printed.
- Never output codes such as LOINC.
- Do not output names, birth dates, addresses or ids of the patient.
- "report_date" is the date the sample was taken or the report was issued,
  as YYYY-MM-DD; empty when no such date is printed.
''';

  /// Builds the user message: all pages with markers.
  static String userPrompt(List<ExtractorPage> pages) => [
    for (final page in pages) '--- page ${page.number} ---\n${page.markdown}',
  ].join('\n\n');

  Future<ExtractionResult> extract(List<ExtractorPage> pages) async {
    final answer = await _chat.completeJson(
      system: systemPrompt,
      user: userPrompt(pages),
      schemaName: 'lab_report',
      schema: ExtractionResult.jsonSchema,
    );
    return parseAnswer(answer);
  }

  /// Reads the answer of the model.
  static ExtractionResult parseAnswer(String answer) {
    try {
      return ExtractionResult.fromJson(
        jsonDecode(answer) as Map<String, Object?>,
      );
    } on Object {
      throw const LlmException('answer is not valid', retryable: false);
    }
  }
}
