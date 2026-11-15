import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';

/// Width below which the bottom navigation bar is used (Material 3 compact).
const double compactBreakpoint = 600;

/// Width from which the navigation rail shows its labels next to the icons.
const double expandedBreakpoint = 1200;

/// Top level navigation: a bottom bar on compact screens, a rail otherwise.
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
        body: navigationShell,
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

    final extended = width >= expandedBreakpoint;
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onSelect,
            extended: extended,
            labelType: extended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            destinations: [
              for (final d in destinations)
                NavigationRailDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: Text(d.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }

  List<_Destination> _destinations(AppLocalizations l10n) => [
    _Destination(Icons.dashboard_outlined, Icons.dashboard, l10n.navOverview),
    _Destination(Icons.show_chart_outlined, Icons.show_chart, l10n.navValues),
    _Destination(
      Icons.description_outlined,
      Icons.description,
      l10n.navReports,
    ),
    _Destination(Icons.more_horiz, Icons.more_horiz, l10n.navMore),
  ];
}

class _Destination {
  const _Destination(this.icon, this.selectedIcon, this.label);

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
