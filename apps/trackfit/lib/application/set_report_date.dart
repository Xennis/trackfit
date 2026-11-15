import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../data/database_providers.dart';
import 'processing_providers.dart';

/// Sets the date of a report as entered by the person and writes its
/// readings for that day.
Future<void> setReportDate(WidgetRef ref, int reportId, DateTime date) async {
  final iso =
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
  await ref
      .read(reportRepositoryProvider)
      .setReportInfo(reportId, reportDate: iso, dateSource: DateSource.manual);
  final extraction = await ref.read(reportExtractionProvider.future);
  await extraction.writeReadings(reportId);
}
