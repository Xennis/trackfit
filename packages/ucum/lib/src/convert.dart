import 'normalize.dart';
import 'quantity_unit.dart';

/// Converts [value] from the UCUM unit [from] to [to].
///
/// Units of the same dimension convert by factor. Mass and amount of
/// substance convert only with the [molarMass] of the analyte in g/mol.
/// Returns null when the units cannot be converted, e.g. `%` and an
/// absolute count; such values are different measurements.
double? convertValue(
  double value,
  String from,
  String to, {
  double? molarMass,
}) {
  if (from == to) return value;
  final source = parseUcum(from);
  final target = parseUcum(to);
  if (source == null || target == null) return null;
  if (source.sameDimensionAs(target)) {
    return value * source.factor / target.factor;
  }
  if (molarMass == null || molarMass <= 0) return null;
  final ratio = source.dimensionsOver(target);
  if (_isOnly(ratio, Dimension.mass, 1, Dimension.amount, -1)) {
    // mass → amount: divide by g/mol.
    return value * source.factor / target.factor / molarMass;
  }
  if (_isOnly(ratio, Dimension.amount, 1, Dimension.mass, -1)) {
    return value * source.factor / target.factor * molarMass;
  }
  return null;
}

/// Whether two units can be converted, possibly with a molar mass.
bool canConvert(String from, String to, {double? molarMass}) =>
    convertValue(1, from, to, molarMass: molarMass) != null;

bool _isOnly(
  Map<Dimension, int> dims,
  Dimension a,
  int ea,
  Dimension b,
  int eb,
) => dims.length == 2 && dims[a] == ea && dims[b] == eb;
