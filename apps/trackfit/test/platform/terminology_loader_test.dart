import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit/platform/terminology/terminology_loader.dart';
import 'package:trackfit_core/trackfit_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads the bundled terminology and codes with it', () async {
    final dir = await Directory.systemTemp.createTemp('terminology_test');
    addTearDown(() => dir.delete(recursive: true));

    final terminology = await loadBundledTerminology(dir);

    expect(terminology.release, startsWith('seed-'));
    final coding = LexicalCoder(terminology).code(
      nameKey: nameKey('Ferritin'),
      unitUcum: 'ng/mL',
      valueKind: ValueKind.quantity,
    );
    expect(coding.code, '2276-4');
    expect(coding.concept?.displayDe, 'Ferritin');
  });
}
