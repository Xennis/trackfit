import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:standardize/standardize.dart';

import '../../app/router.dart';
import '../../application/processing_providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../charts/history_chart.dart';
import '../common/content_width.dart';
import '../common/list_card.dart';
import '../reports/report_labels.dart';
import 'series_view_model.dart';
import 'value_format.dart';
import 'values_providers.dart';

enum _Range { oneYear, threeYears, all }

/// History of one value: chart with reference ranges and all measurements.
class ValueDetailPage extends ConsumerStatefulWidget {
  const ValueDetailPage({required this.seriesKey, super.key});

  final String seriesKey;

  @override
  ConsumerState<ValueDetailPage> createState() => _ValueDetailPageState();
}

class _ValueDetailPageState extends ConsumerState<ValueDetailPage> {
  _Range _range = _Range.all;
  String? _unit;

  DateTime? get _since => switch (_range) {
    _Range.oneYear => DateTime.now().subtract(const Duration(days: 365)),
    _Range.threeYears => DateTime.now().subtract(const Duration(days: 3 * 365)),
    _Range.all => null,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final series = ref.watch(seriesProvider(widget.seriesKey));
    return switch (series) {
      AsyncData(value: final view?) => _build(context, view),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.valueNotFound)),
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.loadFailed)),
      ),
      _ => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
    };
  }

  /// Units the analyte can be shown in, with its molar mass.
  (List<String>, double?) _unitOptions(SeriesView view) {
    final coder = ref.watch(coderProvider).value;
    final group = view.latest.groupId;
    if (coder is! LexicalCoder || group == null) return ([view.unit], null);
    final members = coder.terminology.membersOf(group);
    final molarMass = members.map((m) => m.molarMass).nonNulls.firstOrNull;
    final units = <String>{view.unit};
    for (final member in members) {
      units.addAll(member.units);
    }
    final convertible = [
      for (final unit in units)
        if (view.inUnit(unit, molarMass: molarMass) != null) unit,
    ];
    return (convertible, molarMass);
  }

  Widget _build(BuildContext context, SeriesView original) {
    final l10n = AppLocalizations.of(context);
    final (units, molarMass) = _unitOptions(original);
    final view =
        (_unit == null
            ? null
            : original.inUnit(_unit!, molarMass: molarMass)) ??
        original;
    final theme = Theme.of(context);
    final latest = view.latest;
    final points = view.pointsSince(_since);
    return Scaffold(
      appBar: AppBar(title: Text(view.name)),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  formatPrintedValue(latest),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(width: 8),
                FlagMark(latest.flag, size: 28),
                const SizedBox(width: 8),
                Text(
                  l10n.valueLatestOn(
                    formatDay(context, DateTime.parse(latest.localDate)),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SegmentedButton<_Range>(
                  segments: [
                    ButtonSegment(
                      value: _Range.oneYear,
                      label: Text(l10n.valueRange1y),
                    ),
                    ButtonSegment(
                      value: _Range.threeYears,
                      label: Text(l10n.valueRange3y),
                    ),
                    ButtonSegment(
                      value: _Range.all,
                      label: Text(l10n.valueRangeAll),
                    ),
                  ],
                  selected: {_range},
                  onSelectionChanged: (value) =>
                      setState(() => _range = value.first),
                ),
                if (units.length > 1)
                  DropdownButton<String>(
                    value: view.unit,
                    items: [
                      for (final unit in units)
                        DropdownMenuItem(value: unit, child: Text(unit)),
                    ],
                    onChanged: (unit) => setState(() => _unit = unit),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (view.points.isEmpty)
              Text(l10n.valueNoChart)
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 20, 8),
                  child: HistoryChart(
                    points: points,
                    unit: view.unit,
                    onSelect: (point) => _showPoint(context, point),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text(l10n.valueHistory, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ListCard(
              children: [
                for (final reading in view.summary.history.reversed)
                  ListTile(
                    title: Text(
                      formatDay(context, DateTime.parse(reading.localDate)),
                    ),
                    subtitle: reading.refText.isEmpty
                        ? null
                        : Text(l10n.valueReference(reading.refText)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formatPrintedValue(reading),
                          style: const TextStyle(
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(width: 4),
                        FlagMark(reading.flag),
                      ],
                    ),
                    onTap: reading.reportId == null
                        ? null
                        : () => context.go(Routes.report(reading.reportId!)),
                  ),
              ],
            ),
            if (latest.code != null) ...[
              const SizedBox(height: 24),
              Text(l10n.valueAbout, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(l10n.valueCode(latest.code!)),
              if ((latest.display ?? '').isNotEmpty)
                Text(
                  latest.display!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  /// Where a measurement comes from, with a way to open its report.
  void _showPoint(BuildContext context, SeriesPoint point) {
    final l10n = AppLocalizations.of(context);
    final reading = point.reading;
    final reportId = reading.reportId;
    showModalBottomSheet<void>(
      context: context,
      // Above the navigation bar of the shell, not inside the tab.
      useRootNavigator: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                MaterialLocalizations.of(
                  sheetContext,
                ).formatFullDate(point.date),
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text('${reading.nameText}: ${formatPrintedValue(reading)}'),
              if (reading.refText.isNotEmpty)
                Text(l10n.valueReference(reading.refText)),
              if (reading.pageIx != null)
                Text(l10n.valuePage(reading.pageIx! + 1)),
              if (reportId != null) ...[
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    context.go(Routes.report(reportId));
                  },
                  child: Text(l10n.valueOpenReport),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
