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

  @override
  String get settingsRecognition => 'Recognition';

  @override
  String get settingsRecognitionSubtitleReady => 'Mistral AI · ready';

  @override
  String get settingsRecognitionSubtitleMissing => 'Mistral AI · not set up';

  @override
  String get recognitionIntro =>
      'trackfit sends reports to Mistral AI to recognize text and values. The results are stored only on this device.';

  @override
  String get recognitionApiKey => 'Mistral API key';

  @override
  String get recognitionApiKeyHint => 'Paste your key';

  @override
  String get recognitionSave => 'Save';

  @override
  String get recognitionRemoveKey => 'Remove key';

  @override
  String get recognitionKeySaved => 'Key saved';

  @override
  String get recognitionKeyRemoved => 'Key removed';

  @override
  String get recognitionShowKey => 'Show key';

  @override
  String get recognitionHideKey => 'Hide key';

  @override
  String get recognitionConsent => 'Send reports to Mistral AI';

  @override
  String get recognitionConsentBody =>
      'Required for recognition. You can withdraw it at any time.';

  @override
  String get consentTitle => 'Recognize this report?';

  @override
  String get consentBody =>
      'To recognize text and values, the file is sent to Mistral AI. The values are stored only on this device.';

  @override
  String get consentOnlyStore => 'Only store';

  @override
  String get consentAgree => 'Agree';

  @override
  String get consentNeedsKey => 'Add a Mistral API key to start recognition.';

  @override
  String get consentOpenSettings => 'Settings';

  @override
  String get reportRetry => 'Try again';

  @override
  String get reportSetUpRecognition => 'Set up recognition';

  @override
  String get reportWaitingForSetup => 'Recognition is not set up yet.';

  @override
  String reportFailedReason(String reason) {
    return 'Recognition failed: $reason';
  }

  @override
  String reportPageLabel(int number) {
    return 'Page $number';
  }

  @override
  String get reportTextRendered => 'Formatted';

  @override
  String get reportTextRaw => 'Raw text';

  @override
  String get reportCopyPage => 'Copy page';

  @override
  String get reportCopied => 'Copied';

  @override
  String get reportDateMissing =>
      'The report date is missing. Values appear in the history once it is set.';

  @override
  String get reportSetDate => 'Set date';

  @override
  String get reportChangeDate => 'Change report date';

  @override
  String valueReference(String range) {
    return 'Ref $range';
  }

  @override
  String valuePage(int number) {
    return 'p. $number';
  }

  @override
  String get valueOpenQuestion => 'Not assigned yet';

  @override
  String get valueOtherPanel => 'Other values';

  @override
  String get flagLow => 'low';

  @override
  String get flagHigh => 'high';

  @override
  String get flagCriticalLow => 'critically low';

  @override
  String get flagCriticalHigh => 'critically high';

  @override
  String get flagAbnormal => 'abnormal';

  @override
  String get aboutTitle => 'About trackfit';

  @override
  String get aboutBody =>
      'trackfit stores your lab values on this device and shows how they change over time.';

  @override
  String get aboutLoinc =>
      'This app uses LOINC® codes. LOINC is copyright © Regenstrief Institute, Inc. and the LOINC Committee and is available at no cost under the license at loinc.org/license. LOINC® is a registered United States trademark of Regenstrief Institute, Inc.';

  @override
  String get aboutLicenses => 'Open source licenses';

  @override
  String aboutTerminology(String release) {
    return 'Terminology: $release';
  }

  @override
  String get categoryBloodCount => 'Blood count';

  @override
  String get categoryIron => 'Iron metabolism';

  @override
  String get categoryLiver => 'Liver';

  @override
  String get categoryKidney => 'Kidney';

  @override
  String get categoryLipids => 'Lipids';

  @override
  String get categoryMetabolism => 'Metabolism';

  @override
  String get categoryThyroid => 'Thyroid';

  @override
  String get categoryVitamins => 'Vitamins';

  @override
  String get categoryElectrolytes => 'Electrolytes';

  @override
  String get categoryInflammation => 'Inflammation';

  @override
  String get categoryOther => 'Other';

  @override
  String get valuesFilterAll => 'All';

  @override
  String get valuesFilterAbnormal => 'Abnormal';

  @override
  String get valuesFilterOpen => 'Open';

  @override
  String valueMeasurements(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count measurements',
      one: '1 measurement',
    );
    return '$_temp0';
  }

  @override
  String get valueHistory => 'Measurements';

  @override
  String get valueAbout => 'About this value';

  @override
  String valueLatestOn(String date) {
    return 'on $date';
  }

  @override
  String get valueRange1y => '1 year';

  @override
  String get valueRange3y => '3 years';

  @override
  String get valueRangeAll => 'All';

  @override
  String get valueOpenReport => 'Open report';

  @override
  String valueCode(String code) {
    return 'LOINC $code';
  }

  @override
  String get valueNotFound => 'This value has no measurements.';

  @override
  String get valueUnit => 'Unit';

  @override
  String get valueNoChart =>
      'A chart needs numbers; this value is not numeric.';

  @override
  String get editValueTitle => 'Edit value';

  @override
  String get addValueTitle => 'Add value';

  @override
  String get addValue => 'Add value';

  @override
  String get editName => 'Test';

  @override
  String get editValue => 'Value';

  @override
  String get editUnit => 'Unit';

  @override
  String get editReference => 'Reference range';

  @override
  String get editFlag => 'Flag';

  @override
  String get editOriginalKept => 'The original stays stored.';

  @override
  String get save => 'Save';

  @override
  String get markAsError => 'Mark as error';

  @override
  String get valueSaved => 'Value saved';

  @override
  String get valueRetracted => 'Value marked as error';

  @override
  String get editNeedsName => 'Enter the name of the test';

  @override
  String get addValueNeedsDate => 'Set the report date first.';

  @override
  String get showPage => 'Show page';

  @override
  String get questionsTitle => 'Open questions';

  @override
  String get questionsEmpty => 'No open questions.';

  @override
  String questionsBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count values need your help',
      one: '1 value needs your help',
    );
    return '$_temp0';
  }

  @override
  String get questionWhichTest => 'Which test is this?';

  @override
  String get questionChooseTest => 'Choose test';

  @override
  String get questionNotStandard => 'Not a standard test';

  @override
  String questionReports(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count reports',
      one: 'in 1 report',
    );
    return '$_temp0';
  }

  @override
  String get questionReasonNoMatch => 'The name is not known yet.';

  @override
  String get questionReasonAmbiguous => 'The name fits more than one test.';

  @override
  String get questionReasonUnitMissing =>
      'The unit is missing. Edit the value in its report.';

  @override
  String get questionReasonUnitConflict =>
      'The unit does not fit this test. Check the value in its report.';

  @override
  String get questionReasonOther => 'The value could not be assigned.';

  @override
  String questionAnswered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count values assigned',
      one: '1 value assigned',
    );
    return '$_temp0';
  }

  @override
  String get questionSearch => 'Search tests';

  @override
  String get questionOpenReport => 'Open report';

  @override
  String get reportReprocess => 'Read values again';

  @override
  String get reportReprocessStarted => 'The report is read again.';

  @override
  String overviewProcessing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reports are being processed',
      one: '1 report is being processed',
    );
    return '$_temp0';
  }

  @override
  String get overviewAbnormal => 'Abnormal';

  @override
  String get overviewNoAbnormal =>
      'No abnormal values in the latest measurements.';

  @override
  String get overviewLatestReport => 'Latest report';

  @override
  String get settingsTheme => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsData => 'Data';

  @override
  String settingsDataSummary(int reports, String size) {
    return '$reports reports · $size';
  }

  @override
  String settingsDataLocation(String path) {
    return 'Stored in $path';
  }
}
