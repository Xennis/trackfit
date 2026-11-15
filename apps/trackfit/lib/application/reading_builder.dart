import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

/// Where a reading of a report comes from.
class ReadingSource {
  const ReadingSource({
    required this.personId,
    required this.reportId,
    required this.reportDate,
    required this.timeZone,
    required this.now,
    this.extractionId,
    this.modality = Modality.llmUnverified,
  });

  final int personId;
  final int reportId;
  final int? extractionId;

  /// `YYYY-MM-DD`; every reading of a report gets this day.
  final String reportDate;
  final String timeZone;
  final DateTime now;
  final Modality modality;
}

/// Builds the row of a lab reading for [reading] at position [rowIx].
///
/// A lab report only tells the day, so the reading covers that whole day
/// without a time zone of its own (`floating`).
NewObservation buildLabReading(
  StandardizedReading reading,
  ReadingSource source, {
  required int rowIx,
  required String terminologyRelease,
}) {
  final draft = reading.draft;
  final day = DateTime.parse('${source.reportDate}T00:00:00Z');
  final value = reading.value;
  final reference = reading.reference;
  final coding = reading.coding;
  final sourceRef = 'report:${source.reportId}';
  final fingerprint = sha256
      .convert(
        utf8.encode(
          [
            draft.name,
            draft.value,
            reading.unitText,
            draft.reference,
            draft.flag,
            source.reportDate,
            sourceRef,
          ].join('\n'),
        ),
      )
      .toString();
  final concept = coding.concept;
  final code = coding.code;
  final codeSystem = coding.codeSystem;

  return NewObservation(
    ObservationCompanion.insert(
      personId: source.personId,
      kind: ObservationKind.measurement,
      modality: source.modality,
      sourceKind: SourceKind.file,
      sourceRef: sourceRef,
      sourceRecordId: Value('row:$rowIx'),
      extractionId: Value(source.extractionId),
      reportId: Value(source.reportId),
      pageIx: Value(
        draft.page == null || draft.page! < 1 ? null : draft.page! - 1,
      ),
      rowIx: Value(rowIx),
      sourceClass: SourceClass.measurer,
      panelText: Value(draft.panel),
      observedStart: day,
      observedEnd: day.add(const Duration(days: 1)),
      tz: source.timeZone,
      tzSource: TzSource.floating,
      localDate: source.reportDate,
      grain: Grain.day,
      stat: const Value(Stat.last),
      nameText: draft.name,
      valueText: Value(draft.value),
      unitText: Value(reading.unitText),
      refText: Value(draft.reference),
      flagText: Value(draft.flag),
      methodText: Value(draft.method),
      specimenText: Value(draft.specimen),
      nameKey: reading.nameKey,
      valueKind: value.kind,
      valueNum: Value(value.number),
      valueDecimals: Value(value.decimals),
      comparator: Value(value.comparator),
      valueCode: Value(value.code),
      dataAbsentReason: Value(value.absentReason),
      unitUcum: Value(reading.unitUcum),
      refLow: Value(reference.low),
      refHigh: Value(reference.high),
      refComparator: Value(reference.comparator),
      flag: Value(reading.flag),
      localKey: reading.localKey,
      streamKey: '${reading.localKey}|file:',
      fingerprint: fingerprint,
      createdAt: source.now,
    ),
    CodingInput(
      terminologyRelease: terminologyRelease,
      outcome: coding.outcome,
      rule: coding.rule,
      reason: coding.reason,
      seriesId: reading.seriesId,
      codeSystem: codeSystem,
      code: code,
      groupId: coding.groupId,
      valueCanonical: reading.valueCanonical,
      unitCanonical: coding.canonicalUnit,
      evidence: coding.evidence,
      concept: concept == null || code == null || codeSystem == null
          ? null
          : ConceptCompanion.insert(
              terminologyRelease: terminologyRelease,
              codeSystem: codeSystem,
              code: code,
              display: concept.display,
              displayDe: Value(concept.displayDe),
              shortName: Value(concept.shortName),
              category: Value(concept.category),
              component: Value(concept.component),
              property: Value(concept.property),
              timeAspect: Value(concept.timeAspect),
              system: Value(concept.system),
              scale: Value(concept.scale),
              method: Value(concept.method),
            ),
    ),
  );
}
