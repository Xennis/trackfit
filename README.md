# trackfit

A local-first app to collect, standardize and visualize personal health data.

Import a lab report as PDF or photo, let trackfit recognize the values, and
follow each value over time, for example iron across several reports in one
chart. All data stays on the device in SQLite.

## Goals

- Real app, no server. Data is stored locally.
- Android first, with a full desktop app (Linux).
- Readings keep the text as printed next to the standardized form.
- Tests are coded with [LOINC](https://loinc.org), units with
  [UCUM](https://ucum.org). Codes are assigned deterministically from bundled
  tables, never by a language model.
- Clear charts with reference ranges.

## Layout

This is a Dart [pub workspace](https://dart.dev/tools/pub/workspaces).

```
apps/
  trackfit/          Flutter app (Android, Linux)
packages/            Pure Dart packages, testable without Flutter
tools/               Command line tools, e.g. building the terminology database
```

## Development

Requirements: Flutter (stable) with Dart 3.11 or newer.

```bash
dart pub get
dart analyze
```

## Disclaimer

trackfit does not diagnose or give medical advice.
