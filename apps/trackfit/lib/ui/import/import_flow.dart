import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../../application/import_providers.dart';
import '../../application/import_service.dart';
import '../../data/database_providers.dart';
import '../../l10n/generated/app_localizations.dart';
import 'consent_flow.dart';

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
              if (_isAndroid) ...[
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: Text(l10n.importCamera),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    takePhotoAndImport(context, ref);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(l10n.importGallery),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    pickPhotosAndImport(context, ref);
                  },
                ),
              ],
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

bool get _isAndroid =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

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

/// Takes a photo with the camera and imports it.
Future<void> takePhotoAndImport(BuildContext context, WidgetRef ref) async {
  final photo = await ImagePicker().pickImage(source: ImageSource.camera);
  if (photo == null) return;
  final candidate = ImportCandidate(
    name: photo.name,
    bytes: await photo.readAsBytes(),
    channel: ImportChannel.camera,
  );
  if (!context.mounted) return;
  await importCandidates(context, ref, [candidate]);
}

/// Lets the person choose photos from the gallery and imports them.
Future<void> pickPhotosAndImport(BuildContext context, WidgetRef ref) async {
  final photos = await ImagePicker().pickMultiImage();
  if (photos.isEmpty) return;
  final candidates = [
    for (final photo in photos)
      ImportCandidate(
        name: photo.name,
        bytes: await photo.readAsBytes(),
        channel: ImportChannel.gallery,
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
  final imageCount = candidates
      .where((c) => DetectedType.of(c.name, c.bytes)?.kind == FileKind.image)
      .length;
  var imagesAsOneReport = false;
  if (imageCount > 1) {
    final answer = await _askCombineImages(context);
    if (answer == null) return;
    imagesAsOneReport = answer;
  }
  try {
    final service = await ref.read(importServiceProvider.future);
    final personId = await ref.read(currentPersonIdProvider.future);
    final outcome = await service.importFiles(
      personId,
      candidates,
      imagesAsOneReport: imagesAsOneReport,
    );
    messenger.showSnackBar(SnackBar(content: Text(_summary(l10n, outcome))));
    if (outcome.reportIds.isNotEmpty && context.mounted) {
      await ensureRecognitionReady(context, ref);
    }
  } on Object catch (error) {
    debugPrint('Import failed: ${error.runtimeType}');
    messenger.showSnackBar(SnackBar(content: Text(l10n.importFailed)));
  }
}

/// Asks whether several images are the pages of one report.
///
/// Null when the dialog was dismissed.
Future<bool?> _askCombineImages(BuildContext context) => showDialog<bool>(
  context: context,
  builder: (dialogContext) {
    final l10n = AppLocalizations.of(dialogContext);
    return AlertDialog(
      title: Text(l10n.importCombineTitle),
      content: Text(l10n.importCombineBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.importCombineSeparate),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.importCombineOne),
        ),
      ],
    );
  },
);

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
