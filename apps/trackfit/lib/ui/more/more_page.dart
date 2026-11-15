import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navMore)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.moreAbout),
            subtitle: Text(l10n.moreDisclaimer),
          ),
        ],
      ),
    );
  }
}
