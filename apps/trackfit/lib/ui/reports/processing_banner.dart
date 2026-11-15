import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../../app/router.dart';
import '../../application/recognition_settings.dart';
import '../../data/database_providers.dart';
import '../../l10n/generated/app_localizations.dart';
import 'report_date_picker.dart';
import 'report_labels.dart';

/// State of the recognition of a report, with the next action if any.
class ProcessingBanner extends ConsumerWidget {
  const ProcessingBanner({required this.report, super.key});

  final ReportRow report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ready = ref.watch(recognitionSettingsProvider).value?.ready ?? false;
    final status = report.status;

    if (status == ReportStatus.failed) {
      return MaterialBanner(
        leading: const Icon(Icons.error_outline),
        content: Text(l10n.reportFailedReason(report.error)),
        actions: [
          TextButton(
            onPressed: () => ref
                .read(reportRepositoryProvider)
                .setStatus(report.id, ReportStatus.pending),
            child: Text(l10n.reportRetry),
          ),
        ],
      );
    }
    if (status == ReportStatus.pending && !ready) {
      return MaterialBanner(
        leading: const Icon(Icons.info_outline),
        content: Text(l10n.reportWaitingForSetup),
        actions: [
          TextButton(
            onPressed: () => context.go(Routes.recognitionSettings),
            child: Text(l10n.reportSetUpRecognition),
          ),
        ],
      );
    }
    if (isProcessing(status)) {
      return MaterialBanner(
        leading: const SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        content: Text(reportStatusLabel(l10n, status)),
        actions: const [SizedBox.shrink()],
      );
    }
    if (report.reportDate == null &&
        (status == ReportStatus.review || status == ReportStatus.done)) {
      return MaterialBanner(
        leading: const Icon(Icons.event_outlined),
        content: Text(l10n.reportDateMissing),
        actions: [
          TextButton(
            onPressed: () => pickReportDate(context, ref, report),
            child: Text(l10n.reportSetDate),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
