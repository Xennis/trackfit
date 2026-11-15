import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// Name of the app.
  ///
  /// In en, this message translates to:
  /// **'trackfit'**
  String get appTitle;

  /// Navigation destination for the start page.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// Navigation destination for all measured values.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get navValues;

  /// Navigation destination for imported lab reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// Navigation destination for settings and info.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @overviewEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first report'**
  String get overviewEmptyTitle;

  /// No description provided for @overviewEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Import a lab report as PDF or photo to get started.'**
  String get overviewEmptyBody;

  /// No description provided for @valuesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No values yet'**
  String get valuesEmptyTitle;

  /// No description provided for @valuesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Values from your reports will show up here.'**
  String get valuesEmptyBody;

  /// No description provided for @reportsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reports yet'**
  String get reportsEmptyTitle;

  /// No description provided for @reportsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Imported PDFs and photos will show up here.'**
  String get reportsEmptyBody;

  /// No description provided for @moreAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get moreAbout;

  /// No description provided for @moreDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'trackfit does not diagnose or give medical advice.'**
  String get moreDisclaimer;

  /// No description provided for @importAction.
  ///
  /// In en, this message translates to:
  /// **'Add report'**
  String get importAction;

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Add report'**
  String get importTitle;

  /// No description provided for @importChooseFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose PDF or images'**
  String get importChooseFiles;

  /// No description provided for @importDropHint.
  ///
  /// In en, this message translates to:
  /// **'or drop files into the window'**
  String get importDropHint;

  /// No description provided for @importCombineTitle.
  ///
  /// In en, this message translates to:
  /// **'Several photos'**
  String get importCombineTitle;

  /// No description provided for @importCombineBody.
  ///
  /// In en, this message translates to:
  /// **'Are these photos pages of one report?'**
  String get importCombineBody;

  /// No description provided for @importCombineOne.
  ///
  /// In en, this message translates to:
  /// **'One report'**
  String get importCombineOne;

  /// No description provided for @importCombineSeparate.
  ///
  /// In en, this message translates to:
  /// **'Separate reports'**
  String get importCombineSeparate;

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 report added} other{{count} reports added}}'**
  String importDone(int count);

  /// No description provided for @importDuplicate.
  ///
  /// In en, this message translates to:
  /// **'{name} was imported before'**
  String importDuplicate(String name);

  /// No description provided for @importUnsupported.
  ///
  /// In en, this message translates to:
  /// **'{name} is not a PDF or image'**
  String importUnsupported(String name);

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed'**
  String get importFailed;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @importDropOverlay.
  ///
  /// In en, this message translates to:
  /// **'Drop PDFs or images to add reports'**
  String get importDropOverlay;

  /// No description provided for @importCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get importCamera;

  /// No description provided for @importGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get importGallery;

  /// No description provided for @reportUntitled.
  ///
  /// In en, this message translates to:
  /// **'New report'**
  String get reportUntitled;

  /// No description provided for @reportFiles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file} other{{count} files}}'**
  String reportFiles(int count);

  /// No description provided for @reportValues.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No values} =1{1 value} other{{count} values}}'**
  String reportValues(int count);

  /// No description provided for @reportOpenQuestions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 open question} other{{count} open questions}}'**
  String reportOpenQuestions(int count);

  /// No description provided for @reportStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for recognition'**
  String get reportStatusPending;

  /// No description provided for @reportStatusOcr.
  ///
  /// In en, this message translates to:
  /// **'Recognizing text…'**
  String get reportStatusOcr;

  /// No description provided for @reportStatusExtracting.
  ///
  /// In en, this message translates to:
  /// **'Reading values…'**
  String get reportStatusExtracting;

  /// No description provided for @reportStatusReview.
  ///
  /// In en, this message translates to:
  /// **'Ready to review'**
  String get reportStatusReview;

  /// No description provided for @reportStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get reportStatusDone;

  /// No description provided for @reportStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get reportStatusFailed;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load data'**
  String get loadFailed;

  /// No description provided for @reportTabOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get reportTabOriginal;

  /// No description provided for @reportTabText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get reportTabText;

  /// No description provided for @reportTabValues.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get reportTabValues;

  /// No description provided for @reportTextEmpty.
  ///
  /// In en, this message translates to:
  /// **'The recognized text will show up here.'**
  String get reportTextEmpty;

  /// No description provided for @reportValuesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Values will show up here once they are read.'**
  String get reportValuesEmpty;

  /// No description provided for @reportNotFound.
  ///
  /// In en, this message translates to:
  /// **'This report no longer exists.'**
  String get reportNotFound;

  /// No description provided for @reportFileMissing.
  ///
  /// In en, this message translates to:
  /// **'The file is missing.'**
  String get reportFileMissing;

  /// No description provided for @reportFileLabel.
  ///
  /// In en, this message translates to:
  /// **'File {number}'**
  String reportFileLabel(int number);

  /// No description provided for @reportDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete report'**
  String get reportDelete;

  /// No description provided for @reportDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this report?'**
  String get reportDeleteTitle;

  /// No description provided for @reportDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'The imported files are removed from this device.'**
  String get reportDeleteBody;

  /// No description provided for @reportDeleteValues.
  ///
  /// In en, this message translates to:
  /// **'Also delete the values read from it'**
  String get reportDeleteValues;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @reportDeleted.
  ///
  /// In en, this message translates to:
  /// **'Report deleted'**
  String get reportDeleted;

  /// No description provided for @settingsRecognition.
  ///
  /// In en, this message translates to:
  /// **'Recognition'**
  String get settingsRecognition;

  /// No description provided for @settingsRecognitionSubtitleReady.
  ///
  /// In en, this message translates to:
  /// **'Mistral AI · ready'**
  String get settingsRecognitionSubtitleReady;

  /// No description provided for @settingsRecognitionSubtitleMissing.
  ///
  /// In en, this message translates to:
  /// **'Mistral AI · not set up'**
  String get settingsRecognitionSubtitleMissing;

  /// No description provided for @recognitionIntro.
  ///
  /// In en, this message translates to:
  /// **'trackfit sends reports to Mistral AI to recognize text and values. The results are stored only on this device.'**
  String get recognitionIntro;

  /// No description provided for @recognitionApiKey.
  ///
  /// In en, this message translates to:
  /// **'Mistral API key'**
  String get recognitionApiKey;

  /// No description provided for @recognitionApiKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Paste your key'**
  String get recognitionApiKeyHint;

  /// No description provided for @recognitionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get recognitionSave;

  /// No description provided for @recognitionRemoveKey.
  ///
  /// In en, this message translates to:
  /// **'Remove key'**
  String get recognitionRemoveKey;

  /// No description provided for @recognitionKeySaved.
  ///
  /// In en, this message translates to:
  /// **'Key saved'**
  String get recognitionKeySaved;

  /// No description provided for @recognitionKeyRemoved.
  ///
  /// In en, this message translates to:
  /// **'Key removed'**
  String get recognitionKeyRemoved;

  /// No description provided for @recognitionShowKey.
  ///
  /// In en, this message translates to:
  /// **'Show key'**
  String get recognitionShowKey;

  /// No description provided for @recognitionHideKey.
  ///
  /// In en, this message translates to:
  /// **'Hide key'**
  String get recognitionHideKey;

  /// No description provided for @recognitionConsent.
  ///
  /// In en, this message translates to:
  /// **'Send reports to Mistral AI'**
  String get recognitionConsent;

  /// No description provided for @recognitionConsentBody.
  ///
  /// In en, this message translates to:
  /// **'Required for recognition. You can withdraw it at any time.'**
  String get recognitionConsentBody;

  /// No description provided for @consentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recognize this report?'**
  String get consentTitle;

  /// No description provided for @consentBody.
  ///
  /// In en, this message translates to:
  /// **'To recognize text and values, the file is sent to Mistral AI. The values are stored only on this device.'**
  String get consentBody;

  /// No description provided for @consentOnlyStore.
  ///
  /// In en, this message translates to:
  /// **'Only store'**
  String get consentOnlyStore;

  /// No description provided for @consentAgree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get consentAgree;

  /// No description provided for @consentNeedsKey.
  ///
  /// In en, this message translates to:
  /// **'Add a Mistral API key to start recognition.'**
  String get consentNeedsKey;

  /// No description provided for @consentOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get consentOpenSettings;

  /// No description provided for @reportRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get reportRetry;

  /// No description provided for @reportSetUpRecognition.
  ///
  /// In en, this message translates to:
  /// **'Set up recognition'**
  String get reportSetUpRecognition;

  /// No description provided for @reportWaitingForSetup.
  ///
  /// In en, this message translates to:
  /// **'Recognition is not set up yet.'**
  String get reportWaitingForSetup;

  /// No description provided for @reportFailedReason.
  ///
  /// In en, this message translates to:
  /// **'Recognition failed: {reason}'**
  String reportFailedReason(String reason);

  /// No description provided for @reportPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Page {number}'**
  String reportPageLabel(int number);

  /// No description provided for @reportTextRendered.
  ///
  /// In en, this message translates to:
  /// **'Formatted'**
  String get reportTextRendered;

  /// No description provided for @reportTextRaw.
  ///
  /// In en, this message translates to:
  /// **'Raw text'**
  String get reportTextRaw;

  /// No description provided for @reportCopyPage.
  ///
  /// In en, this message translates to:
  /// **'Copy page'**
  String get reportCopyPage;

  /// No description provided for @reportCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get reportCopied;

  /// No description provided for @reportDateMissing.
  ///
  /// In en, this message translates to:
  /// **'The report date is missing. Values appear in the history once it is set.'**
  String get reportDateMissing;

  /// No description provided for @reportSetDate.
  ///
  /// In en, this message translates to:
  /// **'Set date'**
  String get reportSetDate;

  /// No description provided for @reportChangeDate.
  ///
  /// In en, this message translates to:
  /// **'Change report date'**
  String get reportChangeDate;

  /// No description provided for @valueReference.
  ///
  /// In en, this message translates to:
  /// **'Ref {range}'**
  String valueReference(String range);

  /// No description provided for @valuePage.
  ///
  /// In en, this message translates to:
  /// **'p. {number}'**
  String valuePage(int number);

  /// No description provided for @valueOpenQuestion.
  ///
  /// In en, this message translates to:
  /// **'Not assigned yet'**
  String get valueOpenQuestion;

  /// No description provided for @valueOtherPanel.
  ///
  /// In en, this message translates to:
  /// **'Other values'**
  String get valueOtherPanel;

  /// No description provided for @flagLow.
  ///
  /// In en, this message translates to:
  /// **'low'**
  String get flagLow;

  /// No description provided for @flagHigh.
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get flagHigh;

  /// No description provided for @flagCriticalLow.
  ///
  /// In en, this message translates to:
  /// **'critically low'**
  String get flagCriticalLow;

  /// No description provided for @flagCriticalHigh.
  ///
  /// In en, this message translates to:
  /// **'critically high'**
  String get flagCriticalHigh;

  /// No description provided for @flagAbnormal.
  ///
  /// In en, this message translates to:
  /// **'abnormal'**
  String get flagAbnormal;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About trackfit'**
  String get aboutTitle;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'trackfit stores your lab values on this device and shows how they change over time.'**
  String get aboutBody;

  /// No description provided for @aboutLoinc.
  ///
  /// In en, this message translates to:
  /// **'This app uses LOINC® codes. LOINC is copyright © Regenstrief Institute, Inc. and the LOINC Committee and is available at no cost under the license at loinc.org/license. LOINC® is a registered United States trademark of Regenstrief Institute, Inc.'**
  String get aboutLoinc;

  /// No description provided for @aboutLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get aboutLicenses;

  /// No description provided for @aboutTerminology.
  ///
  /// In en, this message translates to:
  /// **'Terminology: {release}'**
  String aboutTerminology(String release);

  /// No description provided for @categoryBloodCount.
  ///
  /// In en, this message translates to:
  /// **'Blood count'**
  String get categoryBloodCount;

  /// No description provided for @categoryIron.
  ///
  /// In en, this message translates to:
  /// **'Iron metabolism'**
  String get categoryIron;

  /// No description provided for @categoryLiver.
  ///
  /// In en, this message translates to:
  /// **'Liver'**
  String get categoryLiver;

  /// No description provided for @categoryKidney.
  ///
  /// In en, this message translates to:
  /// **'Kidney'**
  String get categoryKidney;

  /// No description provided for @categoryLipids.
  ///
  /// In en, this message translates to:
  /// **'Lipids'**
  String get categoryLipids;

  /// No description provided for @categoryMetabolism.
  ///
  /// In en, this message translates to:
  /// **'Metabolism'**
  String get categoryMetabolism;

  /// No description provided for @categoryThyroid.
  ///
  /// In en, this message translates to:
  /// **'Thyroid'**
  String get categoryThyroid;

  /// No description provided for @categoryVitamins.
  ///
  /// In en, this message translates to:
  /// **'Vitamins'**
  String get categoryVitamins;

  /// No description provided for @categoryElectrolytes.
  ///
  /// In en, this message translates to:
  /// **'Electrolytes'**
  String get categoryElectrolytes;

  /// No description provided for @categoryInflammation.
  ///
  /// In en, this message translates to:
  /// **'Inflammation'**
  String get categoryInflammation;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @valuesFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get valuesFilterAll;

  /// No description provided for @valuesFilterAbnormal.
  ///
  /// In en, this message translates to:
  /// **'Abnormal'**
  String get valuesFilterAbnormal;

  /// No description provided for @valuesFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get valuesFilterOpen;

  /// No description provided for @valueMeasurements.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 measurement} other{{count} measurements}}'**
  String valueMeasurements(int count);

  /// No description provided for @valueHistory.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get valueHistory;

  /// No description provided for @valueAbout.
  ///
  /// In en, this message translates to:
  /// **'About this value'**
  String get valueAbout;

  /// No description provided for @valueLatestOn.
  ///
  /// In en, this message translates to:
  /// **'on {date}'**
  String valueLatestOn(String date);

  /// No description provided for @valueRange1y.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get valueRange1y;

  /// No description provided for @valueRange3y.
  ///
  /// In en, this message translates to:
  /// **'3 years'**
  String get valueRange3y;

  /// No description provided for @valueRangeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get valueRangeAll;

  /// No description provided for @valueOpenReport.
  ///
  /// In en, this message translates to:
  /// **'Open report'**
  String get valueOpenReport;

  /// No description provided for @valueCode.
  ///
  /// In en, this message translates to:
  /// **'LOINC {code}'**
  String valueCode(String code);

  /// No description provided for @valueNotFound.
  ///
  /// In en, this message translates to:
  /// **'This value has no measurements.'**
  String get valueNotFound;

  /// No description provided for @valueUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get valueUnit;

  /// No description provided for @valueNoChart.
  ///
  /// In en, this message translates to:
  /// **'A chart needs numbers; this value is not numeric.'**
  String get valueNoChart;

  /// No description provided for @editValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit value'**
  String get editValueTitle;

  /// No description provided for @addValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Add value'**
  String get addValueTitle;

  /// No description provided for @addValue.
  ///
  /// In en, this message translates to:
  /// **'Add value'**
  String get addValue;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get editName;

  /// No description provided for @editValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get editValue;

  /// No description provided for @editUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get editUnit;

  /// No description provided for @editReference.
  ///
  /// In en, this message translates to:
  /// **'Reference range'**
  String get editReference;

  /// No description provided for @editFlag.
  ///
  /// In en, this message translates to:
  /// **'Flag'**
  String get editFlag;

  /// No description provided for @editOriginalKept.
  ///
  /// In en, this message translates to:
  /// **'The original stays stored.'**
  String get editOriginalKept;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @markAsError.
  ///
  /// In en, this message translates to:
  /// **'Mark as error'**
  String get markAsError;

  /// No description provided for @valueSaved.
  ///
  /// In en, this message translates to:
  /// **'Value saved'**
  String get valueSaved;

  /// No description provided for @valueRetracted.
  ///
  /// In en, this message translates to:
  /// **'Value marked as error'**
  String get valueRetracted;

  /// No description provided for @editNeedsName.
  ///
  /// In en, this message translates to:
  /// **'Enter the name of the test'**
  String get editNeedsName;

  /// No description provided for @addValueNeedsDate.
  ///
  /// In en, this message translates to:
  /// **'Set the report date first.'**
  String get addValueNeedsDate;

  /// No description provided for @showPage.
  ///
  /// In en, this message translates to:
  /// **'Show page'**
  String get showPage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
