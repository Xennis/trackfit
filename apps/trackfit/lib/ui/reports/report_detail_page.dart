import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../common/empty_state.dart';
import 'original_view.dart';
import 'report_labels.dart';
import 'report_providers.dart';

/// One report with its original files, recognized text and values.
class ReportDetailPage extends ConsumerWidget {
  const ReportDetailPage({required this.reportId, super.key});

  final int reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final report = ref.watch(reportProvider(reportId)).value;
    final files = ref.watch(reportFilesProvider(reportId)).value ?? const [];
    if (ref.watch(reportProvider(reportId)) case AsyncData(value: null)) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.reportNotFound)),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(report == null ? '' : reportTitle(context, report)),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.reportTabOriginal),
              Tab(text: l10n.reportTabText),
              Tab(text: l10n.reportTabValues),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            OriginalView(files: files),
            EmptyState(
              icon: Icons.notes_outlined,
              title: l10n.reportTabText,
              body: l10n.reportTextEmpty,
            ),
            EmptyState(
              icon: Icons.list_alt_outlined,
              title: l10n.reportTabValues,
              body: l10n.reportValuesEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
