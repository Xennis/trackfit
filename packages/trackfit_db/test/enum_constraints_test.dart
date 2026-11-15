import 'package:drift/drift.dart';
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

/// The CHECK constraints list the allowed values in SQL. These tests make
/// sure every value of the Dart enums is accepted, so both stay in sync.
void main() {
  late TrackfitDatabase db;
  late int personId;
  var counter = 0;

  setUp(() async {
    db = openTestDatabase();
    personId = await insertPerson(db);
  });
  tearDown(() => db.close());

  Future<void> insertObservation(ObservationCompanion row) => db
      .into(db.observation)
      .insert(row.copyWith(sourceRef: Value('test:${counter++}')));

  ObservationCompanion base() => labObservation(personId: personId);

  test('report accepts every status and date source', () async {
    for (final status in ReportStatus.values) {
      await db
          .into(db.report)
          .insert(
            ReportCompanion.insert(
              personId: personId,
              createdAt: testNow,
              status: Value(status),
              error: const Value('error'),
            ),
          );
    }
    for (final source in DateSource.values.where(
      (s) => s != DateSource.unknown,
    )) {
      await db
          .into(db.report)
          .insert(
            ReportCompanion.insert(
              personId: personId,
              createdAt: testNow,
              reportDate: const Value('2025-01-01'),
              dateSource: Value(source),
            ),
          );
    }
  });

  test('source file accepts every kind and channel', () async {
    final reportId = await insertReport(db, personId);
    var position = 0;
    for (final kind in FileKind.values) {
      for (final channel in ImportChannel.values) {
        await db
            .into(db.sourceFile)
            .insert(
              SourceFileCompanion.insert(
                personId: personId,
                reportId: reportId,
                position: position,
                contentHash: position.toRadixString(16).padLeft(64, '0'),
                fileName: 'f',
                mimeType: 'application/octet-stream',
                byteSize: 0,
                storedPath: 'f',
                kind: kind,
                importChannel: channel,
                importedAt: testNow,
              ),
            );
        position++;
      }
    }
  });

  test('observation accepts every enum value', () async {
    for (final v in ObservationKind.values) {
      await insertObservation(base().copyWith(kind: Value(v)));
    }
    for (final v in Modality.values.where((m) => m != Modality.derived)) {
      await insertObservation(base().copyWith(modality: Value(v)));
    }
    await insertObservation(
      base().copyWith(
        modality: const Value(Modality.derived),
        derivedFrom: const Value('[]'),
      ),
    );
    for (final v in SourceKind.values) {
      await insertObservation(base().copyWith(sourceKind: Value(v)));
    }
    for (final v in SourceClass.values) {
      await insertObservation(base().copyWith(sourceClass: Value(v)));
    }
    for (final v in TzSource.values) {
      await insertObservation(base().copyWith(tzSource: Value(v)));
    }
    for (final v in Stat.values.where((s) => s != Stat.none)) {
      await insertObservation(base().copyWith(stat: Value(v)));
    }
    for (final v in Comparator.values) {
      await insertObservation(
        base().copyWith(comparator: Value(v), refComparator: Value(v)),
      );
    }
    for (final v in Flag.values) {
      await insertObservation(base().copyWith(flag: Value(v)));
    }
    for (final v in ValueKind.values) {
      await insertObservation(
        base().copyWith(
          valueKind: Value(v),
          dataAbsentReason: const Value('not-performed'),
        ),
      );
    }
  });

  test('coding accepts every outcome and cause', () async {
    final decisionId = await insertDecision(db);
    for (final outcome in CodingOutcome.values) {
      final observationId = await db
          .into(db.observation)
          .insert(base().copyWith(sourceRef: Value('coding:${outcome.wire}')));
      final coded = outcome == CodingOutcome.coded;
      await db
          .into(db.codingCurrent)
          .insert(
            codedAs(
              observationId: observationId,
              decisionId: decisionId,
              outcome: outcome,
              code: coded ? '2498-4' : null,
              reason: coded ? '' : 'test',
            ),
          );
      for (final cause in CodingCause.values) {
        await db
            .into(db.codingHistory)
            .insert(
              CodingHistoryCompanion.insert(
                observationId: observationId,
                cause: cause,
                terminologyRelease: testRelease,
                outcome: outcome,
                seriesId: 'local:test',
                decisionId: decisionId,
                codedAt: testNow,
              ),
            );
      }
    }
  });

  test('person and extraction accept every enum value', () async {
    for (final sex in Sex.values) {
      await db
          .into(db.person)
          .insert(
            PersonCompanion.insert(
              displayName: sex.wire,
              defaultTz: 'UTC',
              createdAt: testNow,
              sex: Value(sex),
            ),
          );
    }
    for (final status in ExtractionStatus.values) {
      await db
          .into(db.extraction)
          .insert(
            ExtractionCompanion.insert(
              personId: personId,
              sourceKind: SourceKind.manual,
              sourceRef: 'extraction:${status.wire}',
              extractor: 'manual',
              status: status,
              reason: const Value('test'),
              payload: const Value('[]'),
              digest: 'd' * 64,
              createdAt: testNow,
            ),
          );
    }
  });
}
