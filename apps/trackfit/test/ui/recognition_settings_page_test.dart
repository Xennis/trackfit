import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/app/app.dart';
import 'package:trackfit/data/secret_store.dart';

import '../helpers.dart';

void main() {
  testWidgets('saves the api key and the consent', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final secrets = MemorySecretStore();
    await tester.pumpWidget(
      ProviderScope(
        overrides: testOverrides(db, secrets: secrets),
        child: const TrackfitApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('Mistral AI · not set up'), findsOneWidget);
    await tester.tap(find.text('Recognition'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'test-key');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(secrets.values['mistral_api_key'], 'test-key');
    expect(secrets.values['cloud_recognition_consent'], 'yes');
    expect(find.text('Remove key'), findsOneWidget);
  });
}
