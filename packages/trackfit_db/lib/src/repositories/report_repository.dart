import 'package:drift/drift.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../database.dart';

/// A file to add to a new report, already stored on disk.
class NewSourceFile {
  const NewSourceFile({
    required this.contentHash,
    required this.fileName,
    required this.mimeType,
    required this.byteSize,
    required this.storedPath,
    required this.kind,
    required this.importChannel,
  });

  final String contentHash;
  final String fileName;
  final String mimeType;
  final int byteSize;
  final String storedPath;
  final FileKind kind;
  final ImportChannel importChannel;
}

/// A file of a new report was imported before.
class DuplicateFileException implements Exception {
  const DuplicateFileException(this.existing);

  /// The file that was imported first.
  final SourceFileRow existing;

  @override
  String toString() =>
      'DuplicateFileException(report ${existing.reportId}, '
      'file ${existing.id})';
}

/// One row of the report list.
typedef ReportSummary = ReportSummariesResult;

/// Reports and their files.
class ReportRepository {
  ReportRepository(this._db);

  final TrackfitDatabase _db;

  /// The file with [contentHash] the person imported before, if any.
  Future<SourceFileRow?> findFileByHash(int personId, String contentHash) =>
      (_db.select(_db.sourceFile)..where(
            (f) =>
                f.personId.equals(personId) & f.contentHash.equals(contentHash),
          ))
          .getSingleOrNull();

  /// Creates a pending report with [files] in this order.
  ///
  /// Throws a [DuplicateFileException] when one of the files was imported
  /// before; nothing is written then.
  Future<int> createReport({
    required int personId,
    required List<NewSourceFile> files,
    required DateTime now,
  }) {
    if (files.isEmpty) {
      throw ArgumentError.value(files, 'files', 'must not be empty');
    }
    return _db.transaction(() async {
      for (final file in files) {
        final existing = await findFileByHash(personId, file.contentHash);
        if (existing != null) throw DuplicateFileException(existing);
      }
      final reportId = await _db
          .into(_db.report)
          .insert(ReportCompanion.insert(personId: personId, createdAt: now));
      for (final (position, file) in files.indexed) {
        await _db
            .into(_db.sourceFile)
            .insert(
              SourceFileCompanion.insert(
                personId: personId,
                reportId: reportId,
                position: position,
                contentHash: file.contentHash,
                fileName: file.fileName,
                mimeType: file.mimeType,
                byteSize: file.byteSize,
                storedPath: file.storedPath,
                kind: file.kind,
                importChannel: file.importChannel,
                importedAt: now,
              ),
            );
      }
      return reportId;
    });
  }

  /// Reports of [personId] for the list, updated on every change.
  Stream<List<ReportSummary>> watchSummaries(int personId) =>
      _db.reportSummaries(personId: personId).watch();

  /// The report with [reportId], or null after it was deleted.
  Stream<ReportRow?> watchReport(int reportId) => (_db.select(
    _db.report,
  )..where((r) => r.id.equals(reportId))).watchSingleOrNull();

  Future<ReportRow?> getReport(int reportId) => (_db.select(
    _db.report,
  )..where((r) => r.id.equals(reportId))).getSingleOrNull();

  /// Files of [reportId] in their order.
  Stream<List<SourceFileRow>> watchFiles(int reportId) =>
      (_db.select(_db.sourceFile)
            ..where((f) => f.reportId.equals(reportId))
            ..orderBy([(f) => OrderingTerm.asc(f.position)]))
          .watch();

  Future<List<SourceFileRow>> getFiles(int reportId) =>
      (_db.select(_db.sourceFile)
            ..where((f) => f.reportId.equals(reportId))
            ..orderBy([(f) => OrderingTerm.asc(f.position)]))
          .get();

  /// Ids of reports in [status], oldest first.
  Future<List<int>> reportIdsWithStatus(ReportStatus status) async {
    final rows =
        await (_db.select(_db.report)
              ..where((r) => r.status.equalsValue(status))
              ..orderBy([(r) => OrderingTerm.asc(r.createdAt)]))
            .get();
    return [for (final row in rows) row.id];
  }

  /// Puts reports back into the queue whose processing was interrupted,
  /// e.g. because the app was closed during recognition.
  Future<int> resetInterrupted() =>
      (_db.update(_db.report)..where(
            (r) => r.status.isInValues([
              ReportStatus.ocr,
              ReportStatus.extracting,
            ]),
          ))
          .write(const ReportCompanion(status: Value(ReportStatus.pending)));

  /// Pending reports, updated on every change.
  Stream<List<int>> watchPendingIds() =>
      (_db.select(_db.report)
            ..where((r) => r.status.equalsValue(ReportStatus.pending))
            ..orderBy([(r) => OrderingTerm.asc(r.createdAt)]))
          .map((row) => row.id)
          .watch();

  /// Sets the processing state; [error] is required for [ReportStatus.failed].
  Future<void> setStatus(
    int reportId,
    ReportStatus status, {
    String error = '',
  }) => (_db.update(_db.report)..where((r) => r.id.equals(reportId))).write(
    ReportCompanion(status: Value(status), error: Value(error)),
  );

  /// Deletes a report with its files, pages and extractions.
  ///
  /// Values read from the report are deleted too when [deleteValues] is set;
  /// otherwise they stay and only lose the link to the report. Returns the
  /// stored paths of the deleted files, for removing them from disk.
  Future<List<String>> deleteReport(
    int reportId, {
    required bool deleteValues,
  }) => _db.transaction(() async {
    final files = await getFiles(reportId);
    final observations = _db.observation;
    if (deleteValues) {
      // Corrections point at the rows they amend, so delete newest first.
      final rows =
          await (_db.select(observations)
                ..where((o) => o.reportId.equals(reportId))
                ..orderBy([(o) => OrderingTerm.desc(o.id)]))
              .get();
      for (final row in rows) {
        await (_db.delete(
          observations,
        )..where((o) => o.id.equals(row.id))).go();
      }
    } else {
      await (_db.update(
        observations,
      )..where((o) => o.reportId.equals(reportId))).write(
        const ObservationCompanion(
          reportId: Value(null),
          extractionId: Value(null),
        ),
      );
    }
    await (_db.delete(_db.report)..where((r) => r.id.equals(reportId))).go();
    return [for (final file in files) file.storedPath];
  });
}
