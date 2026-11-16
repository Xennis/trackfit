import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../data/database_providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../charts/range_bar.dart';
import '../charts/sparkline.dart';
import '../common/content_width.dart';
import '../common/empty_state.dart';
import '../common/list_card.dart';
import '../shell/app_shell.dart';
import 'series_view_model.dart';
import 'value_format.dart';
import 'values_providers.dart';

enum _Filter { all, abnormal, open }

/// All measured values, grouped by category, with their latest value.
class ValuesPage extends ConsumerStatefulWidget {
  const ValuesPage({super.key});

  @override
  ConsumerState<ValuesPage> createState() => _ValuesPageState();
}

class _ValuesPageState extends ConsumerState<ValuesPage> {
  _Filter _filter = _Filter.all;
  String _query = '';

  bool _matches(SeriesView series) {
    final query = _query.trim().toLowerCase();
    if (query.isNotEmpty &&
        !series.name.toLowerCase().contains(query) &&
        !series.latest.nameText.toLowerCase().contains(query)) {
      return false;
    }
    return switch (_filter) {
      _Filter.all => true,
      _Filter.abnormal => series.isAbnormal,
      _Filter.open => series.isOpen,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final all = ref.watch(seriesListProvider);
    final openCount = ref.watch(openQuestionsProvider).value?.length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navValues),
        actions: [
          if (openCount > 0)
            IconButton(
              tooltip: l10n.questionsTitle,
              onPressed: () => context.go(Routes.questions),
              icon: Badge.count(
                count: openCount,
                child: const Icon(Icons.help_outline),
              ),
            ),
        ],
      ),
      body: switch (all) {
        AsyncData(value: final list) when list.isEmpty => EmptyState(
          icon: Icons.show_chart_outlined,
          title: l10n.valuesEmptyTitle,
          body: l10n.valuesEmptyBody,
        ),
        AsyncData(value: final list) => _buildList(context, list),
        AsyncError() => Center(child: Text(l10n.loadFailed)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildList(BuildContext context, List<SeriesView> list) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final byCategory = <String, List<SeriesView>>{};
    for (final series in list.where(_matches)) {
      final category = categoryOrder.contains(series.category)
          ? series.category
          : '';
      byCategory.putIfAbsent(category, () => []).add(series);
    }
    final categories = [
      ...categoryOrder.where(byCategory.containsKey),
      if (byCategory.containsKey('')) '',
    ];
    return ContentWidth(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.navValues,
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Wrap(
              spacing: 8,
              children: [
                for (final (filter, label) in [
                  (_Filter.all, l10n.valuesFilterAll),
                  (_Filter.abnormal, l10n.valuesFilterAbnormal),
                  (_Filter.open, l10n.valuesFilterOpen),
                ])
                  ChoiceChip(
                    label: Text(label),
                    selected: _filter == filter,
                    onSelected: (_) => setState(() => _filter = filter),
                  ),
              ],
            ),
          ),
          for (final category in categories) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 8),
              child: Text(
                categoryLabel(l10n, category),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListCard(
                children: [
                  for (final series in byCategory[category]!)
                    SeriesTile(series: series),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// One value in the list: name, latest value, trend.
class SeriesTile extends StatelessWidget {
  const SeriesTile({required this.series, super.key});

  final SeriesView series;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final latest = series.latest;
    final wide = MediaQuery.sizeOf(context).width >= expandedBreakpoint;
    // The bar needs the newest measurement as a number with both bounds.
    final point = series.points.lastOrNull;
    final low = point?.refLow;
    final high = point?.refHigh;
    final hasRange =
        point != null &&
        point.reading.id == latest.id &&
        low != null &&
        high != null &&
        high > low;
    const barWidth = 88.0;
    final value = Text(
      formatPrintedValue(latest),
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.end,
      style: theme.textTheme.bodyLarge?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
    return ListTile(
      title: Text(series.name),
      subtitle: Text(
        [
          l10n.valueMeasurements(series.summary.readingCount),
          if (series.isOpen) l10n.valueOpenQuestion,
        ].join(' · '),
      ),
      onTap: () => context.go(Routes.value(series.summary.key)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Sparkline(
            values: [for (final p in series.points) p.value],
            highlightLast: series.isAbnormal,
          ),
          if (wide) ...[
            const SizedBox(width: 20),
            if (hasRange)
              RangeBar(
                value: point.value,
                low: low,
                high: high,
                flag: latest.flag,
                width: barWidth,
              )
            else
              const SizedBox(width: barWidth),
          ],
          const SizedBox(width: 12),
          // A fixed width on wide windows lines the columns up.
          if (wide)
            SizedBox(width: 120, child: value)
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: value,
            ),
          const SizedBox(width: 4),
          FlagMark(latest.flag),
        ],
      ),
    );
  }
}
