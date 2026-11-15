import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';

void main() {
  test('reads date, lab and drafts', () {
    final result = ExtractionResult.fromJson({
      'report_date': '2025-03-14',
      'lab_name': ' Labor Beispiel ',
      'results': [
        {'name': 'Eisen', 'value': '52', 'unit': 'µg/dl', 'page': 1},
      ],
    });

    expect(result.reportDate, '2025-03-14');
    expect(result.labName, 'Labor Beispiel');
    expect(result.results.single.name, 'Eisen');
    expect(result.skipped, 0);
  });

  test('skips invalid rows instead of failing', () {
    final result = ExtractionResult.fromJson({
      'results': [
        {'name': 'Eisen', 'value': '52'},
        {'value': '1'},
        'nonsense',
      ],
    });

    expect(result.results, hasLength(1));
    expect(result.skipped, 2);
  });

  test('drops a date that is not a real date', () {
    for (final date in ['14.03.2025', '2025-02-30', '', null]) {
      final result = ExtractionResult.fromJson({
        'report_date': date,
        'results': <Object?>[],
      });
      expect(result.reportDate, isNull, reason: '$date');
    }
  });

  test('needs a results list', () {
    expect(
      () => ExtractionResult.fromJson({'report_date': '2025-03-14'}),
      throwsFormatException,
    );
  });

  test('round-trips through json', () {
    const result = ExtractionResult(
      reportDate: '2025-03-14',
      labName: 'Lab',
      results: [ObservationDraft(name: 'TSH', value: '1.2')],
    );

    final again = ExtractionResult.fromJson(result.toJson());
    expect(again.results, result.results);
    expect(again.reportDate, result.reportDate);
  });
}
