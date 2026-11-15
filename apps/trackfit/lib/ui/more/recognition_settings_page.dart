import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/recognition_settings.dart';
import '../../l10n/generated/app_localizations.dart';

/// API key and consent for recognition with Mistral AI.
class RecognitionSettingsPage extends ConsumerStatefulWidget {
  const RecognitionSettingsPage({super.key});

  @override
  ConsumerState<RecognitionSettingsPage> createState() =>
      _RecognitionSettingsPageState();
}

class _RecognitionSettingsPageState
    extends ConsumerState<RecognitionSettingsPage> {
  final _keyController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _saveKey(String message) async {
    final messenger = ScaffoldMessenger.of(context);
    FocusScope.of(context).unfocus();
    await ref
        .read(recognitionSettingsProvider.notifier)
        .setApiKey(_keyController.text);
    _keyController.clear();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(recognitionSettingsProvider).value;
    final notifier = ref.read(recognitionSettingsProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsRecognition)),
      body: settings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(l10n.recognitionIntro),
                const SizedBox(height: 24),
                TextField(
                  controller: _keyController,
                  obscureText: _obscure,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: l10n.recognitionApiKey,
                    hintText: settings.hasApiKey
                        ? '••••••••'
                        : l10n.recognitionApiKeyHint,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      tooltip: _obscure
                          ? l10n.recognitionShowKey
                          : l10n.recognitionHideKey,
                      icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilledButton(
                      onPressed: () => _saveKey(l10n.recognitionKeySaved),
                      child: Text(l10n.recognitionSave),
                    ),
                    if (settings.hasApiKey)
                      TextButton(
                        onPressed: () {
                          _keyController.clear();
                          _saveKey(l10n.recognitionKeyRemoved);
                        },
                        child: Text(l10n.recognitionRemoveKey),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: settings.consentGiven,
                  onChanged: (value) => notifier.setConsent(given: value),
                  title: Text(l10n.recognitionConsent),
                  subtitle: Text(l10n.recognitionConsentBody),
                ),
              ],
            ),
    );
  }
}
