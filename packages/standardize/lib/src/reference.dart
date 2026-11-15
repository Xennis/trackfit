import 'package:trackfit_core/trackfit_core.dart';

import 'parse_value.dart';

/// A reference range as printed, typed.
class ParsedReference {
  const ParsedReference({
    this.low,
    this.high,
    this.comparator = Comparator.none,
  });

  static const empty = ParsedReference();

  final double? low;
  final double? high;

  /// Set for a one-sided range such as `< 5,0`.
  final Comparator comparator;

  bool get isEmpty => low == null && high == null;
}

final _number = r'[+-]?\d+(?:[.,]\d+)?';
final _range = RegExp('^($_number)\\s*(?:-|–|—|bis|to)\\s*($_number)');
final _oneSided = RegExp(
  '^(<=|>=|≤|≥|<|>|bis|unter|über|kleiner|größer|up to)\\s*($_number)',
  caseSensitive: false,
);

const _sides = <String, Comparator>{
  '<': Comparator.lessThan,
  'unter': Comparator.lessThan,
  'kleiner': Comparator.lessThan,
  '<=': Comparator.lessOrEqual,
  '≤': Comparator.lessOrEqual,
  'bis': Comparator.lessOrEqual,
  'up to': Comparator.lessOrEqual,
  '>': Comparator.greaterThan,
  'über': Comparator.greaterThan,
  'größer': Comparator.greaterThan,
  '>=': Comparator.greaterOrEqual,
  '≥': Comparator.greaterOrEqual,
};

/// Reads the bounds of a printed reference range.
///
/// `60 - 170`, `0,1–4,0 mg/l`, `< 5,0`, `> 30`, `bis 40`. Anything else,
/// e.g. `negativ`, has no bounds.
ParsedReference parseReference(String printed) {
  final text = printed.trim();
  final range = _range.firstMatch(text);
  if (range != null) {
    final low = parseNumber(range.group(1)!)?.$1;
    final high = parseNumber(range.group(2)!)?.$1;
    if (low != null && high != null && low <= high) {
      return ParsedReference(low: low, high: high);
    }
    return ParsedReference.empty;
  }
  final oneSided = _oneSided.firstMatch(text);
  if (oneSided != null) {
    final comparator = _sides[oneSided.group(1)!.toLowerCase()]!;
    final bound = parseNumber(oneSided.group(2)!)?.$1;
    if (bound == null) return ParsedReference.empty;
    final upper =
        comparator == Comparator.lessThan ||
        comparator == Comparator.lessOrEqual;
    return ParsedReference(
      low: upper ? null : bound,
      high: upper ? bound : null,
      comparator: comparator,
    );
  }
  return ParsedReference.empty;
}
