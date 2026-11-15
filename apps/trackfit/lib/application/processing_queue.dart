import 'dart:async';

import 'report_processor.dart';

/// Processes pending reports one after another.
///
/// [processor] returns null while recognition is not possible, e.g. without
/// an API key; pending reports then wait until [poke] is called.
class ProcessingQueue {
  ProcessingQueue({
    required Stream<List<int>> pending,
    required Future<ReportProcessor?> Function() processor,
  }) : _pending = pending,
       _processor = processor;

  final Stream<List<int>> _pending;
  final Future<ReportProcessor?> Function() _processor;
  StreamSubscription<List<int>>? _subscription;
  List<int> _queue = const [];
  bool _running = false;

  void start() {
    _subscription ??= _pending.listen((ids) {
      _queue = ids;
      unawaited(_drain());
    });
  }

  /// Tries again, e.g. after the settings changed.
  void poke() => unawaited(_drain());

  Future<void> _drain() async {
    if (_running) return;
    _running = true;
    try {
      while (_queue.isNotEmpty) {
        final processor = await _processor();
        if (processor == null) return;
        final next = _queue.first;
        _queue = _queue.skip(1).toList();
        await processor.process(next);
      }
    } finally {
      _running = false;
    }
  }

  Future<void> dispose() async => _subscription?.cancel();
}
