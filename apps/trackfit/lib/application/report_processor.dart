import 'package:flutter/foundation.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../data/file_store.dart';
import '../platform/images/downscale.dart';
import '../platform/ocr/ocr.dart';

/// Runs after the text of a report was recognized, e.g. reading values.
typedef AfterRecognition = Future<void> Function(int reportId);

/// Recognizes the text of a report, file by file.
class ReportProcessor {
  ReportProcessor({
    required ReportRepository reports,
    required PageRepository pages,
    required FileStore fileStore,
    required Ocr ocr,
    this.afterRecognition,
    DateTime Function()? clock,
  }) : _reports = reports,
       _pages = pages,
       _fileStore = fileStore,
       _ocr = ocr,
       _clock = clock ?? DateTime.now;

  final ReportRepository _reports;
  final PageRepository _pages;
  final FileStore _fileStore;
  final Ocr _ocr;
  final DateTime Function() _clock;

  /// Next step once all pages have text. Without it the report is ready
  /// for review right away.
  final AfterRecognition? afterRecognition;

  /// Recognizes all files of [reportId] that have no text yet.
  ///
  /// Failures end in [ReportStatus.failed] with a reason; pages recognized
  /// before the failure are kept, so a retry only sends the rest.
  Future<void> process(int reportId) async {
    await _reports.setStatus(reportId, ReportStatus.ocr);
    try {
      for (final file in await _reports.getFiles(reportId)) {
        if (await _pages.hasPages(file.id, _ocr.origin)) continue;
        final bytes = await _fileStore.resolve(file.storedPath).readAsBytes();
        final document = switch (file.kind) {
          FileKind.image => await _prepareImage(bytes, file.mimeType),
          _ => OcrDocument(bytes: bytes, mimeType: file.mimeType),
        };
        final pages = await _ocr.read(document);
        await _pages.savePages(
          sourceFileId: file.id,
          textOrigin: _ocr.origin,
          pages: [
            for (final page in pages)
              NewPage(pageIx: page.index, markdown: page.markdown),
          ],
          now: _clock().toUtc(),
        );
      }
    } on OcrException catch (error) {
      await _reports.setStatus(
        reportId,
        ReportStatus.failed,
        error: error.message,
      );
      return;
    } on Object catch (error) {
      debugPrint('Recognition failed: ${error.runtimeType}');
      await _reports.setStatus(
        reportId,
        ReportStatus.failed,
        error: 'unexpected error (${error.runtimeType})',
      );
      return;
    }
    final next = afterRecognition;
    if (next == null) {
      await _reports.setStatus(reportId, ReportStatus.review);
    } else {
      await next(reportId);
    }
  }

  Future<OcrDocument> _prepareImage(Uint8List bytes, String mimeType) async {
    final prepared = await downscaleForRecognition(bytes, mimeType);
    return OcrDocument(bytes: prepared.bytes, mimeType: prepared.mimeType);
  }
}
