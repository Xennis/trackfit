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

  @override
  String get reportTabOriginal => 'Original';

  @override
  String get reportTabText => 'Text';

  @override
  String get reportTabValues => 'Werte';

  @override
  String get reportTextEmpty => 'Der erkannte Text erscheint hier.';

  @override
  String get reportValuesEmpty =>
      'Werte erscheinen hier, sobald sie ausgelesen sind.';

  @override
  String get reportNotFound => 'Dieser Befund existiert nicht mehr.';

  @override
  String get reportFileMissing => 'Die Datei fehlt.';

  @override
  String reportFileLabel(int number) {
    return 'Datei $number';
  }

  @override
  String get reportDelete => 'Befund löschen';

  @override
  String get reportDeleteTitle => 'Diesen Befund löschen?';

  @override
  String get reportDeleteBody =>
      'Die importierten Dateien werden von diesem Gerät entfernt.';

  @override
  String get reportDeleteValues => 'Auch die daraus gelesenen Werte löschen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get reportDeleted => 'Befund gelöscht';

  @override
  String get settingsRecognition => 'Erkennung';

  @override
  String get settingsRecognitionSubtitleReady => 'Mistral AI · bereit';

  @override
  String get settingsRecognitionSubtitleMissing =>
      'Mistral AI · nicht eingerichtet';

  @override
  String get recognitionIntro =>
      'trackfit sendet Befunde an Mistral AI, um Text und Werte zu erkennen. Die Ergebnisse werden nur auf diesem Gerät gespeichert.';

  @override
  String get recognitionApiKey => 'Mistral-API-Schlüssel';

  @override
  String get recognitionApiKeyHint => 'Schlüssel einfügen';

  @override
  String get recognitionSave => 'Speichern';

  @override
  String get recognitionRemoveKey => 'Schlüssel entfernen';

  @override
  String get recognitionKeySaved => 'Schlüssel gespeichert';

  @override
  String get recognitionKeyRemoved => 'Schlüssel entfernt';

  @override
  String get recognitionShowKey => 'Schlüssel anzeigen';

  @override
  String get recognitionHideKey => 'Schlüssel verbergen';

  @override
  String get recognitionConsent => 'Befunde an Mistral AI senden';

  @override
  String get recognitionConsentBody =>
      'Nötig für die Erkennung. Du kannst das jederzeit widerrufen.';

  @override
  String get consentTitle => 'Befund erkennen lassen?';

  @override
  String get consentBody =>
      'Zum Erkennen von Text und Werten wird die Datei an Mistral AI gesendet. Die Werte werden nur auf diesem Gerät gespeichert.';

  @override
  String get consentOnlyStore => 'Nur ablegen';

  @override
  String get consentAgree => 'Zustimmen';

  @override
  String get consentNeedsKey =>
      'Füge einen Mistral-API-Schlüssel hinzu, um die Erkennung zu starten.';

  @override
  String get consentOpenSettings => 'Einstellungen';

  @override
  String get reportRetry => 'Erneut versuchen';

  @override
  String get reportSetUpRecognition => 'Erkennung einrichten';

  @override
  String get reportWaitingForSetup =>
      'Die Erkennung ist noch nicht eingerichtet.';

  @override
  String reportFailedReason(String reason) {
    return 'Erkennung fehlgeschlagen: $reason';
  }

  @override
  String reportPageLabel(int number) {
    return 'Seite $number';
  }

  @override
  String get reportTextRendered => 'Formatiert';

  @override
  String get reportTextRaw => 'Rohtext';

  @override
  String get reportCopyPage => 'Seite kopieren';

  @override
  String get reportCopied => 'Kopiert';

  @override
  String get reportDateMissing =>
      'Das Befunddatum fehlt. Die Werte erscheinen im Verlauf, sobald es gesetzt ist.';

  @override
  String get reportSetDate => 'Datum wählen';

  @override
  String get reportChangeDate => 'Befunddatum ändern';

  @override
  String valueReference(String range) {
    return 'Ref $range';
  }

  @override
  String valuePage(int number) {
    return 'S. $number';
  }

  @override
  String get valueOpenQuestion => 'Noch nicht zugeordnet';

  @override
  String get valueOtherPanel => 'Weitere Werte';

  @override
  String get flagLow => 'niedrig';

  @override
  String get flagHigh => 'hoch';

  @override
  String get flagCriticalLow => 'kritisch niedrig';

  @override
  String get flagCriticalHigh => 'kritisch hoch';

  @override
  String get flagAbnormal => 'auffällig';

  @override
  String get aboutTitle => 'Über trackfit';

  @override
  String get aboutBody =>
      'trackfit speichert deine Laborwerte auf diesem Gerät und zeigt, wie sie sich über die Zeit entwickeln.';

  @override
  String get aboutLoinc =>
      'Diese App verwendet LOINC®-Codes. LOINC ist urheberrechtlich geschützt © Regenstrief Institute, Inc. und das LOINC Committee und steht kostenlos unter der Lizenz auf loinc.org/license zur Verfügung. LOINC® ist eine in den USA eingetragene Marke des Regenstrief Institute, Inc.';

  @override
  String get aboutLicenses => 'Open-Source-Lizenzen';

  @override
  String aboutTerminology(String release) {
    return 'Terminologie: $release';
  }
}
