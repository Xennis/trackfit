import 'dart:typed_data';

import 'package:mime/mime.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../data/file_store.dart';

/// A file the person chose to import.
class ImportCandidate {
  const ImportCandidate({
    required this.name,
    required this.bytes,
    required this.channel,
  });

  final String name;
  final Uint8List bytes;
  final ImportChannel channel;
}

/// A chosen file that was imported before.
class ImportDuplicate {
  const ImportDuplicate({required this.name, required this.existingReportId});

  final String name;
  final int existingReportId;
}

/// What an import did.
class ImportOutcome {
  const ImportOutcome({
    this.reportIds = const [],
    this.duplicates = const [],
    this.unsupported = const [],
  });

  /// New reports, in the order the files were chosen.
  final List<int> reportIds;
  final List<ImportDuplicate> duplicates;

  /// Names of files that are neither PDF nor a supported image.
  final List<String> unsupported;
}

/// Type of a file, detected from its first bytes and its name.
class DetectedType {
  const DetectedType(this.mimeType, this.kind, this.extension);

  final String mimeType;
  final FileKind kind;
  final String extension;

  static const _images = {
    'image/jpeg': 'jpg',
    'image/png': 'png',
    'image/heic': 'heic',
    'image/heif': 'heif',
    'image/webp': 'webp',
  };

  /// Null when the file is neither a PDF nor a supported image.
  static DetectedType? of(String name, Uint8List bytes) {
    final header = bytes.length > 32 ? bytes.sublist(0, 32) : bytes;
    final mime = lookupMimeType(name, headerBytes: header);
    if (mime == 'application/pdf') {
      return const DetectedType('application/pdf', FileKind.pdf, 'pdf');
    }
    final extension = _images[mime];
    if (mime != null && extension != null) {
      return DetectedType(mime, FileKind.image, extension);
    }
    return null;
  }
}

/// Copies chosen files into the app and creates pending reports for them.
class ImportService {
  ImportService({
    required ReportRepository reports,
    required FileStore fileStore,
    DateTime Function()? clock,
  }) : _reports = reports,
       _fileStore = fileStore,
       _clock = clock ?? DateTime.now;

  final ReportRepository _reports;
  final FileStore _fileStore;
  final DateTime Function() _clock;

  /// Imports [candidates] for [personId].
  ///
  /// Every PDF becomes a report of its own. Images become one report each,
  /// or together one report with the images as pages when
  /// [imagesAsOneReport] is set. Files imported before are skipped.
  Future<ImportOutcome> importFiles(
    int personId,
    List<ImportCandidate> candidates, {
    bool imagesAsOneReport = false,
  }) async {
    final duplicates = <ImportDuplicate>[];
    final unsupported = <String>[];
    final seen = <String>{};
    final pdfs = <NewSourceFile>[];
    final images = <NewSourceFile>[];

    for (final candidate in candidates) {
      final type = DetectedType.of(candidate.name, candidate.bytes);
      if (type == null) {
        unsupported.add(candidate.name);
        continue;
      }
      final hash = FileStore.hashOf(candidate.bytes);
      final existing = await _reports.findFileByHash(personId, hash);
      if (existing != null) {
        duplicates.add(
          ImportDuplicate(
            name: candidate.name,
            existingReportId: existing.reportId,
          ),
        );
        continue;
      }
      // The same file chosen twice in one go is imported once.
      if (!seen.add(hash)) continue;

      final stored = await _fileStore.store(
        candidate.bytes,
        extension: type.extension,
      );
      final file = NewSourceFile(
        contentHash: stored.contentHash,
        fileName: candidate.name,
        mimeType: type.mimeType,
        byteSize: stored.byteSize,
        storedPath: stored.relativePath,
        kind: type.kind,
        importChannel: candidate.channel,
      );
      (type.kind == FileKind.pdf ? pdfs : images).add(file);
    }

    final groups = [
      for (final pdf in pdfs) [pdf],
      if (imagesAsOneReport && images.isNotEmpty)
        images
      else
        for (final image in images) [image],
    ];
    final reportIds = <int>[];
    for (final files in groups) {
      reportIds.add(
        await _reports.createReport(
          personId: personId,
          files: files,
          now: _clock().toUtc(),
        ),
      );
    }
    return ImportOutcome(
      reportIds: reportIds,
      duplicates: duplicates,
      unsupported: unsupported,
    );
  }
}
