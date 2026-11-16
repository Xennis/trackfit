import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'application/processing_providers.dart';
import 'data/database_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Draw behind the system bars, so the navigation bar reaches the edge.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ),
  );
  // The bundled font is listed on the license page.
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Inter',
    ], await rootBundle.loadString('assets/fonts/Inter-LICENSE.txt'));
  });
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
