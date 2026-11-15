import 'dart:math' as math;

/// Base dimensions a lab unit is made of.
enum Dimension {
  mass,
  amount,
  volume,
  count,

  /// International units of a substance, never convertible to mass.
  internationalUnit,

  /// Enzyme units (U), never convertible to anything else.
  enzymeUnit,
  equivalent,
}

/// A unit as a factor of base units with exponents per [Dimension].
///
/// `mg/dL` is 1e-3 g / 1e-1 L = factor 1e-2 with mass^1 volume^-1.
class QuantityUnit {
  const QuantityUnit(this.factor, this.dimensions);

  final double factor;
  final Map<Dimension, int> dimensions;

  QuantityUnit operator /(QuantityUnit other) {
    final dims = Map<Dimension, int>.of(dimensions);
    other.dimensions.forEach((d, e) => dims[d] = (dims[d] ?? 0) - e);
    dims.removeWhere((_, e) => e == 0);
    return QuantityUnit(factor / other.factor, dims);
  }

  bool sameDimensionAs(QuantityUnit other) =>
      _mapEquals(dimensions, other.dimensions);

  /// Dimensions of this unit divided by [other], e.g. mass/amount.
  Map<Dimension, int> dimensionsOver(QuantityUnit other) =>
      (this / other).dimensions;

  static bool _mapEquals(Map<Dimension, int> a, Map<Dimension, int> b) =>
      a.length == b.length && a.entries.every((e) => b[e.key] == e.value);
}

/// SI prefixes used in lab units, keyed by their UCUM symbol.
const prefixes = <String, double>{
  'f': 1e-15,
  'p': 1e-12,
  'n': 1e-9,
  'u': 1e-6,
  'm': 1e-3,
  'c': 1e-2,
  'd': 1e-1,
  'k': 1e3,
};

/// Atoms of lab units, keyed by their UCUM symbol.
const atoms = <String, QuantityUnit>{
  'g': QuantityUnit(1, {Dimension.mass: 1}),
  'mol': QuantityUnit(1, {Dimension.amount: 1}),
  'L': QuantityUnit(1, {Dimension.volume: 1}),
  '[IU]': QuantityUnit(1, {Dimension.internationalUnit: 1}),
  'U': QuantityUnit(1, {Dimension.enzymeUnit: 1}),
  'eq': QuantityUnit(1, {Dimension.equivalent: 1}),
};

/// A count such as `10*3`, as a unit of the count dimension.
QuantityUnit countUnit(int exponent) =>
    QuantityUnit(math.pow(10, exponent).toDouble(), {Dimension.count: 1});
