import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/app/app.dart';

import '../helpers.dart';

Future<void> _pumpApp(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final db = memoryDatabase();
  addTearDown(db.close);
  await tester.pumpWidget(
    ProviderScope(overrides: testOverrides(db), child: const TrackfitApp()),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('uses a bottom navigation bar on compact screens', (
    tester,
  ) async {
    await _pumpApp(tester, const Size(400, 800));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('uses a navigation rail on wide screens', (tester) async {
    await _pumpApp(tester, const Size(1000, 800));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('switches between destinations', (tester) async {
    await _pumpApp(tester, const Size(400, 800));
    expect(find.text('Add your first report'), findsOneWidget);

    await tester.tap(find.text('Reports'));
    await tester.pumpAndSettle();
    expect(find.text('No reports yet'), findsOneWidget);

    await tester.tap(find.text('Values'));
    await tester.pumpAndSettle();
    expect(find.text('No values yet'), findsOneWidget);

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('About'), findsOneWidget);
  });
}
