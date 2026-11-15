import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../application/recognition_settings.dart';
import '../../l10n/generated/app_localizations.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ready = ref.watch(recognitionSettingsProvider).value?.ready ?? false;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navMore)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.document_scanner_outlined),
            title: Text(l10n.settingsRecognition),
            subtitle: Text(
              ready
                  ? l10n.settingsRecognitionSubtitleReady
                  : l10n.settingsRecognitionSubtitleMissing,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(Routes.recognitionSettings),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.moreAbout),
            subtitle: Text(l10n.moreDisclaimer),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(Routes.about),
          ),
        ],
      ),
    );
  }
}
