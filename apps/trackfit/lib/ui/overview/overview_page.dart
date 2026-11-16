import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../application/recognition_settings.dart';
import '../../data/database_providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../charts/sparkline.dart';
import '../common/content_width.dart';
import '../common/empty_state.dart';
import '../import/import_flow.dart';
import '../reports/report_labels.dart';
import '../reports/report_providers.dart';
import '../reports/reports_page.dart';
import '../shell/app_shell.dart';
import '../values/series_view_model.dart';
import '../values/value_format.dart';
import '../values/values_providers.dart';

/// Start page: what is new, what is abnormal, what needs attention.
class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final reports = ref.watch(reportSummariesProvider).value;
    final series = ref.watch(seriesListProvider).value ?? const [];
    final questions = ref.watch(openQuestionsProvider).value ?? const [];
    final ready = ref.watch(recognitionSettingsProvider).value?.ready ?? false;

    final Widget body;
    if (reports == null) {
      body = const Center(child: CircularProgressIndicator());
    } else if (reports.isEmpty) {
      body = EmptyState(
        icon: Icons.note_add_outlined,
        title: l10n.overviewEmptyTitle,
        body: l10n.overviewEmptyBody,
      );
    } else {
      final processing = reports
          .where((r) => isRunning(r.r.status, recognitionReady: ready))
          .length;
      final waiting = reports
          .where((r) => needsSetup(r.r.status, recognitionReady: ready))
          .length;
      final openCount = questions.fold(0, (n, q) => n + q.readings.length);
      final abnormal = series.where((s) => s.isAbnormal).toList();
      body = ContentWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            if (openCount > 0)
              _Notice(
                icon: Icons.help_outline,
                text: l10n.questionsBanner(openCount),
                onTap: () => context.go(Routes.questions),
              ),
            if (waiting > 0)
              _Notice(
                icon: Icons.settings_outlined,
                text: l10n.overviewNeedsSetup(waiting),
                onTap: () => context.go(Routes.recognitionSettings),
              ),
            if (processing > 0)
              _Notice(
                icon: Icons.hourglass_top,
                text: l10n.overviewProcessing(processing),
                onTap: () => context.go(Routes.reports),
              ),
            const SizedBox(height: 8),
            Text(l10n.overviewAbnormal, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (abnormal.isEmpty)
              Text(
                l10n.overviewNoAbnormal,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [for (final s in abnormal) _AbnormalCard(series: s)],
              ),
            const SizedBox(height: 24),
            Text(l10n.overviewLatestReport, style: theme.textTheme.titleMedium),
            ReportTile(summary: reports.first),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        // Wide windows show the name of the app in the sidebar.
        title: Text(
          MediaQuery.sizeOf(context).width < compactBreakpoint
              ? l10n.appTitle
              : l10n.navOverview,
        ),
      ),
      floatingActionButton: const ImportButton(),
      body: body,
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text, required this.onTap});

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card.filled(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      leading: Icon(icon),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

class _AbnormalCard extends StatelessWidget {
  const _AbnormalCard({required this.series});

  final SeriesView series;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 168,
      child: Card.outlined(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.go(Routes.value(series.summary.key)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  series.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        formatPrintedValue(series.latest),
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    FlagMark(series.latest.flag),
                  ],
                ),
                const SizedBox(height: 8),
                Sparkline(
                  values: [for (final p in series.points) p.value],
                  width: 140,
                  highlightLast: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
