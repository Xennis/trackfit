import 'dart:io';

import 'package:standardize/standardize.dart';

/// The terminology built from the seed tables of this package.
Terminology seedTerminology() => Terminology.fromSeed(
  release: 'seed-test',
  labTests: File('seed/lab_tests.tsv').readAsStringSync(),
  categories: File('seed/categories.tsv').readAsStringSync(),
);
