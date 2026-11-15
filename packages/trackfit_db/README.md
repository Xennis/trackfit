# trackfit_db

SQLite schema and data access of trackfit, built with
[drift](https://drift.simonbinder.eu).

- Tables, views and constraints live as SQL in `lib/src/schema/*.drift`.
- Enums are stored as stable kebab-case strings, points in time as UTC
  milliseconds.
- Observations are append-only: a correction is a new row with `amends`.

Pure Dart: tests run on an in-memory SQLite database.

```bash
dart run build_runner build   # regenerate *.g.dart after schema changes
dart test
```
