import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;
  late ExtractionRepository extractions;
  late ReportRepository reports;
  late int personId;
  late int reportId;

  setUp(() async {
    db = openTestDatabase();
    extractions = ExtractionRepository(db);
    reports = ReportRepository(db);
    personId = await insertPerson(db);
    reportId = await insertReport(db, personId);
  });
  tearDown(() => db.close());

  Future<int> save(ExtractionStatus status, {String? payload}) =>
      extractions.save(
        personId: personId,
        reportId: reportId,
        extractor: 'llm:test',
        status: status,
        payload: payload,
        reason: status == ExtractionStatus.ok ? '' : 'test',
        now: testNow,
      );

  test('stores the same payload once', () async {
    final first = await save(ExtractionStatus.ok, payload: '{"results":[]}');
    final second = await save(ExtractionStatus.ok, payload: '{"results":[]}');

    expect(second, first);
  });

  test('the latest usable extraction skips failures', () async {
    final ok = await save(ExtractionStatus.ok, payload: '{"results":[]}');
    await save(ExtractionStatus.failed);

    expect((await extractions.latestUsable(reportId))!.id, ok);
  });

  test('an extracted date does not replace a manual one', () async {
    await reports.setReportInfo(
      reportId,
      reportDate: '2025-01-01',
      dateSource: DateSource.manual,
    );
    await reports.setReportInfo(
      reportId,
      reportDate: '2025-03-14',
      labName: 'Labor',
    );

    final report = (await reports.getReport(reportId))!;
    expect(report.reportDate, '2025-01-01');
    expect(report.dateSource, DateSource.manual);
    expect(report.labName, 'Labor');
  });
}
