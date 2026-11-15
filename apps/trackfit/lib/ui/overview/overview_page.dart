import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../common/empty_state.dart';
import '../import/import_flow.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      floatingActionButton: const ImportButton(),
      body: EmptyState(
        icon: Icons.note_add_outlined,
        title: l10n.overviewEmptyTitle,
        body: l10n.overviewEmptyBody,
      ),
    );
  }
}
