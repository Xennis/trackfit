import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/status_colors.dart';
import '../../app/theme.dart';
import '../../data/database_providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../import/import_flow.dart';
import '../reports/report_providers.dart';
import '../values/values_providers.dart';

/// A top level destination of the app.
class Destination {
  const Destination(this.icon, this.selectedIcon, this.label);

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Navigation of wide windows: name, import, destinations and what is open.
///
/// The last of [destinations] sits at the bottom. When not [extended], only
/// the icons show.
class Sidebar extends ConsumerWidget {
  const Sidebar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelect,
    required this.extended,
    super.key,
  });

  final List<Destination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool extended;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final status = StatusColors.of(context);
    final abnormal = (ref.watch(seriesListProvider).value ?? const [])
        .where((s) => s.isAbnormal)
        .length;
    final open = (ref.watch(openQuestionsProvider).value ?? const []).fold(
      0,
      (n, q) => n + q.readings.length,
    );
    final reportCount = ref.watch(reportSummariesProvider).value?.length ?? 0;

    Widget item(int index, {int count = 0}) => _Item(
      icon: index == selectedIndex
          ? destinations[index].selectedIcon
          : destinations[index].icon,
      label: destinations[index].label,
      selected: index == selectedIndex,
      extended: extended,
      count: count,
      countColors: (status.warning, status.warningContainer),
      onTap: () => onSelect(index),
    );

    final children = [
      if (extended)
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 14),
          child: Row(
            children: [
              const _Mark(),
              const SizedBox(width: 10),
              Text(
                l10n.appTitle,
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
              ),
            ],
          ),
        )
      else
        const Padding(
          padding: EdgeInsets.only(bottom: 14),
          child: Center(child: _Mark()),
        ),
      if (extended)
        FilledButton.icon(
          onPressed: () => showImportSheet(context, ref),
          icon: const Icon(Icons.add, size: 18),
          label: Text(l10n.importAction),
        )
      else
        IconButton.filled(
          tooltip: l10n.importAction,
          onPressed: () => showImportSheet(context, ref),
          icon: const Icon(Icons.add, size: 18),
        ),
      const SizedBox(height: 12),
      for (var i = 0; i < destinations.length - 1; i++)
        item(i, count: i == 1 ? abnormal : 0),
      if (open > 0) ...[
        const SizedBox(height: 12),
        _Item(
          icon: Icons.fact_check_outlined,
          label: l10n.questionsTitle,
          selected: false,
          extended: extended,
          count: open,
          countColors: (status.open, status.openContainer),
          onTap: () => context.go(Routes.questions),
        ),
      ],
      const Spacer(),
      item(destinations.length - 1),
      if (extended) ...[
        const Divider(height: 17),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 2, 4, 0),
          child: Row(
            children: [
              Icon(Icons.lock_outline, size: 14, color: colors.outline),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.sidebarLocal(reportCount),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ];

    return SizedBox(
      width: extended ? 216 : 60,
      // Scrolls instead of overflowing when the window is very low.
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 14, 10, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The mark of the app: a trend line on the brand gradient.
class _Mark extends StatelessWidget {
  const _Mark();

  @override
  Widget build(BuildContext context) => Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Theme.of(context).colorScheme.primary, AppTheme.accent],
      ),
    ),
    child: const Icon(Icons.show_chart, size: 16, color: Colors.white),
  );
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.label,
    required this.selected,
    required this.extended,
    required this.count,
    required this.countColors,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool extended;

  /// Shown at the end when above zero.
  final int count;

  /// Text and background of the count.
  final (Color, Color) countColors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radii.small),
      side: selected
          ? BorderSide(color: colors.outlineVariant)
          : BorderSide.none,
    );
    final color = selected
        ? colors.onPrimaryContainer
        : colors.onSurfaceVariant;
    final iconWidget = Icon(
      icon,
      size: 18,
      color: selected ? colors.primary : color,
    );
    final content = extended
        ? Row(
            children: [
              const SizedBox(width: 10),
              iconWidget,
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (count > 0)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: countColors.$2,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    '$count',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: countColors.$1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          )
        : Center(child: iconWidget);
    final tile = Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: selected ? colors.surfaceContainerLowest : Colors.transparent,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: SizedBox(height: 36, child: content),
        ),
      ),
    );
    return extended ? tile : Tooltip(message: label, child: tile);
  }
}
