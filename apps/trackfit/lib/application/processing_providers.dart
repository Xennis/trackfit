import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../data/database_providers.dart';
import '../platform/llm/lab_report_extractor.dart';
import '../platform/llm/mistral_chat.dart';
import '../platform/ocr/mistral_ocr.dart';
import '../platform/ocr/ocr.dart';
import '../platform/terminology/terminology_loader.dart';
import 'processing_queue.dart';
import 'question_answers.dart';
import 'reading_corrections.dart';
import 'recognition_settings.dart';
import 'report_extraction.dart';
import 'report_processor.dart';

/// Creates the OCR for an API key. Tests replace it with a fake.
final ocrFactoryProvider = Provider<Ocr Function(String apiKey)>(
  (ref) =>
      (apiKey) => MistralOcr(apiKey: apiKey),
);

/// Creates the extractor for an API key. Tests replace it with a fake.
final extractorFactoryProvider =
    Provider<LabReportExtractor Function(String apiKey)>(
      (ref) =>
          (apiKey) => LabReportExtractor(MistralChat(apiKey: apiKey)),
    );

/// The bundled terminology, loaded once.
final terminologyProvider = FutureProvider<Terminology>(
  (ref) async => loadBundledTerminology(await getApplicationSupportDirectory()),
);

/// Assigns codes to readings. Without a terminology nothing is coded, and
/// readings wait as open questions.
final coderProvider = FutureProvider<Coder>((ref) async {
  try {
    final terminology = await ref.watch(terminologyProvider.future);
    final personId = await ref.watch(currentPersonIdProvider.future);
    final aliases = await QuestionRepository(
      ref.watch(databaseProvider),
    ).aliases(personId);
    return AliasCoder(LexicalCoder(terminology), [
      for (final alias in aliases)
        ConfirmedAlias(
          nameKey: alias.nameKey,
          unitUcum: alias.unitUcum,
          code: alias.code,
        ),
    ]);
  } on Object catch (error) {
    debugPrint('Terminology not available: ${error.runtimeType}');
    return const NoCoder();
  }
});

/// Reading values of reports, with the language model when one is set up.
final reportExtractionProvider = FutureProvider<ReportExtraction>((ref) async {
  final settings = await ref.watch(recognitionSettingsProvider.future);
  return ReportExtraction(
    db: ref.watch(databaseProvider),
    coder: await ref.watch(coderProvider.future),
    extractor: settings.ready
        ? ref.watch(extractorFactoryProvider)(settings.mistralApiKey!)
        : null,
  );
});

/// Background processing of pending reports, started with the app.
final processingQueueProvider = Provider<ProcessingQueue>((ref) {
  final reports = ref.watch(reportRepositoryProvider);
  final queue = ProcessingQueue(
    pending: reports.watchPendingIds(),
    processor: () async {
      final settings = await ref.read(recognitionSettingsProvider.future);
      if (!settings.ready) return null;
      return ReportProcessor(
        reports: reports,
        pages: ref.read(pageRepositoryProvider),
        fileStore: await ref.read(fileStoreProvider.future),
        ocr: ref.read(ocrFactoryProvider)(settings.mistralApiKey!),
        afterRecognition: (reportId) async =>
            (await ref.read(reportExtractionProvider.future)).run(reportId),
      );
    },
  );
  ref.listen(recognitionSettingsProvider, (_, _) => queue.poke());
  unawaited(reports.resetInterrupted().then((_) => queue.start()));
  ref.onDispose(queue.dispose);
  return queue;
});

/// Corrections a person makes to readings.
final readingCorrectionsProvider = FutureProvider<ReadingCorrections>(
  (ref) async => ReadingCorrections(
    db: ref.watch(databaseProvider),
    coder: await ref.watch(coderProvider.future),
  ),
);

/// Answers to open questions. Answering refreshes the coder, so later
/// imports know the answer too.
final questionAnswersProvider = Provider<QuestionAnswers>(
  (ref) => QuestionAnswers(
    db: ref.watch(databaseProvider),
    coder: () {
      ref.invalidate(coderProvider);
      return ref.read(coderProvider.future);
    },
  ),
);
