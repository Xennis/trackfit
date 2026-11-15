import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../../application/import_providers.dart';
import '../../application/import_service.dart';
import '../../data/database_providers.dart';
import '../../l10n/generated/app_localizations.dart';

/// Opens the sheet with the ways to add a report.
Future<void> showImportSheet(BuildContext context, WidgetRef ref) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final l10n = AppLocalizations.of(sheetContext);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text(
                  l10n.importTitle,
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.upload_file_outlined),
                title: Text(l10n.importChooseFiles),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  pickAndImportFiles(context, ref);
                },
              ),
              if (isDesktop)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Text(
                    l10n.importDropHint,
                    style: Theme.of(sheetContext).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        );
      },
    );

/// Whether the app runs on a desktop operating system.
bool get isDesktop =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows);

/// Lets the person choose PDFs and images and imports them.
Future<void> pickAndImportFiles(BuildContext context, WidgetRef ref) async {
  final files = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png', 'heic', 'webp'],
  );
  if (files.isEmpty) return;
  final candidates = [
    for (final file in files)
      ImportCandidate(
        name: file.name,
        bytes: await file.readAsBytes(),
        channel: ImportChannel.filePicker,
      ),
  ];
  if (!context.mounted) return;
  await importCandidates(context, ref, candidates);
}

/// Imports [candidates] and reports the outcome in a snack bar.
Future<void> importCandidates(
  BuildContext context,
  WidgetRef ref,
  List<ImportCandidate> candidates,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  try {
    final service = await ref.read(importServiceProvider.future);
    final personId = await ref.read(currentPersonIdProvider.future);
    final outcome = await service.importFiles(personId, candidates);
    messenger.showSnackBar(SnackBar(content: Text(_summary(l10n, outcome))));
  } on Object catch (error) {
    debugPrint('Import failed: ${error.runtimeType}');
    messenger.showSnackBar(SnackBar(content: Text(l10n.importFailed)));
  }
}

String _summary(AppLocalizations l10n, ImportOutcome outcome) => [
  if (outcome.reportIds.isNotEmpty) l10n.importDone(outcome.reportIds.length),
  for (final duplicate in outcome.duplicates)
    l10n.importDuplicate(duplicate.name),
  for (final name in outcome.unsupported) l10n.importUnsupported(name),
].join('\n');

/// Floating button that opens the import sheet.
class ImportButton extends ConsumerWidget {
  const ImportButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      FloatingActionButton.extended(
        onPressed: () => showImportSheet(context, ref),
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context).importAction),
      );
}
