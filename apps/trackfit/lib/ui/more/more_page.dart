import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../application/recognition_settings.dart';
import '../../application/storage_info.dart';
import '../../application/theme_settings.dart';
import '../../l10n/generated/app_localizations.dart';
import '../reports/report_providers.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ready = ref.watch(recognitionSettingsProvider).value?.ready ?? false;
    final themeMode = ref.watch(themeModeProvider).value ?? ThemeMode.system;
    final storage = ref.watch(storageInfoProvider).value;
    final reportCount = ref.watch(reportSummariesProvider).value?.length ?? 0;
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
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.settingsTheme),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(l10n.themeSystem),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(l10n.themeLight),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(l10n.themeDark),
                ),
              ],
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).set(mode);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.storage_outlined),
            title: Text(l10n.settingsData),
            subtitle: storage == null
                ? null
                : Text(
                    '${l10n.settingsDataSummary(reportCount, formatBytes(storage.bytes))}\n'
                    '${l10n.settingsDataLocation(storage.directory)}',
                  ),
            isThreeLine: storage != null,
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
