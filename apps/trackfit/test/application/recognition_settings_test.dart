import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/application/recognition_settings.dart';
import 'package:trackfit/data/secret_store.dart';

void main() {
  late MemorySecretStore store;
  late ProviderContainer container;

  setUp(() {
    store = MemorySecretStore();
    container = ProviderContainer(
      overrides: [secretStoreProvider.overrideWithValue(store)],
    );
  });
  tearDown(() => container.dispose());

  Future<RecognitionSettings> settings() =>
      container.read(recognitionSettingsProvider.future);

  test('is not ready without key and consent', () async {
    expect((await settings()).ready, isFalse);
  });

  test('is ready with key and consent', () async {
    final notifier = container.read(recognitionSettingsProvider.notifier);
    await notifier.setApiKey('  secret  ');
    await notifier.setConsent(given: true);

    final result = await settings();
    expect(result.mistralApiKey, 'secret');
    expect(result.ready, isTrue);
  });

  test('an empty key removes the key', () async {
    final notifier = container.read(recognitionSettingsProvider.notifier);
    await notifier.setApiKey('secret');
    await notifier.setApiKey('');

    expect((await settings()).hasApiKey, isFalse);
    expect(store.values, isEmpty);
  });
}
