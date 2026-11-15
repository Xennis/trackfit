import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../common/empty_state.dart';

class ValuesPage extends StatelessWidget {
  const ValuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navValues)),
      body: EmptyState(
        icon: Icons.show_chart_outlined,
        title: l10n.valuesEmptyTitle,
        body: l10n.valuesEmptyBody,
      ),
    );
  }
}
