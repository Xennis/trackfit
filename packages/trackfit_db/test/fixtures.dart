import 'package:drift/drift.dart';
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

/// A lab value of one day, as written after standardization.
ObservationCompanion labObservation({
  required int personId,
  String name = 'Eisen',
  ValueKind valueKind = ValueKind.quantity,
  double? valueNum = 52,
  ObservationStatus status = ObservationStatus.finalStatus,
  int? amends,
}) {
  final day = DateTime.utc(2025, 3, 14);
  return ObservationCompanion.insert(
    personId: personId,
    kind: ObservationKind.measurement,
    modality: Modality.labReport,
    sourceKind: SourceKind.file,
    sourceRef: 'report:1',
    sourceClass: SourceClass.measurer,
    observedStart: day,
    observedEnd: day.add(const Duration(days: 1)),
    tz: 'Europe/Berlin',
    tzSource: TzSource.userDefault,
    localDate: '2025-03-14',
    grain: Grain.day,
    stat: const Value(Stat.last),
    nameText: name,
    valueText: Value(valueNum?.toString() ?? ''),
    unitText: const Value('µg/dl'),
    nameKey: name.toLowerCase(),
    valueKind: valueKind,
    valueNum: Value(valueNum),
    unitUcum: const Value('ug/dL'),
    localKey: '${name.toLowerCase()}|ug/dL',
    streamKey: '${name.toLowerCase()}|ug/dL|file:',
    fingerprint: 'f' * 64,
    status: Value(status),
    amends: Value(amends),
    createdAt: testNow,
  );
}
