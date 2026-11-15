import 'package:drift/drift.dart';

import '../database.dart';

/// Recognized text of a page, ready to store.
class NewPage {
  const NewPage({required this.pageIx, required this.markdown});

  final int pageIx;
  final String markdown;
}

/// Recognized text of the pages of a report.
class PageRepository {
  PageRepository(this._db);

  final TrackfitDatabase _db;

  /// Stores the pages of one file recognized by [textOrigin], replacing a
  /// previous result of the same origin.
  Future<void> savePages({
    required int sourceFileId,
    required String textOrigin,
    required List<NewPage> pages,
    required DateTime now,
  }) => _db.transaction(() async {
    await (_db.delete(_db.sourcePage)..where(
          (p) =>
              p.sourceFileId.equals(sourceFileId) &
              p.textOrigin.equals(textOrigin),
        ))
        .go();
    for (final page in pages) {
      await _db
          .into(_db.sourcePage)
          .insert(
            SourcePageCompanion.insert(
              sourceFileId: sourceFileId,
              pageIx: page.pageIx,
              textOrigin: textOrigin,
              markdown: page.markdown,
              createdAt: now,
            ),
          );
    }
  });

  /// Whether a file already has text from [textOrigin].
  Future<bool> hasPages(int sourceFileId, String textOrigin) async {
    final count = _db.sourcePage.sourceFileId.count();
    final query = _db.selectOnly(_db.sourcePage)
      ..addColumns([count])
      ..where(
        _db.sourcePage.sourceFileId.equals(sourceFileId) &
            _db.sourcePage.textOrigin.equals(textOrigin),
      );
    return (await query.map((row) => row.read(count)).getSingle())! > 0;
  }

  Selectable<VReportPageData> _reportPages(int reportId, String? textOrigin) =>
      _db.select(_db.vReportPage)
        ..where(
          (p) =>
              p.reportId.equals(reportId) &
              (textOrigin == null
                  ? const Constant(true)
                  : p.textOrigin.equals(textOrigin)),
        )
        ..orderBy([
          (p) => OrderingTerm.asc(p.textOrigin),
          (p) => OrderingTerm.asc(p.reportPageIx),
        ]);

  /// Pages of a report counted across its files.
  Future<List<VReportPageData>> reportPages(
    int reportId, {
    String? textOrigin,
  }) => _reportPages(reportId, textOrigin).get();

  Stream<List<VReportPageData>> watchReportPages(int reportId) =>
      _reportPages(reportId, null).watch();
}
