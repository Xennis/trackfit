import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';

void main() {
  final allEnums = <List<WireEnum>>[
    ObservationKind.values,
    Modality.values,
    SourceKind.values,
    SourceClass.values,
    Grain.values,
    ValueKind.values,
    Comparator.values,
    ObservationStatus.values,
    CodingOutcome.values,
    ReportStatus.values,
    DateSource.values,
    FileKind.values,
    ImportChannel.values,
    ExtractionStatus.values,
    TzSource.values,
    Stat.values,
    Flag.values,
    CodingCause.values,
    Sex.values,
  ];

  test('wire values are unique within each enum', () {
    for (final values in allEnums) {
      final wires = values.map((v) => v.wire).toList();
      expect(wires.toSet(), hasLength(wires.length), reason: '$values');
    }
  });

  test('wire values are kebab-case or symbols', () {
    final pattern = RegExp(r'^([a-z]+(-[a-z]+)*|[<>=]*)$');
    for (final values in allEnums) {
      for (final value in values) {
        expect(value.wire, matches(pattern), reason: '$value');
      }
    }
  });

  test('enumFromWire finds a value', () {
    expect(enumFromWire(Modality.values, 'lab-report'), Modality.labReport);
    expect(enumFromWire(Comparator.values, '<='), Comparator.lessOrEqual);
  });

  test('enumFromWire rejects an unknown value', () {
    expect(() => enumFromWire(Modality.values, 'guess'), throwsArgumentError);
  });
}
