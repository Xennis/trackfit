import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../../data/database_providers.dart';
import '../../l10n/generated/app_localizations.dart';

/// The imported files of a report, one at a time.
class OriginalView extends ConsumerStatefulWidget {
  const OriginalView({required this.files, super.key});

  final List<SourceFileRow> files;

  @override
  ConsumerState<OriginalView> createState() => _OriginalViewState();
}

class _OriginalViewState extends ConsumerState<OriginalView> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final store = ref.watch(fileStoreProvider).value;
    if (store == null || widget.files.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final index = _selected.clamp(0, widget.files.length - 1);
    final file = widget.files[index];
    final path = store.resolve(file.storedPath).path;
    final viewer = File(path).existsSync()
        ? switch (file.kind) {
            FileKind.pdf => PdfViewer.file(path, key: ValueKey(path)),
            _ => InteractiveViewer(
              key: ValueKey(path),
              maxScale: 5,
              child: Center(child: Image.file(File(path))),
            ),
          }
        : Center(child: Text(l10n.reportFileMissing));

    return Column(
      children: [
        if (widget.files.length > 1)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              spacing: 8,
              children: [
                for (final (i, _) in widget.files.indexed)
                  ChoiceChip(
                    label: Text(l10n.reportFileLabel(i + 1)),
                    selected: i == index,
                    onSelected: (_) => setState(() => _selected = i),
                  ),
              ],
            ),
          ),
        Expanded(child: viewer),
      ],
    );
  }
}
