# ucum

Turns units as printed on lab reports into [UCUM](https://ucum.org) codes
and converts values between units.

```dart
normalizeUnit('µg/dl');            // 'ug/dL'
normalizeUnit('Tsd/µl');           // '10*3/uL'
convertValue(52, 'ug/dL', 'ug/L'); // 520.0
convertValue(24.3, 'ng/mL', 'nmol/L', molarMass: 400.64); // ~60.7
```

Three steps, in this order:

1. Same dimension: prefixes and volumes are converted by factor
   (`mg/dL` ↔ `g/L`, `10*9/L` ↔ `10*3/uL`).
2. Mass ↔ amount of substance needs the molar mass of the analyte.
3. Anything else is not converted: `%` of leukocytes and an absolute count
   are different measurements, not different units.

Pure Dart, no data files.

```bash
dart test
```
