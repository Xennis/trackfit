import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../import/file_drop_zone.dart';
import '../import/import_flow.dart';
import 'sidebar.dart';

/// Width below which the bottom navigation bar is used (Material 3 compact).
const double compactBreakpoint = 600;

/// Width from which the sidebar shows its labels next to the icons.
const double expandedBreakpoint = 800;

/// Top level navigation: a bottom bar on compact screens, a sidebar
/// next to the content panel otherwise.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onSelect(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final destinations = _destinations(AppLocalizations.of(context));
    final width = MediaQuery.sizeOf(context).width;

    if (width < compactBreakpoint) {
      return Scaffold(
        body: isDesktop
            ? FileDropZone(child: navigationShell)
            : navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onSelect,
          destinations: [
            for (final d in destinations)
              NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
          ],
        ),
      );
    }

    final colors = Theme.of(context).colorScheme;
    final body = Row(
      children: [
        Sidebar(
          destinations: destinations,
          selectedIndex: navigationShell.currentIndex,
          onSelect: _onSelect,
          extended: width >= expandedBreakpoint,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border.all(color: colors.outlineVariant),
              borderRadius: BorderRadius.circular(Radii.large),
            ),
            child: navigationShell,
          ),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      body: isDesktop ? FileDropZone(child: body) : body,
    );
  }

  List<Destination> _destinations(AppLocalizations l10n) => [
    Destination(Icons.dashboard_outlined, Icons.dashboard, l10n.navOverview),
    Destination(Icons.show_chart_outlined, Icons.show_chart, l10n.navValues),
    Destination(Icons.description_outlined, Icons.description, l10n.navReports),
    Destination(Icons.more_horiz, Icons.more_horiz, l10n.navMore),
  ];
}
