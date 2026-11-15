import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/application/delete_report.dart';
import 'package:trackfit/application/import_service.dart';
import 'package:trackfit/data/file_store.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../helpers.dart';

void main() {
  test('deletes the report and its stored files', () async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final root = await Directory.systemTemp.createTemp('delete_report_test');
    addTearDown(() => root.delete(recursive: true));
    final store = FileStore(root);
    final reports = ReportRepository(db);
    final personId = await PersonRepository(
      db,
    ).ensureDefaultPerson(defaultTz: 'UTC', now: DateTime.utc(2026));
    final outcome = await ImportService(reports: reports, fileStore: store)
        .importFiles(personId, [
          ImportCandidate(
            name: 'befund.pdf',
            bytes: fakePdf(),
            channel: ImportChannel.filePicker,
          ),
        ]);
    final reportId = outcome.reportIds.single;
    final path = (await reports.getFiles(reportId)).single.storedPath;

    await deleteReport(
      reports: reports,
      fileStore: store,
      reportId: reportId,
      deleteValues: true,
    );

    expect(await reports.getReport(reportId), isNull);
    expect(store.resolve(path).existsSync(), isFalse);
  });
}
