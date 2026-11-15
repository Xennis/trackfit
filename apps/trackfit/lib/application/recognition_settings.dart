import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/secret_store.dart';

/// What recognition with a cloud service needs: a key and the consent of
/// the person to send files there.
class RecognitionSettings {
  const RecognitionSettings({this.mistralApiKey, this.consentGiven = false});

  final String? mistralApiKey;

  /// The person agreed that files are sent to Mistral AI for recognition.
  final bool consentGiven;

  bool get hasApiKey => mistralApiKey?.isNotEmpty ?? false;

  /// Recognition may run.
  bool get ready => hasApiKey && consentGiven;
}

final secretStoreProvider = Provider<SecretStore>((ref) => SecureSecretStore());

final recognitionSettingsProvider =
    AsyncNotifierProvider<RecognitionSettingsNotifier, RecognitionSettings>(
      RecognitionSettingsNotifier.new,
    );

class RecognitionSettingsNotifier extends AsyncNotifier<RecognitionSettings> {
  static const _apiKey = 'mistral_api_key';
  static const _consent = 'cloud_recognition_consent';

  SecretStore get _store => ref.read(secretStoreProvider);

  @override
  Future<RecognitionSettings> build() async {
    final store = ref.watch(secretStoreProvider);
    return RecognitionSettings(
      mistralApiKey: await store.read(_apiKey),
      consentGiven: await store.read(_consent) == 'yes',
    );
  }

  Future<void> setApiKey(String key) async {
    final trimmed = key.trim();
    if (trimmed.isEmpty) {
      await _store.delete(_apiKey);
    } else {
      await _store.write(_apiKey, trimmed);
    }
    ref.invalidateSelf();
    await future;
  }

  Future<void> setConsent({required bool given}) async {
    if (given) {
      await _store.write(_consent, 'yes');
    } else {
      await _store.delete(_consent);
    }
    ref.invalidateSelf();
    await future;
  }
}
