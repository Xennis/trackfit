import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../../app/router.dart';
import '../../application/delete_report.dart';
import '../../data/database_providers.dart';
import '../../l10n/generated/app_localizations.dart';
import 'delete_report_dialog.dart';
import 'original_view.dart';
import 'processing_banner.dart';
import 'report_date_picker.dart';
import 'report_labels.dart';
import 'report_providers.dart';
import 'report_values_view.dart';
import 'text_view.dart';

/// Width from which the original and the values are shown side by side.
const sideBySideBreakpoint = 1000.0;

/// One report with its original files, recognized text and values.
class ReportDetailPage extends ConsumerStatefulWidget {
  const ReportDetailPage({required this.reportId, super.key});

  final int reportId;

  @override
  ConsumerState<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends ConsumerState<ReportDetailPage> {
  final _focus = ValueNotifier<FilePage?>(null);

  int get reportId => widget.reportId;

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  /// Shows the page of the original a value was read from.
  void _openPage(BuildContext tabContext, int reportPageIx) {
    final pages = ref.read(reportPagesProvider(reportId)).value ?? const [];
    for (final page in pages) {
      if (page.reportPageIx == reportPageIx) {
        _focus.value = (fileId: page.sourceFileId, pageIx: page.filePageIx);
        break;
      }
    }
    DefaultTabController.maybeOf(tabContext)?.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final report = ref.watch(reportProvider(reportId)).value;
    final files = ref.watch(reportFilesProvider(reportId)).value ?? const [];
    if (ref.watch(reportProvider(reportId)) case AsyncData(value: null)) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.reportNotFound)),
      );
    }
    final wide = MediaQuery.sizeOf(context).width >= sideBySideBreakpoint;
    final original = OriginalView(files: files, focus: _focus);
    final tabs = [
      if (!wide) Tab(text: l10n.reportTabOriginal),
      Tab(text: l10n.reportTabValues),
      Tab(text: l10n.reportTabText),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (tabContext) {
          final tabViews = TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              if (!wide) original,
              ReportValuesView(
                reportId: reportId,
                onOpenPage: (page) => _openPage(tabContext, page),
              ),
              TextView(reportId: reportId),
            ],
          );
          return Scaffold(
            appBar: AppBar(
              title: Text(report == null ? '' : reportTitle(context, report)),
              actions: [
                PopupMenuButton<_Action>(
                  onSelected: (action) => switch (action) {
                    _Action.changeDate =>
                      report == null
                          ? null
                          : pickReportDate(context, ref, report),
                    _Action.reprocess => _reprocess(context),
                    _Action.delete => _delete(context, ref),
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _Action.changeDate,
                      child: Text(l10n.reportChangeDate),
                    ),
                    PopupMenuItem(
                      value: _Action.reprocess,
                      child: Text(l10n.reportReprocess),
                    ),
                    PopupMenuItem(
                      value: _Action.delete,
                      child: Text(l10n.reportDelete),
                    ),
                  ],
                ),
              ],
              bottom: wide ? null : TabBar(tabs: tabs),
            ),
            body: Column(
              children: [
                if (report != null) ProcessingBanner(report: report),
                Expanded(
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: original),
                            const VerticalDivider(width: 1),
                            Expanded(
                              child: Column(
                                children: [
                                  TabBar(tabs: tabs),
                                  Expanded(child: tabViews),
                                ],
                              ),
                            ),
                          ],
                        )
                      : tabViews,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Queues the report again. Recognized pages are kept, so only the values
  /// are read again; corrections made by the person stay.
  Future<void> _reprocess(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await ref
        .read(reportRepositoryProvider)
        .setStatus(reportId, ReportStatus.pending);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.reportReprocessStarted)),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final summaries = ref.read(reportSummariesProvider).value ?? const [];
    final valueCount = summaries
        .where((s) => s.r.id == reportId)
        .fold(0, (sum, s) => sum + s.valueCount);
    final deleteValues = await showDeleteReportDialog(
      context,
      hasValues: valueCount > 0,
    );
    if (deleteValues == null || !context.mounted) return;
    context.go(Routes.reports);
    await deleteReport(
      reports: ref.read(reportRepositoryProvider),
      fileStore: await ref.read(fileStoreProvider.future),
      reportId: reportId,
      deleteValues: deleteValues,
    );
    messenger.showSnackBar(SnackBar(content: Text(l10n.reportDeleted)));
  }
}

enum _Action { changeDate, reprocess, delete }
