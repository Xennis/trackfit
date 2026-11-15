/// An enum whose values are stored and exchanged as stable strings.
///
/// The [wire] value is what the database and JSON payloads contain. It is
/// kebab-case and must never change once data has been written with it, so
/// renaming a Dart enum value does not affect stored data.
abstract interface class WireEnum {
  String get wire;
}

/// Returns the value of [values] whose [WireEnum.wire] equals [wire].
///
/// Throws an [ArgumentError] for an unknown value instead of guessing.
T enumFromWire<T extends WireEnum>(List<T> values, String wire) {
  for (final value in values) {
    if (value.wire == wire) return value;
  }
  throw ArgumentError.value(wire, 'wire', 'unknown value for $T');
}
