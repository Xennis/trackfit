import 'dart:io';

import 'package:args/args.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:standardize/standardize.dart';
import 'package:standardize/terminology_sqlite.dart';

/// Builds the terminology database from the seed tables.
///
/// Run from the repository root:
/// `dart run tools/build_terminology/bin/build_terminology.dart`
void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('seed', defaultsTo: 'packages/standardize/seed')
    ..addOption('out', defaultsTo: 'apps/trackfit/assets/terminology.sqlite')
    ..addOption('release', defaultsTo: 'seed-2026.11.5');
  final options = parser.parse(arguments);
  final seed = options.option('seed')!;
  final out = File(options.option('out')!);

  final terminology = Terminology.fromSeed(
    release: options.option('release')!,
    labTests: File('$seed/lab_tests.tsv').readAsStringSync(),
    categories: File('$seed/categories.tsv').readAsStringSync(),
  );
  if (out.existsSync()) out.deleteSync();
  out.parent.createSync(recursive: true);
  final db = sqlite3.open(out.path);
  try {
    writeTerminology(db, terminology);
    db.execute('VACUUM');
  } finally {
    db.close();
  }
  stdout.writeln(
    'Wrote ${out.path}: ${terminology.entries.length} codes, '
    '${terminology.aliases.length} names, release ${terminology.release}',
  );
}
