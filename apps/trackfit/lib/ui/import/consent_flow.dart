import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../application/recognition_settings.dart';
import '../../l10n/generated/app_localizations.dart';

/// Makes sure recognition may run: asks for consent once and points to the
/// settings when the API key is missing. Without consent files are only
/// stored.
Future<void> ensureRecognitionReady(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);
  var settings = await ref.read(recognitionSettingsProvider.future);
  if (!settings.consentGiven) {
    if (!context.mounted) return;
    final agreed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.consentTitle),
        content: Text(l10n.consentBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.consentOnlyStore),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.consentAgree),
          ),
        ],
      ),
    );
    if (agreed != true) return;
    await ref
        .read(recognitionSettingsProvider.notifier)
        .setConsent(given: true);
    settings = await ref.read(recognitionSettingsProvider.future);
  }
  if (!settings.hasApiKey) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.consentNeedsKey),
        action: SnackBarAction(
          label: l10n.consentOpenSettings,
          onPressed: () => router.go(Routes.recognitionSettings),
        ),
      ),
    );
  }
}
