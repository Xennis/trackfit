import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database_providers.dart';
import '../platform/ocr/mistral_ocr.dart';
import '../platform/ocr/ocr.dart';
import 'processing_queue.dart';
import 'recognition_settings.dart';
import 'report_processor.dart';

/// Creates the OCR for an API key. Tests replace it with a fake.
final ocrFactoryProvider = Provider<Ocr Function(String apiKey)>(
  (ref) =>
      (apiKey) => MistralOcr(apiKey: apiKey),
);

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
      );
    },
  );
  ref.listen(recognitionSettingsProvider, (_, _) => queue.poke());
  unawaited(reports.resetInterrupted().then((_) => queue.start()));
  ref.onDispose(queue.dispose);
  return queue;
});
