import 'package:sqlite3/sqlite3.dart';
import 'package:standardize/standardize.dart';
import 'package:standardize/terminology_sqlite.dart';
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';

void main() {
  test('round-trips a terminology through the database', () {
    final terminology = Terminology.fromSeed(
      release: 'test',
      labTests:
          '2498-4\tiron\tMCnc\tQn\tug/dL,ug/L\tug/dL\t55.845\tiron\tEisen\t'
          'Eisen\tIron [Mass/volume] in Serum or Plasma\tIron\tSer/Plas\tfe',
      categories: 'Blutbild',
    );
    final db = sqlite3.openInMemory();
    addTearDown(db.close);

    writeTerminology(db, terminology);
    final read = readTerminology(db);

    expect(read.release, 'test');
    expect(read.groupOf('fe'), 'iron');
    expect(read.isCategory('blutbild'), isTrue);
    final coded = LexicalCoder(
      read,
    ).code(nameKey: 'eisen', unitUcum: 'ug/L', valueKind: ValueKind.quantity);
    expect(coded.code, '2498-4');
    expect(coded.molarMass, 55.845);
  });
}
