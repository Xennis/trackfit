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

  @override
  String get importAction => 'Befund hinzufügen';

  @override
  String get importTitle => 'Befund hinzufügen';

  @override
  String get importChooseFiles => 'PDF oder Bilder wählen';

  @override
  String get importDropHint => 'oder Dateien ins Fenster ziehen';

  @override
  String get importCombineTitle => 'Mehrere Fotos';

  @override
  String get importCombineBody => 'Sind diese Fotos Seiten eines Befunds?';

  @override
  String get importCombineOne => 'Ein Befund';

  @override
  String get importCombineSeparate => 'Einzelne Befunde';

  @override
  String importDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Befunde hinzugefügt',
      one: '1 Befund hinzugefügt',
    );
    return '$_temp0';
  }

  @override
  String importDuplicate(String name) {
    return '$name wurde bereits importiert';
  }

  @override
  String importUnsupported(String name) {
    return '$name ist kein PDF und kein Bild';
  }

  @override
  String get importFailed => 'Import fehlgeschlagen';

  @override
  String get open => 'Öffnen';

  @override
  String get importDropOverlay =>
      'PDFs oder Bilder ablegen, um Befunde hinzuzufügen';

  @override
  String get importCamera => 'Foto aufnehmen';

  @override
  String get importGallery => 'Aus Galerie wählen';

  @override
  String get reportUntitled => 'Neuer Befund';

  @override
  String reportFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien',
      one: '1 Datei',
    );
    return '$_temp0';
  }

  @override
  String reportValues(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Werte',
      one: '1 Wert',
      zero: 'Keine Werte',
    );
    return '$_temp0';
  }

  @override
  String reportOpenQuestions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count offene Fragen',
      one: '1 offene Frage',
    );
    return '$_temp0';
  }

  @override
  String get reportStatusPending => 'Wartet auf Erkennung';

  @override
  String get reportStatusOcr => 'Text wird erkannt…';

  @override
  String get reportStatusExtracting => 'Werte werden ausgelesen…';

  @override
  String get reportStatusReview => 'Bereit zur Prüfung';

  @override
  String get reportStatusDone => 'Fertig';

  @override
  String get reportStatusFailed => 'Fehlgeschlagen';

  @override
  String get loadFailed => 'Daten konnten nicht geladen werden';
}
