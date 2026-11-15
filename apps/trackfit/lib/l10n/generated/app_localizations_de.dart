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

  @override
  String get categoryBloodCount => 'Blutbild';

  @override
  String get categoryIron => 'Eisenstoffwechsel';

  @override
  String get categoryLiver => 'Leber';

  @override
  String get categoryKidney => 'Niere';

  @override
  String get categoryLipids => 'Blutfette';

  @override
  String get categoryMetabolism => 'Stoffwechsel';

  @override
  String get categoryThyroid => 'Schilddrüse';

  @override
  String get categoryVitamins => 'Vitamine';

  @override
  String get categoryElectrolytes => 'Elektrolyte';

  @override
  String get categoryInflammation => 'Entzündung';

  @override
  String get categoryOther => 'Sonstige';

  @override
  String get valuesFilterAll => 'Alle';

  @override
  String get valuesFilterAbnormal => 'Auffällig';

  @override
  String get valuesFilterOpen => 'Offen';

  @override
  String valueMeasurements(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Messungen',
      one: '1 Messung',
    );
    return '$_temp0';
  }

  @override
  String get valueHistory => 'Messungen';

  @override
  String get valueAbout => 'Über diesen Wert';

  @override
  String valueLatestOn(String date) {
    return 'am $date';
  }

  @override
  String get valueRange1y => '1 Jahr';

  @override
  String get valueRange3y => '3 Jahre';

  @override
  String get valueRangeAll => 'Alle';

  @override
  String get valueOpenReport => 'Befund öffnen';

  @override
  String valueCode(String code) {
    return 'LOINC $code';
  }

  @override
  String get valueNotFound => 'Für diesen Wert gibt es keine Messungen.';

  @override
  String get valueUnit => 'Einheit';

  @override
  String get valueNoChart =>
      'Für einen Graphen braucht es Zahlen; dieser Wert ist nicht numerisch.';

  @override
  String get editValueTitle => 'Wert bearbeiten';

  @override
  String get addValueTitle => 'Wert hinzufügen';

  @override
  String get addValue => 'Wert hinzufügen';

  @override
  String get editName => 'Test';

  @override
  String get editValue => 'Wert';

  @override
  String get editUnit => 'Einheit';

  @override
  String get editReference => 'Referenzbereich';

  @override
  String get editFlag => 'Markierung';

  @override
  String get editOriginalKept => 'Das Original bleibt gespeichert.';

  @override
  String get save => 'Speichern';

  @override
  String get markAsError => 'Ausblenden';

  @override
  String get valueSaved => 'Wert gespeichert';

  @override
  String get valueRetracted => 'Wert ausgeblendet';

  @override
  String get editNeedsName => 'Gib den Namen des Tests ein';

  @override
  String get addValueNeedsDate => 'Setze zuerst das Befunddatum.';

  @override
  String get showPage => 'Seite zeigen';

  @override
  String get questionsTitle => 'Offene Fragen';

  @override
  String get questionsEmpty => 'Keine offenen Fragen.';

  @override
  String questionsBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Werte brauchen deine Hilfe',
      one: '1 Wert braucht deine Hilfe',
    );
    return '$_temp0';
  }

  @override
  String get questionWhichTest => 'Welcher Test ist das?';

  @override
  String get questionChooseTest => 'Test wählen';

  @override
  String get questionNotStandard => 'Kein Standardtest';

  @override
  String questionReports(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count Befunden',
      one: 'in 1 Befund',
    );
    return '$_temp0';
  }

  @override
  String get questionReasonNoMatch => 'Der Name ist noch nicht bekannt.';

  @override
  String get questionReasonAmbiguous =>
      'Der Name passt zu mehr als einem Test.';

  @override
  String get questionReasonUnitMissing =>
      'Die Einheit fehlt. Bearbeite den Wert im Befund.';

  @override
  String get questionReasonUnitConflict =>
      'Die Einheit passt nicht zu diesem Test. Prüfe den Wert im Befund.';

  @override
  String get questionReasonOther => 'Der Wert konnte nicht zugeordnet werden.';

  @override
  String questionAnswered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Werte zugeordnet',
      one: '1 Wert zugeordnet',
    );
    return '$_temp0';
  }

  @override
  String get questionSearch => 'Tests suchen';

  @override
  String get questionOpenReport => 'Befund öffnen';

  @override
  String get reportReprocess => 'Werte erneut auslesen';

  @override
  String get reportReprocessStarted => 'Der Befund wird erneut ausgelesen.';

  @override
  String overviewProcessing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Befunde werden verarbeitet',
      one: '1 Befund wird verarbeitet',
    );
    return '$_temp0';
  }

  @override
  String get overviewAbnormal => 'Auffällig';

  @override
  String get overviewNoAbnormal =>
      'Keine auffälligen Werte in den letzten Messungen.';

  @override
  String get overviewLatestReport => 'Letzter Befund';

  @override
  String get settingsTheme => 'Darstellung';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get settingsData => 'Daten';

  @override
  String settingsDataSummary(int reports, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      reports,
      locale: localeName,
      other: '$reports Befunde',
      one: '1 Befund',
    );
    return '$_temp0 · $size';
  }

  @override
  String settingsDataLocation(String path) {
    return 'Gespeichert in $path';
  }

  @override
  String get settingsBackup => 'Datenbank sichern';

  @override
  String get settingsBackupBody =>
      'Speichert eine Kopie aller Werte. Importierte Dateien sind nicht enthalten.';

  @override
  String get backupSaved => 'Sicherung gespeichert';

  @override
  String get backupFailed => 'Sicherung fehlgeschlagen';

  @override
  String get reportStatusNeedsSetup => 'Wartet auf Einrichtung der Erkennung';

  @override
  String overviewNeedsSetup(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Befunde warten auf die Einrichtung der Erkennung',
      one: '1 Befund wartet auf die Einrichtung der Erkennung',
    );
    return '$_temp0';
  }

  @override
  String get categoryInfection => 'Infektionen';

  @override
  String get questionNotAValue => 'Kein Messwert – ausblenden';

  @override
  String questionHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge ausgeblendet',
      one: '1 Eintrag ausgeblendet',
    );
    return '$_temp0';
  }
}
