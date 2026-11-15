import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../../l10n/generated/app_localizations.dart';
import '../common/empty_state.dart';
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
    if (readings.isEmpty) {
      return EmptyState(
        icon: Icons.list_alt_outlined,
        title: l10n.reportTabValues,
        body: l10n.reportValuesEmpty,
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
            _ValueTile(reading: reading, onOpenPage: onOpenPage),
        ],
      ],
    );
  }
}

class _ValueTile extends StatelessWidget {
  const _ValueTile({required this.reading, this.onOpenPage});

  final VObservationData reading;
  final ValueChanged<int>? onOpenPage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final open = reading.outcome != CodingOutcome.coded;
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
      onTap: page == null || onOpenPage == null
          ? null
          : () => onOpenPage!(page),
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
