import 'quantity_unit.dart';

/// Units that do not follow the `<numerator>/<denominator>` pattern, keyed
/// by their folded printed form.
const _special = <String, String>{
  '%': '%',
  'vol%': '%',
  'vol.%': '%',
  'mm/h': 'mm/h',
  'mm/1h': 'mm/h',
  's': 's',
  'sec': 's',
  'sek': 's',
  'min': 'min',
  'ratio': '{ratio}',
  'index': '{index}',
  'kg': 'kg',
  'g': 'g',
  'cm': 'cm',
  'm': 'm',
  'mmhg': 'mm[Hg]',
  'fl': 'fL',
  'pg': 'pg',
  'ml/min/1.73m2': 'mL/min/{1.73_m2}',
  'ml/min/1,73m2': 'mL/min/{1.73_m2}',
  'ml/min': 'mL/min',
  'bpm': '/min',
  '/min': '/min',
  'kg/m2': 'kg/m2',
  'mosm/kg': 'mosm/kg',
};

/// Printed counts in front of a volume, as powers of ten.
const _counts = <String, int>{
  '': 0,
  '10*3': 3,
  '10*6': 6,
  '10*9': 9,
  '10*12': 12,
  'tsd': 3,
  'tsd.': 3,
  'mio': 6,
  'mio.': 6,
  'gpt': 9,
  'giga': 9,
  'tpt': 12,
  'tera': 12,
  // Cells, as in `c/nl` or `Zellen/µl`: a plain count.
  'c': 0,
  'zellen': 0,
  'mrd': 9,
  'mrd.': 9,
};

/// Printed atoms, keyed by their folded form.
const _printedAtoms = <String, String>{
  'g': 'g',
  'mol': 'mol',
  'l': 'L',
  'iu': '[IU]',
  'ie': '[IU]',
  'u': 'U',
  'e': 'U',
  'eq': 'eq',
};

/// Folds a printed unit: one micro sign, no spaces, lower case, `^` as `*`.
String _fold(String printed) => printed
    .trim()
    .replaceAll(RegExp(r'\s+'), '')
    .replaceAll('µ', 'u')
    .replaceAll('μ', 'u')
    .replaceAll('mcg', 'ug')
    .replaceAll('²', '2')
    .replaceAll('^', '*')
    .replaceAll('x10*', '10*')
    .toLowerCase();

/// The UCUM code of a unit as printed, or null when it is not recognized.
///
/// Recognizes the units of common lab tests in German and English
/// spellings, e.g. `µg/dl`, `mmol/l`, `IE/l`, `Tsd/µl`, `Gpt/l`, `%`.
String? normalizeUnit(String printed) {
  final folded = _fold(printed);
  if (folded.isEmpty) return null;
  final special = _special[folded];
  if (special != null) return special;

  final slash = folded.indexOf('/');
  if (slash < 0) return _prefixedAtom(folded);
  final numerator = folded.substring(0, slash);
  final denominator = folded.substring(slash + 1);
  final volume = _prefixedAtom(denominator);
  if (volume == null || !volume.endsWith('L')) return null;

  final count = _counts[numerator];
  if (count != null) {
    return count == 0 ? '/$volume' : '10*$count/$volume';
  }
  final top = _prefixedAtom(numerator);
  return top == null ? null : '$top/$volume';
}

/// `mg` → `mg`, `uiu` → `u[IU]`, `dl` → `dL`; null when not an atom.
String? _prefixedAtom(String folded) {
  final atom = _printedAtoms[folded];
  if (atom != null) return atom;
  if (folded.length < 2) return null;
  final prefix = folded[0];
  final rest = _printedAtoms[folded.substring(1)];
  if (rest == null || !prefixes.containsKey(prefix)) return null;
  return '$prefix$rest';
}

/// The unit behind a UCUM code produced by [normalizeUnit], or null for
/// codes that can only be compared by their spelling, such as `%`.
QuantityUnit? parseUcum(String code) {
  final slash = code.indexOf('/');
  if (slash < 0) return _atomUnit(code);
  final top = code.substring(0, slash);
  final bottom = _atomUnit(code.substring(slash + 1));
  if (bottom == null) return null;
  if (top.isEmpty) return countUnit(0) / bottom;
  final count = RegExp(r'^10\*(\d+)$').firstMatch(top);
  if (count != null) return countUnit(int.parse(count.group(1)!)) / bottom;
  final numerator = _atomUnit(top);
  return numerator == null ? null : numerator / bottom;
}

QuantityUnit? _atomUnit(String code) {
  final atom = atoms[code];
  if (atom != null) return atom;
  if (code.length < 2) return null;
  final factor = prefixes[code[0]];
  final rest = atoms[code.substring(1)];
  if (factor == null || rest == null) return null;
  return QuantityUnit(factor * rest.factor, rest.dimensions);
}
