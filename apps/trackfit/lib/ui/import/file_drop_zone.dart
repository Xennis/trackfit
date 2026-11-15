import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../../application/import_service.dart';
import '../../l10n/generated/app_localizations.dart';
import 'import_flow.dart';

/// Accepts files dragged into the window and imports them.
class FileDropZone extends ConsumerStatefulWidget {
  const FileDropZone({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<FileDropZone> createState() => _FileDropZoneState();
}

class _FileDropZoneState extends ConsumerState<FileDropZone> {
  bool _dragging = false;

  Future<void> _onDrop(DropDoneDetails details) async {
    setState(() => _dragging = false);
    final candidates = [
      for (final item in details.files.whereType<DropItemFile>())
        ImportCandidate(
          name: item.name,
          bytes: await item.readAsBytes(),
          channel: ImportChannel.dragDrop,
        ),
    ];
    if (candidates.isEmpty || !mounted) return;
    await importCandidates(context, ref, candidates);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DropTarget(
      onDragEntered: (_) => setState(() => _dragging = true),
      onDragExited: (_) => setState(() => _dragging = false),
      onDragDone: _onDrop,
      child: Stack(
        children: [
          widget.child,
          if (_dragging)
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.9),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.file_download_outlined,
                          size: 64,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context).importDropOverlay,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: colorScheme.onPrimaryContainer),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
