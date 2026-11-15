import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../../application/processing_providers.dart';

import '../../l10n/generated/app_localizations.dart';
import '../common/empty_state.dart';
import '../values/edit_value_dialog.dart';
import '../values/value_format.dart';
import 'report_providers.dart';

/// The values read from a report, grouped by the panels of the report.
class ReportValuesView extends ConsumerWidget {
  const ReportValuesView({required this.reportId, this.onOpenPage, super.key});

  final int reportId;

  /// Shows a page of the original, e.g. next to the values.
  final ValueChanged<int>? onOpenPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final readings = ref.watch(reportReadingsProvider(reportId)).value;
    if (readings == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final hasDate =
        ref.watch(reportProvider(reportId)).value?.reportDate != null;
    final addButton = Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: hasDate ? () => _add(context, ref) : null,
          icon: const Icon(Icons.add),
          label: Text(l10n.addValue),
        ),
      ),
    );
    if (readings.isEmpty) {
      return Column(
        children: [
          Expanded(
            child: EmptyState(
              icon: Icons.list_alt_outlined,
              title: l10n.reportTabValues,
              body: l10n.reportValuesEmpty,
            ),
          ),
          if (hasDate) addButton,
        ],
      );
    }
    final panels = <String, List<VObservationData>>{};
    for (final reading in readings) {
      panels.putIfAbsent(reading.panelText.trim(), () => []).add(reading);
    }
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        for (final MapEntry(key: panel, value: rows) in panels.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              panel.isEmpty ? l10n.valueOtherPanel : panel,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          for (final reading in rows)
            _ValueTile(
              reading: reading,
              onOpenPage: onOpenPage,
              onEdit: () => _edit(context, ref, reading),
            ),
        ],
        addButton,
      ],
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    VObservationData reading,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await showEditValueDialog(
      context,
      initial: ObservationDraft(
        name: reading.nameText,
        value: reading.valueText,
        unit: reading.unitText,
        reference: reading.refText,
        flag: reading.flagText,
        specimen: reading.specimenText,
        panel: reading.panelText,
      ),
    );
    if (result == null) return;
    final corrections = await ref.read(readingCorrectionsProvider.future);
    switch (result) {
      case SaveValue(:final draft):
        await corrections.edit(reading.id, draft);
        messenger.showSnackBar(SnackBar(content: Text(l10n.valueSaved)));
      case RetractValue():
        await corrections.retract(reading.id);
        messenger.showSnackBar(SnackBar(content: Text(l10n.valueRetracted)));
    }
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await showEditValueDialog(context);
    if (result is! SaveValue) return;
    final corrections = await ref.read(readingCorrectionsProvider.future);
    await corrections.addToReport(reportId, result.draft);
    messenger.showSnackBar(SnackBar(content: Text(l10n.valueSaved)));
  }
}

class _ValueTile extends StatelessWidget {
  const _ValueTile({
    required this.reading,
    required this.onEdit,
    this.onOpenPage,
  });

  final VObservationData reading;
  final VoidCallback onEdit;
  final ValueChanged<int>? onOpenPage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final open = reading.outcome == CodingOutcome.needsInput;
    final page = reading.pageIx;
    final details = [
      if (reading.refText.trim().isNotEmpty)
        l10n.valueReference(reading.refText.trim()),
      if (page != null) l10n.valuePage(page + 1),
      if (open) l10n.valueOpenQuestion,
    ];
    return ListTile(
      title: Text(readingName(reading)),
      subtitle: details.isEmpty ? null : Text(details.join(' · ')),
      onTap: onEdit,
      leading: page == null || onOpenPage == null
          ? null
          : IconButton(
              tooltip: l10n.showPage,
              icon: const Icon(Icons.find_in_page_outlined),
              onPressed: () => onOpenPage!(page),
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: Text(
              formatPrintedValue(reading),
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(width: 8),
          FlagMark(reading.flag),
        ],
      ),
    );
  }
}
