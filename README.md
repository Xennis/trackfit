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
  trackfit/            Flutter app (Android, Linux)
packages/
  trackfit_core/       shared types: enums, observation drafts
  trackfit_db/         SQLite schema and data access (drift)
  ucum/                parse and convert units of lab results
  standardize/         name keys, value parsing, LOINC resolver, seed data
tools/
  build_terminology/   builds the terminology database bundled with the app
```

Each package has its own README.

## Development

Tool versions (Flutter, Java) are pinned in `mise.toml`. With
[mise](https://mise.jdx.dev) installed:

```bash
mise install
mise run get
mise run run          # start on the Linux desktop with hot reload
```

Other tasks: `mise tasks` lists them, e.g. `test:all` (analyze and every
test), `build:linux`, `start:linux`, `build:apk`, `terminology` (rebuild the
bundled terminology after changing the seed tables) and `codegen` (drift).

## Disclaimer

trackfit does not diagnose or give medical advice.
