import 'package:trackfit_core/trackfit_core.dart';
import 'package:ucum/ucum.dart';

import 'coding.dart';
import 'flag.dart';
import 'fold.dart';
import 'parse_value.dart';
import 'reference.dart';

/// A reading as printed, with everything derived from it.
class StandardizedReading {
  const StandardizedReading({
    required this.draft,
    required this.nameKey,
    required this.value,
    required this.unitText,
    required this.unitUcum,
    required this.reference,
    required this.flag,
    required this.coding,
    required this.valueCanonical,
  });

  final ObservationDraft draft;
  final String nameKey;
  final ParsedValue value;

  /// Unit as printed, from the unit cell or the value cell.
  final String unitText;

  /// '' when there is no unit or it is not recognized.
  final String unitUcum;
  final ParsedReference reference;
  final Flag flag;
  final CodingResult coding;

  /// Value in the canonical unit of the coded analyte, if convertible.
  final double? valueCanonical;

  /// Series of a reading without code: `name_key|unit`.
  String get localKey => '$nameKey|$unitUcum';

  /// What may be drawn on one axis.
  String get seriesId {
    final code = coding.code;
    return coding.isCoded && code != null ? 'loinc:$code' : 'local:$localKey';
  }
}

/// Derives typed values and a code from a printed reading.
StandardizedReading standardizeDraft(ObservationDraft draft, Coder coder) {
  final key = nameKey(draft.name);
  final value = parseValue(draft.value);
  final unitText = draft.unit.trim().isNotEmpty
      ? draft.unit.trim()
      : value.unitInValue;
  final unitUcum = normalizeUnit(unitText) ?? '';
  final reference = parseReference(draft.reference);
  final coding = coder.code(
    nameKey: key,
    unitUcum: unitUcum,
    valueKind: value.kind,
  );
  final number = value.number;
  final canonicalUnit = coding.canonicalUnit;
  final canonical =
      coding.isCoded &&
          number != null &&
          canonicalUnit != null &&
          unitUcum.isNotEmpty
      ? convertValue(
          number,
          unitUcum,
          canonicalUnit,
          molarMass: coding.molarMass,
        )
      : null;
  return StandardizedReading(
    draft: draft,
    nameKey: key,
    value: value,
    unitText: unitText,
    unitUcum: unitUcum,
    reference: reference,
    flag: normalizeFlag(draft.flag, value: number, reference: reference),
    coding: coding,
    valueCanonical: canonical,
  );
}
