import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../database.dart';

/// Raw results of reading reports, kept verbatim.
class ExtractionRepository {
  ExtractionRepository(this._db);

  final TrackfitDatabase _db;

  /// Stores the result of reading [reportId] with [extractor].
  ///
  /// Storing the same payload again returns the existing row.
  Future<int> save({
    required int personId,
    required int reportId,
    required String extractor,
    required ExtractionStatus status,
    required DateTime now,
    String? payload,
    String reason = '',
  }) async {
    final sourceRef = 'report:$reportId';
    final digest = sha256
        .convert(utf8.encode('$sourceRef\n$extractor\n${payload ?? ''}'))
        .toString();
    final existing =
        await (_db.select(_db.extraction)..where(
              (e) => e.sourceRef.equals(sourceRef) & e.digest.equals(digest),
            ))
            .getSingleOrNull();
    if (existing != null) return existing.id;
    return _db
        .into(_db.extraction)
        .insert(
          ExtractionCompanion.insert(
            personId: personId,
            sourceKind: SourceKind.file,
            sourceRef: sourceRef,
            reportId: Value(reportId),
            extractor: extractor,
            status: status,
            reason: Value(reason),
            payload: Value(payload),
            digest: digest,
            createdAt: now,
          ),
        );
  }

  /// The newest extraction of [reportId] that has a payload.
  Future<ExtractionRow?> latestUsable(int reportId) =>
      (_db.select(_db.extraction)
            ..where(
              (e) =>
                  e.reportId.equals(reportId) &
                  e.status.equalsValue(ExtractionStatus.failed).not(),
            )
            ..orderBy([(e) => OrderingTerm.desc(e.id)])
            ..limit(1))
          .getSingleOrNull();
}
