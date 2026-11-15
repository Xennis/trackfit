import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trackfit_db/trackfit_db.dart';

/// The user database, stored in the app support directory.
///
/// Queries run in a background isolate, so imports do not block the UI.
/// Tests override this provider with an in-memory database.
final databaseProvider = Provider<TrackfitDatabase>((ref) {
  final db = TrackfitDatabase(
    driftDatabase(
      name: 'trackfit',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    ),
  );
  ref.onDispose(db.close);
  return db;
});

/// IANA time zone of the device, `UTC` when it cannot be determined.
final deviceTimeZoneProvider = FutureProvider<String>((ref) async {
  try {
    return (await FlutterTimezone.getLocalTimezone()).identifier;
  } on Object catch (error) {
    debugPrint('Could not read the device time zone: ${error.runtimeType}');
    return 'UTC';
  }
});

/// Id of the person whose data is shown, created on first start.
final currentPersonIdProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(databaseProvider);
  final timeZone = await ref.watch(deviceTimeZoneProvider.future);
  return PersonRepository(
    db,
  ).ensureDefaultPerson(defaultTz: timeZone, now: DateTime.now().toUtc());
});
