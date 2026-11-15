import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../../data/database_providers.dart';
import '../../l10n/generated/app_localizations.dart';

/// A page of a file of a report.
typedef FilePage = ({int fileId, int pageIx});

/// The imported files of a report, one at a time.
///
/// Setting [focus] shows that file and page, e.g. when a value is tapped.
class OriginalView extends ConsumerStatefulWidget {
  const OriginalView({required this.files, this.focus, super.key});

  final List<SourceFileRow> files;
  final ValueNotifier<FilePage?>? focus;

  @override
  ConsumerState<OriginalView> createState() => _OriginalViewState();
}

class _OriginalViewState extends ConsumerState<OriginalView> {
  int _selected = 0;
  final _pdfController = PdfViewerController();

  @override
  void initState() {
    super.initState();
    widget.focus?.addListener(_onFocus);
  }

  @override
  void dispose() {
    widget.focus?.removeListener(_onFocus);
    super.dispose();
  }

  void _onFocus() {
    final target = widget.focus?.value;
    if (target == null) return;
    final index = widget.files.indexWhere((f) => f.id == target.fileId);
    if (index < 0) return;
    setState(() => _selected = index);
    if (widget.files[index].kind == FileKind.pdf && _pdfController.isReady) {
      _pdfController.goToPage(pageNumber: target.pageIx + 1);
    }
  }

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
            FileKind.pdf => PdfViewer.file(
              path,
              key: ValueKey(path),
              controller: _pdfController,
            ),
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
