import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/processing_providers.dart';
import '../../l10n/generated/app_localizations.dart';

/// What the app does, what it does not, and the licenses it uses.
class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final release = ref.watch(coderProvider).value?.release;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.aboutBody, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 16),
          Text(
            l10n.moreDisclaimer,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.aboutLoinc, style: theme.textTheme.bodySmall),
          if (release != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.aboutTerminology(release),
              style: theme.textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: () => showLicensePage(
                context: context,
                applicationName: l10n.appTitle,
              ),
              child: Text(l10n.aboutLicenses),
            ),
          ),
        ],
      ),
    );
  }
}
