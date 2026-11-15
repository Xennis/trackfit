import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database_providers.dart';
import 'import_service.dart';

final importServiceProvider = FutureProvider<ImportService>(
  (ref) async => ImportService(
    reports: ref.watch(reportRepositoryProvider),
    fileStore: await ref.watch(fileStoreProvider.future),
  ),
);
