import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

/// Fixed point in time for rows created in tests.
final testNow = DateTime.utc(2026, 11, 15, 12);

Future<int> insertPerson(TrackfitDatabase db) => db
    .into(db.person)
    .insert(
      PersonCompanion.insert(
        displayName: 'Test',
        defaultTz: 'Europe/Berlin',
        createdAt: testNow,
      ),
    );

Future<int> insertReport(TrackfitDatabase db, int personId) => db
    .into(db.report)
    .insert(ReportCompanion.insert(personId: personId, createdAt: testNow));

Future<int> insertSourceFile(
  TrackfitDatabase db, {
  required int personId,
  required int reportId,
  int position = 0,
  String hash = '',
}) => db
    .into(db.sourceFile)
    .insert(
      SourceFileCompanion.insert(
        personId: personId,
        reportId: reportId,
        position: position,
        contentHash: hash.isEmpty ? 'a' * 64 : hash,
        fileName: 'report.pdf',
        mimeType: 'application/pdf',
        byteSize: 1024,
        storedPath: 'files/report.pdf',
        kind: FileKind.pdf,
        importChannel: ImportChannel.filePicker,
        importedAt: testNow,
      ),
    );
