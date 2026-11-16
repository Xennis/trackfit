import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../../app/router.dart';
import '../../application/recognition_settings.dart';
import '../../l10n/generated/app_localizations.dart';
import '../common/content_width.dart';
import '../common/empty_state.dart';
import '../import/import_flow.dart';
import 'report_labels.dart';
import 'report_providers.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summaries = ref.watch(reportSummariesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navReports)),
      floatingActionButton: const ImportButton(),
      body: switch (summaries) {
        AsyncData(value: final list) when list.isEmpty => EmptyState(
          icon: Icons.description_outlined,
          title: l10n.reportsEmptyTitle,
          body: l10n.reportsEmptyBody,
          hint: isDesktop ? l10n.importDropHint : null,
        ),
        AsyncData(value: final list) => ContentWidth(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) => ReportTile(summary: list[index]),
          ),
        ),
        AsyncError() => Center(child: Text(l10n.loadFailed)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// One report in the list.
class ReportTile extends ConsumerWidget {
  const ReportTile({required this.summary, super.key});

  final ReportSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ready = ref.watch(recognitionSettingsProvider).value?.ready ?? false;
    final theme = Theme.of(context);
    final report = summary.r;
    final details = [
      if (report.labName.isNotEmpty) report.labName,
      if (summary.fileCount > 1) l10n.reportFiles(summary.fileCount),
      if (needsSetup(report.status, recognitionReady: ready))
        l10n.reportStatusNeedsSetup
      else if (isProcessing(report.status) ||
          report.status == ReportStatus.failed)
        reportStatusLabel(l10n, report.status)
      else
        l10n.reportValues(summary.valueCount),
      if (summary.openCount > 0) l10n.reportOpenQuestions(summary.openCount),
    ];
    return ListTile(
      leading: Icon(
        summary.firstFileKind == FileKind.pdf
            ? Icons.picture_as_pdf_outlined
            : Icons.image_outlined,
      ),
      title: Text(reportTitle(context, report)),
      subtitle: Text(
        details.join(' · '),
        style: report.status == ReportStatus.failed
            ? TextStyle(color: theme.colorScheme.error)
            : null,
      ),
      trailing: isRunning(report.status, recognitionReady: ready)
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_right),
      onTap: () => context.go(Routes.report(report.id)),
    );
  }
}
