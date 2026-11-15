# standardize

Turns a reading as printed on a lab report into typed values and a code.

- `nameKey`: one folded form of a printed test name, used as lookup key.
- `parseValue`: value kind, number, comparator and printed decimals.
- `parseReference`: low and high bound of a printed reference range.
- `normalizeFlag`: abnormal flag as printed, or derived from the range.

Codes are assigned from bundled tables, never by a language model. A name
that cannot be placed safely stays uncoded and becomes a question.

Pure Dart.

```bash
dart test
```

`package:standardize/terminology_sqlite.dart` reads and writes the
terminology database built by `tools/build_terminology`; the resolver itself
does not need SQLite.
