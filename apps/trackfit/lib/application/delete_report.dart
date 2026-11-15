import 'package:trackfit_db/trackfit_db.dart';

import '../data/file_store.dart';

/// Deletes a report from the database and its files from disk.
Future<void> deleteReport({
  required ReportRepository reports,
  required FileStore fileStore,
  required int reportId,
  required bool deleteValues,
}) async {
  final paths = await reports.deleteReport(
    reportId,
    deleteValues: deleteValues,
  );
  for (final path in paths) {
    await fileStore.delete(path);
  }
}
