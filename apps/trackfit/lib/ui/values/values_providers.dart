import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database_providers.dart';
import 'series_view_model.dart';

/// All series of the current person.
final seriesListProvider = StreamProvider<List<SeriesView>>((ref) async* {
  final personId = await ref.watch(currentPersonIdProvider.future);
  yield* ref
      .watch(seriesRepositoryProvider)
      .watchSeries(personId)
      .map((all) => [for (final summary in all) SeriesView(summary)]);
});

/// One series by its key, null when it has no readings.
final seriesProvider = StreamProvider.family<SeriesView?, String>((
  ref,
  key,
) async* {
  final personId = await ref.watch(currentPersonIdProvider.future);
  yield* ref
      .watch(seriesRepositoryProvider)
      .watchOne(personId, key)
      .map((summary) => summary == null ? null : SeriesView(summary));
});
