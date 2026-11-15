# build_terminology

Builds `apps/trackfit/assets/terminology.sqlite` from the seed tables in
`packages/standardize/seed`.

```bash
# from the repository root
dart run tools/build_terminology/bin/build_terminology.dart
```

The database holds the codes (`loinc`), the folded names that point at an
analyte (`alias`), category terms that are never one test (`category`) and
the release (`meta`). The app reads it once at start.

LOINC® is a registered trademark of Regenstrief Institute, Inc. The codes and
names come from LOINC (https://loinc.org/license/).
