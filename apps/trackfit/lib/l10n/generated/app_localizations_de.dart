// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'trackfit';

  @override
  String get navOverview => 'Übersicht';

  @override
  String get navValues => 'Werte';

  @override
  String get navReports => 'Befunde';

  @override
  String get navMore => 'Mehr';

  @override
  String get overviewEmptyTitle => 'Ersten Befund hinzufügen';

  @override
  String get overviewEmptyBody =>
      'Importiere einen Laborbefund als PDF oder Foto, um loszulegen.';

  @override
  String get valuesEmptyTitle => 'Noch keine Werte';

  @override
  String get valuesEmptyBody => 'Werte aus deinen Befunden erscheinen hier.';

  @override
  String get reportsEmptyTitle => 'Noch keine Befunde';

  @override
  String get reportsEmptyBody => 'Importierte PDFs und Fotos erscheinen hier.';

  @override
  String get moreAbout => 'Über';

  @override
  String get moreDisclaimer =>
      'trackfit stellt keine Diagnosen und ersetzt keine ärztliche Beratung.';
}
