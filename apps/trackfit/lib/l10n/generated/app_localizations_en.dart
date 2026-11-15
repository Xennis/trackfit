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
}
