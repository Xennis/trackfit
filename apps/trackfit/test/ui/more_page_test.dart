import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/app/app.dart';

import '../helpers.dart';

void main() {
  testWidgets('switches to dark mode and shows the data size', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(overrides: testOverrides(db), child: const TrackfitApp()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.textContaining('0 reports · 2.0 KB'), findsOneWidget);
    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
  });
}
