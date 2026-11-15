import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../ui/more/more_page.dart';
import '../ui/overview/overview_page.dart';
import '../ui/reports/report_detail_page.dart';
import '../ui/reports/reports_page.dart';
import '../ui/shell/app_shell.dart';
import '../ui/values/values_page.dart';

/// Route paths of the top level destinations.
abstract final class Routes {
  static const overview = '/overview';
  static const values = '/values';
  static const reports = '/reports';
  static const more = '/more';

  static String report(int id) => '$reports/$id';
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: Routes.overview,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          _branch(Routes.overview, const OverviewPage()),
          _branch(Routes.values, const ValuesPage()),
          _branch(
            Routes.reports,
            const ReportsPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => ReportDetailPage(
                  reportId: int.parse(state.pathParameters['id']!),
                ),
              ),
            ],
          ),
          _branch(Routes.more, const MorePage()),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

StatefulShellBranch _branch(
  String path,
  Widget page, {
  List<RouteBase> routes = const [],
}) => StatefulShellBranch(
  routes: [
    GoRoute(path: path, builder: (context, state) => page, routes: routes),
  ],
);
