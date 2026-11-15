import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'application/processing_providers.dart';
import 'data/database_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  // Open the database and create the default person right away.
  container
    ..read(currentPersonIdProvider)
    // Recognize reports in the background, also those left from last time.
    ..read(processingQueueProvider)
    // Code earlier readings again when this version brings new codes.
    ..read(terminologyUpgradeProvider);
  runApp(
    UncontrolledProviderScope(container: container, child: const TrackfitApp()),
  );
}
