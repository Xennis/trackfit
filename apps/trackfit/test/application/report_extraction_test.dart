import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit/application/import_service.dart';
import 'package:trackfit/application/report_extraction.dart';
import 'package:trackfit/application/report_processor.dart';
import 'package:trackfit/data/file_store.dart';
import 'package:trackfit/platform/llm/lab_report_extractor.dart';
import 'package:trackfit/platform/llm/mistral_chat.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../helpers.dart';

LabReportExtractor fakeExtractor(
  Map<String, Object?> answer, {
  int status = 200,
}) => LabReportExtractor(
  MistralChat(
    apiKey: 'k',
    client: MockClient(
      (_) async => http.Response.bytes(
        utf8.encode(
          jsonEncode({
            'choices': [
              {
                'message': {'content': jsonEncode(answer)},
              },
            ],
          }),
        ),
        status,
      ),
    ),
  ),
);

void main() {
  late TrackfitDatabase db;
  late Directory root;
  late ReportRepository reports;
  late int reportId;

  setUp(() async {
    db = memoryDatabase();
    root = await Directory.systemTemp.createTemp('extraction_test');
    reports = ReportRepository(db);
    final personId = await PersonRepository(
      db,
    ).ensureDefaultPerson(defaultTz: 'Europe/Berlin', now: DateTime.utc(2026));
    final outcome =
        await ImportService(
          reports: reports,
          fileStore: FileStore(root),
        ).importFiles(personId, [
          ImportCandidate(
            name: 'befund.pdf',
            bytes: fakePdf(),
            channel: ImportChannel.filePicker,
          ),
        ]);
    reportId = outcome.reportIds.single;
  });
  tearDown(() async {
    await db.close();
    await root.delete(recursive: true);
  });

  Future<void> process(LabReportExtractor extractor) {
    final extraction = ReportExtraction(
      db: db,
      coder: const NoCoder(),
      extractor: extractor,
    );
    return ReportProcessor(
      reports: reports,
      pages: PageRepository(db),
      fileStore: FileStore(root),
      ocr: FakeOcr(),
      afterRecognition: extraction.run,
    ).process(reportId);
  }

  final answer = {
    'report_date': '2025-03-14',
    'lab_name': 'Labor Beispiel',
    'results': [
      {
        'name': 'Eisen',
        'value': '52',
        'unit': 'µg/dl',
        'reference': '60 - 170',
        'flag': 'L',
        'specimen': 'Serum',
        'panel': 'Eisenstoffwechsel',
        'page': 1,
      },
      {
        'name': 'Ferritin',
        'value': '18',
        'unit': 'ng/ml',
        'reference': '30 - 400',
        'flag': '',
        'specimen': '',
        'panel': 'Eisenstoffwechsel',
        'page': 1,
      },
    ],
  };

  test('reads values, date and lab and writes the readings', () async {
    await process(fakeExtractor(answer));

    final report = (await reports.getReport(reportId))!;
    expect(report.status, ReportStatus.review);
    expect(report.reportDate, '2025-03-14');
    expect(report.dateSource, DateSource.extracted);
    expect(report.labName, 'Labor Beispiel');

    final readings = await ObservationRepository(
      db,
    ).watchReportReadings(reportId).first;
    expect(readings.map((r) => r.nameText), ['Eisen', 'Ferritin']);
    final iron = readings.first;
    expect(iron.valueNum, 52);
    expect(iron.unitUcum, 'ug/dL');
    expect(iron.refLow, 60);
    expect(iron.flag, Flag.low);
    expect(iron.localDate, '2025-03-14');
    expect(iron.pageIx, 0);
    expect(iron.modality, Modality.llmUnverified);
    expect(iron.outcome, CodingOutcome.needsInput);
    expect(readings.last.flag, Flag.low);
  });

  test('waits for a date before writing readings', () async {
    await process(fakeExtractor({...answer, 'report_date': ''}));

    expect(
      await ObservationRepository(db).watchReportReadings(reportId).first,
      isEmpty,
    );

    await reports.setReportInfo(
      reportId,
      reportDate: '2025-03-01',
      dateSource: DateSource.manual,
    );
    await ReportExtraction(
      db: db,
      coder: const NoCoder(),
    ).writeReadings(reportId);

    final readings = await ObservationRepository(
      db,
    ).watchReportReadings(reportId).first;
    expect(readings, hasLength(2));
    expect(readings.first.localDate, '2025-03-01');
  });

  test('a failed extraction marks the report as failed', () async {
    await process(fakeExtractor(answer, status: 401));

    final report = (await reports.getReport(reportId))!;
    expect(report.status, ReportStatus.failed);
    expect(report.error, 'Mistral answered 401');
    final stored = await db.select(db.extraction).getSingle();
    expect(stored.status, ExtractionStatus.failed);
  });
}
