// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'trackfit';

  @override
  String get navOverview => 'Overview';

  @override
  String get navValues => 'Values';

  @override
  String get navReports => 'Reports';

  @override
  String get navMore => 'More';

  @override
  String get overviewEmptyTitle => 'Add your first report';

  @override
  String get overviewEmptyBody =>
      'Import a lab report as PDF or photo to get started.';

  @override
  String get valuesEmptyTitle => 'No values yet';

  @override
  String get valuesEmptyBody => 'Values from your reports will show up here.';

  @override
  String get reportsEmptyTitle => 'No reports yet';

  @override
  String get reportsEmptyBody => 'Imported PDFs and photos will show up here.';

  @override
  String get moreAbout => 'About';

  @override
  String get moreDisclaimer =>
      'trackfit does not diagnose or give medical advice.';

  @override
  String get importAction => 'Add report';

  @override
  String get importTitle => 'Add report';

  @override
  String get importChooseFiles => 'Choose PDF or images';

  @override
  String get importDropHint => 'or drop files into the window';

  @override
  String get importCombineTitle => 'Several photos';

  @override
  String get importCombineBody => 'Are these photos pages of one report?';

  @override
  String get importCombineOne => 'One report';

  @override
  String get importCombineSeparate => 'Separate reports';

  @override
  String importDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reports added',
      one: '1 report added',
    );
    return '$_temp0';
  }

  @override
  String importDuplicate(String name) {
    return '$name was imported before';
  }

  @override
  String importUnsupported(String name) {
    return '$name is not a PDF or image';
  }

  @override
  String get importFailed => 'Import failed';

  @override
  String get open => 'Open';

  @override
  String get importDropOverlay => 'Drop PDFs or images to add reports';

  @override
  String get importCamera => 'Take a photo';

  @override
  String get importGallery => 'Choose from gallery';

  @override
  String get reportUntitled => 'New report';

  @override
  String reportFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files',
      one: '1 file',
    );
    return '$_temp0';
  }

  @override
  String reportValues(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count values',
      one: '1 value',
      zero: 'No values',
    );
    return '$_temp0';
  }

  @override
  String reportOpenQuestions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count open questions',
      one: '1 open question',
    );
    return '$_temp0';
  }

  @override
  String get reportStatusPending => 'Waiting for recognition';

  @override
  String get reportStatusOcr => 'Recognizing text…';

  @override
  String get reportStatusExtracting => 'Reading values…';

  @override
  String get reportStatusReview => 'Ready to review';

  @override
  String get reportStatusDone => 'Done';

  @override
  String get reportStatusFailed => 'Failed';

  @override
  String get loadFailed => 'Could not load data';

  @override
  String get reportTabOriginal => 'Original';

  @override
  String get reportTabText => 'Text';

  @override
  String get reportTabValues => 'Values';

  @override
  String get reportTextEmpty => 'The recognized text will show up here.';

  @override
  String get reportValuesEmpty =>
      'Values will show up here once they are read.';

  @override
  String get reportNotFound => 'This report no longer exists.';

  @override
  String get reportFileMissing => 'The file is missing.';

  @override
  String reportFileLabel(int number) {
    return 'File $number';
  }

  @override
  String get reportDelete => 'Delete report';

  @override
  String get reportDeleteTitle => 'Delete this report?';

  @override
  String get reportDeleteBody =>
      'The imported files are removed from this device.';

  @override
  String get reportDeleteValues => 'Also delete the values read from it';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get reportDeleted => 'Report deleted';
}
