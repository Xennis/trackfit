import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:trackfit_db/trackfit_db.dart';

/// A fresh database in memory for one test.
TrackfitDatabase openTestDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return TrackfitDatabase(NativeDatabase.memory());
}
