import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../common/empty_state.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navReports)),
      body: EmptyState(
        icon: Icons.description_outlined,
        title: l10n.reportsEmptyTitle,
        body: l10n.reportsEmptyBody,
      ),
    );
  }
}
