import 'package:trackfit_core/trackfit_core.dart';

import 'reference.dart';

const _printedFlags = <String, Flag>{
  'h': Flag.high,
  '+': Flag.high,
  '↑': Flag.high,
  '>': Flag.high,
  'hoch': Flag.high,
  'high': Flag.high,
  'l': Flag.low,
  '-': Flag.low,
  '↓': Flag.low,
  '<': Flag.low,
  'n': Flag.low,
  'niedrig': Flag.low,
  'low': Flag.low,
  'hh': Flag.criticalHigh,
  '++': Flag.criticalHigh,
  '↑↑': Flag.criticalHigh,
  '!h': Flag.criticalHigh,
  'll': Flag.criticalLow,
  '--': Flag.criticalLow,
  '↓↓': Flag.criticalLow,
  '!l': Flag.criticalLow,
  '*': Flag.abnormal,
  '!': Flag.abnormal,
  'a': Flag.abnormal,
  'pathologisch': Flag.abnormal,
  'abnormal': Flag.abnormal,
};

/// The abnormal flag of a reading.
///
/// A printed flag wins. Without one, a [value] outside the [reference]
/// range is flagged low or high.
Flag normalizeFlag(
  String printed, {
  double? value,
  ParsedReference reference = ParsedReference.empty,
}) {
  final text = printed.trim().toLowerCase();
  if (text.isNotEmpty) return _printedFlags[text] ?? Flag.abnormal;
  if (value == null) return Flag.none;
  final low = reference.low;
  final high = reference.high;
  if (low != null) {
    final below = reference.comparator == Comparator.greaterThan
        ? value <= low
        : value < low;
    if (below) return Flag.low;
  }
  if (high != null) {
    final above = reference.comparator == Comparator.lessThan
        ? value >= high
        : value > high;
    if (above) return Flag.high;
  }
  return Flag.none;
}
