import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../../data/database_providers.dart';

/// Reports of the current person for the list.
final reportSummariesProvider = StreamProvider<List<ReportSummary>>((
  ref,
) async* {
  final personId = await ref.watch(currentPersonIdProvider.future);
  yield* ref.watch(reportRepositoryProvider).watchSummaries(personId);
});

/// One report, null once it was deleted.
final reportProvider = StreamProvider.family<ReportRow?, int>(
  (ref, reportId) => ref.watch(reportRepositoryProvider).watchReport(reportId),
);

/// Files of one report in their order.
final reportFilesProvider = StreamProvider.family<List<SourceFileRow>, int>(
  (ref, reportId) => ref.watch(reportRepositoryProvider).watchFiles(reportId),
);
