import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../platform/llm/lab_report_extractor.dart';
import '../platform/llm/mistral_chat.dart';
import 'reading_builder.dart';

/// Reads the values of a recognized report and writes them.
class ReportExtraction {
  ReportExtraction({
    required TrackfitDatabase db,
    required this.coder,
    this.extractor,
    DateTime Function()? clock,
  }) : _db = db,
       _reports = ReportRepository(db),
       _pages = PageRepository(db),
       _extractions = ExtractionRepository(db),
       _observations = ObservationRepository(db),
       _clock = clock ?? DateTime.now;

  final TrackfitDatabase _db;
  final ReportRepository _reports;
  final PageRepository _pages;
  final ExtractionRepository _extractions;
  final ObservationRepository _observations;
  final DateTime Function() _clock;
  final Coder coder;

  /// Null when no language model is available; then only [writeReadings]
  /// can be used.
  final LabReportExtractor? extractor;

  /// Reads the values of [reportId] from its recognized pages.
  Future<void> run(int reportId) async {
    final extractor = this.extractor;
    final report = await _reports.getReport(reportId);
    if (extractor == null || report == null) return;
    await _reports.setStatus(reportId, ReportStatus.extracting);
    final now = _clock().toUtc();
    try {
      final pages = await _pages.reportPages(reportId);
      final origin = pages.isEmpty ? null : pages.first.textOrigin;
      final result = await extractor.extract([
        for (final page in pages.where((p) => p.textOrigin == origin))
          ExtractorPage(number: page.reportPageIx + 1, markdown: page.markdown),
      ]);
      await _extractions.save(
        personId: report.personId,
        reportId: reportId,
        extractor: extractor.id,
        status: result.skipped == 0
            ? ExtractionStatus.ok
            : ExtractionStatus.unverified,
        reason: result.skipped == 0
            ? ''
            : '${result.skipped} invalid rows skipped',
        payload: jsonEncode(result.toJson()),
        now: now,
      );
      await _reports.setReportInfo(
        reportId,
        reportDate: result.reportDate,
        labName: result.labName,
      );
      await writeReadings(reportId);
      await _reports.setStatus(reportId, ReportStatus.review);
    } on LlmException catch (error) {
      await _fail(report, extractor.id, error.message, now);
    } on Object catch (error) {
      debugPrint('Extraction failed: ${error.runtimeType}');
      await _fail(
        report,
        extractor.id,
        'unexpected error (${error.runtimeType})',
        now,
      );
    }
  }

  Future<void> _fail(
    ReportRow report,
    String extractorId,
    String message,
    DateTime now,
  ) async {
    await _extractions.save(
      personId: report.personId,
      reportId: report.id,
      extractor: extractorId,
      status: ExtractionStatus.failed,
      reason: message,
      now: now,
    );
    await _reports.setStatus(report.id, ReportStatus.failed, error: message);
  }

  /// Writes the readings of the latest extraction of [reportId].
  ///
  /// Does nothing while the report has no date: a reading without a day
  /// cannot be placed in a history.
  Future<void> writeReadings(int reportId) async {
    final report = await _reports.getReport(reportId);
    final reportDate = report?.reportDate;
    final extraction = await _extractions.latestUsable(reportId);
    final payload = extraction?.payload;
    if (report == null || reportDate == null || payload == null) return;

    final person = await (_db.select(
      _db.person,
    )..where((p) => p.id.equals(report.personId))).getSingle();
    final result = ExtractionResult.fromJson(
      jsonDecode(payload) as Map<String, Object?>,
    );
    final source = ReadingSource(
      personId: report.personId,
      reportId: reportId,
      extractionId: extraction!.id,
      reportDate: reportDate,
      timeZone: person.defaultTz,
      now: _clock().toUtc(),
    );
    await _observations.replaceReportReadings(reportId, [
      for (final (row, draft) in result.results.indexed)
        buildLabReading(
          standardizeDraft(draft, coder),
          source,
          rowIx: row,
          terminologyRelease: coder.release,
        ),
    ], now: source.now);
  }
}
