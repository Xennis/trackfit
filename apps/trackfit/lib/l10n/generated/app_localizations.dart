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
