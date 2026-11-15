import 'package:flutter/material.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';
import 'package:ucum/ucum.dart';

import '../../l10n/generated/app_localizations.dart';
import 'value_format.dart';

/// One point of a series in the unit it is shown in.
class SeriesPoint {
  const SeriesPoint({
    required this.reading,
    required this.date,
    required this.value,
    this.refLow,
    this.refHigh,
  });

  final VObservationData reading;
  final DateTime date;
  final double value;
  final double? refLow;
  final double? refHigh;
}

/// A series prepared for display: one unit, numbers converted into it.
class SeriesView {
  SeriesView(this.summary)
    : unit = _displayUnit(summary),
      points = _points(summary, _displayUnit(summary));

  SeriesView._(this.summary, this.unit, this.points);

  final SeriesSummary summary;

  /// Unit the series is shown in: the canonical unit of a coded analyte,
  /// else the unit of the newest reading.
  final String unit;
  final List<SeriesPoint> points;

  VObservationData get latest => summary.latest;

  String get name => readingName(latest);

  String get category => latest.category ?? '';

  bool get isAbnormal => latest.flag != Flag.none;

  /// Waits for an answer; a name marked as not standard is not open.
  bool get isOpen => latest.outcome == CodingOutcome.needsInput;

  /// The same series shown in [target]; null when it cannot be converted.
  SeriesView? inUnit(String target, {double? molarMass}) {
    if (target == unit) return this;
    double? convert(double? v) =>
        v == null ? null : convertValue(v, unit, target, molarMass: molarMass);
    final converted = <SeriesPoint>[];
    for (final p in points) {
      final value = convert(p.value);
      if (value == null) return null;
      converted.add(
        SeriesPoint(
          reading: p.reading,
          date: p.date,
          value: value,
          refLow: convert(p.refLow),
          refHigh: convert(p.refHigh),
        ),
      );
    }
    return SeriesView._(summary, target, converted);
  }

  /// Points from [since] on.
  List<SeriesPoint> pointsSince(DateTime? since) => since == null
      ? points
      : points.where((p) => !p.date.isBefore(since)).toList();

  static String _displayUnit(SeriesSummary summary) =>
      summary.latest.unitCanonical ?? summary.latest.unitUcum;

  /// Numeric readings in [unit]. A reading in another unit is converted
  /// with the factor of its canonical value; its reference range scales the
  /// same way. Readings that cannot be converted are left out of the chart.
  static List<SeriesPoint> _points(SeriesSummary summary, String unit) {
    final points = <SeriesPoint>[];
    for (final reading in summary.history) {
      final number = reading.valueNum;
      if (number == null) continue;
      double? factor;
      if (reading.unitUcum == unit) {
        factor = 1;
      } else if (reading.unitCanonical == unit &&
          reading.valueCanonical != null &&
          number != 0) {
        factor = reading.valueCanonical! / number;
      }
      if (factor == null) continue;
      points.add(
        SeriesPoint(
          reading: reading,
          date: DateTime.parse(reading.localDate),
          value: number * factor,
          refLow: reading.refLow == null ? null : reading.refLow! * factor,
          refHigh: reading.refHigh == null ? null : reading.refHigh! * factor,
        ),
      );
    }
    return points;
  }
}

/// Label of a category of the terminology.
String categoryLabel(AppLocalizations l10n, String category) =>
    switch (category) {
      'blood-count' => l10n.categoryBloodCount,
      'iron' => l10n.categoryIron,
      'liver' => l10n.categoryLiver,
      'kidney' => l10n.categoryKidney,
      'lipids' => l10n.categoryLipids,
      'metabolism' => l10n.categoryMetabolism,
      'thyroid' => l10n.categoryThyroid,
      'vitamins' => l10n.categoryVitamins,
      'electrolytes' => l10n.categoryElectrolytes,
      'inflammation' => l10n.categoryInflammation,
      'infection' => l10n.categoryInfection,
      'coagulation' => l10n.categoryCoagulation,
      _ => l10n.categoryOther,
    };

/// Order of the categories in lists.
const categoryOrder = [
  'blood-count',
  'iron',
  'metabolism',
  'lipids',
  'liver',
  'kidney',
  'thyroid',
  'vitamins',
  'electrolytes',
  'inflammation',
  'coagulation',
  'infection',
];

/// A number in the locale of [context], with at most [decimals] places.
String formatNumber(BuildContext context, double value, {int decimals = 2}) {
  final locale = Localizations.localeOf(context).languageCode;
  var text = value.toStringAsFixed(decimals);
  if (text.contains('.')) {
    text = text.replaceFirst(RegExp(r'\.?0+$'), '');
  }
  return locale == 'de' ? text.replaceAll('.', ',') : text;
}
