import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'data/database_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  // Open the database and create the default person right away.
  container.read(currentPersonIdProvider);
  runApp(
    UncontrolledProviderScope(container: container, child: const TrackfitApp()),
  );
}
