import 'package:trackfit_core/trackfit_core.dart';

/// A value as printed, typed.
class ParsedValue {
  const ParsedValue({
    required this.kind,
    this.number,
    this.decimals,
    this.comparator = Comparator.none,
    this.code = '',
    this.absentReason = '',
    this.unitInValue = '',
  });

  final ValueKind kind;

  /// The number of a [ValueKind.quantity].
  final double? number;

  /// Decimal places as printed, to show the number as it was reported.
  final int? decimals;
  final Comparator comparator;

  /// Normalized form of an ordinal or nominal value, e.g. `negative`, `2+`.
  final String code;

  /// Why a value is [ValueKind.absent], e.g. `not-performed`.
  final String absentReason;

  /// A unit printed in the value cell, e.g. `52 µg/dl`.
  final String unitInValue;
}

const _absent = <String, String>{
  '': 'not-reported',
  '-': 'not-performed',
  '--': 'not-performed',
  '---': 'not-performed',
  'n.b.': 'not-performed',
  'nb': 'not-performed',
  'n.d.': 'not-performed',
  'nicht bestimmt': 'not-performed',
  'entfällt': 'not-performed',
  'folgt': 'pending',
  'in arbeit': 'pending',
  's. bem.': 'see-comment',
  'siehe bemerkung': 'see-comment',
  'siehe befund': 'see-comment',
  'hämolytisch': 'sample-hemolyzed',
};

const _nominal = <String, String>{
  'negativ': 'negative',
  'neg': 'negative',
  'neg.': 'negative',
  'negative': 'negative',
  'positiv': 'positive',
  'pos': 'positive',
  'pos.': 'positive',
  'positive': 'positive',
  'normal': 'normal',
  'unauffällig': 'normal',
  'nicht nachweisbar': 'not-detected',
  'nicht nachgewiesen': 'not-detected',
  'not detected': 'not-detected',
  'nachweisbar': 'detected',
  'nachgewiesen': 'detected',
  'detected': 'detected',
};

const _ordinalWords = <String, String>{
  'spur': 'trace',
  'spuren': 'trace',
  'trace': 'trace',
  '(+)': '(+)',
};

final _comparator = RegExp(
  r'^(<=|>=|≤|≥|<|>|kleiner als|größer als|unter|über)\s*',
  caseSensitive: false,
);
final _germanThousands = RegExp(r'^[+-]?\d{1,3}(\.\d{3})+(,\d+)?$');
final _number = RegExp(r'^[+-]?\d+([.,]\d+)?$');
final _numberThenRest = RegExp(r'^([+-]?[\d.,]*\d)\s*(.*)$');
final _plus = RegExp(r'^\+{1,4}$');
final _countedPlus = RegExp(r'^([1-4])\s*\+$');

const _comparators = <String, Comparator>{
  '<': Comparator.lessThan,
  'unter': Comparator.lessThan,
  'kleiner als': Comparator.lessThan,
  '<=': Comparator.lessOrEqual,
  '≤': Comparator.lessOrEqual,
  '>': Comparator.greaterThan,
  'über': Comparator.greaterThan,
  'größer als': Comparator.greaterThan,
  '>=': Comparator.greaterOrEqual,
  '≥': Comparator.greaterOrEqual,
};

/// Types a value as printed.
///
/// `52`, `12,9` and `<0.5` are quantities, `++` is ordinal, `negativ` is
/// nominal, `n.b.` is absent, anything else stays narrative. `120/80` is
/// narrative: it is two readings, not one number.
ParsedValue parseValue(String printed) {
  final text = printed.trim();
  final lower = text.toLowerCase();

  final absent = _absent[lower];
  if (absent != null) {
    return ParsedValue(kind: ValueKind.absent, absentReason: absent);
  }
  final nominal = _nominal[lower];
  if (nominal != null) {
    return ParsedValue(kind: ValueKind.nominal, code: nominal);
  }
  final ordinalWord = _ordinalWords[lower];
  if (ordinalWord != null) {
    return ParsedValue(kind: ValueKind.ordinal, code: ordinalWord);
  }
  if (_plus.hasMatch(text)) {
    return ParsedValue(kind: ValueKind.ordinal, code: text);
  }
  final counted = _countedPlus.firstMatch(text);
  if (counted != null) {
    return ParsedValue(kind: ValueKind.ordinal, code: '${counted.group(1)}+');
  }

  var rest = text;
  var comparator = Comparator.none;
  final prefix = _comparator.firstMatch(rest);
  if (prefix != null) {
    comparator = _comparators[prefix.group(1)!.toLowerCase()]!;
    rest = rest.substring(prefix.end);
  }
  final split = _numberThenRest.firstMatch(rest);
  if (split != null) {
    final number = parseNumber(split.group(1)!);
    final tail = split.group(2)!.trim();
    if (number != null && !tail.startsWith('/') && !tail.startsWith('-')) {
      return ParsedValue(
        kind: ValueKind.quantity,
        number: number.$1,
        decimals: number.$2,
        comparator: comparator,
        unitInValue: tail,
      );
    }
  }
  return const ParsedValue(kind: ValueKind.narrative);
}

/// A printed number with its decimal places, or null.
///
/// Accepts `12,9`, `12.9`, `1.234,5` (German thousands) and `-3`.
(double, int)? parseNumber(String printed) {
  final text = printed.trim();
  String canonical;
  if (_germanThousands.hasMatch(text)) {
    canonical = text.replaceAll('.', '').replaceAll(',', '.');
  } else if (_number.hasMatch(text)) {
    canonical = text.replaceAll(',', '.');
  } else {
    return null;
  }
  final value = double.tryParse(canonical);
  if (value == null) return null;
  final dot = canonical.indexOf('.');
  return (value, dot < 0 ? 0 : canonical.length - dot - 1);
}
