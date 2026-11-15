# trackfit app

Flutter app for Android and Linux.

## What it does

1. Import a lab report as PDF or photos (file picker, drag and drop,
   camera, gallery). Files are copied into the app directory, addressed by
   their SHA-256, so the same file is never imported twice.
2. Recognize the text with Mistral OCR and read the values with a Mistral
   chat model that answers in a fixed JSON schema. Names, values and units
   are kept exactly as printed.
3. Standardize: fold names, type values, normalize units to UCUM, parse
   reference ranges, and assign LOINC codes from the bundled terminology.
   Values that cannot be assigned safely become open questions.
4. Show reports, their recognized text and values, and every value over
   time with the reference range of each measurement.

Recognition needs a Mistral API key and the consent of the person; both
are set in the app and stored in the secure storage of the system. Without
them files are only stored.

## Layout

```
lib/
  app/            start, routing, theme
  application/    use cases: import, processing, extraction, corrections
  data/           database and file providers
  platform/       OCR, language model, PDF, images, terminology loading
  ui/             screens and widgets
  l10n/           English and German texts (ARB)
assets/
  terminology.sqlite   built by tools/build_terminology
```

## Run

```bash
mise run run          # Linux desktop with hot reload
mise run test
mise run build:apk    # debug APK
```

Texts live in `lib/l10n/app_*.arb`; `mise run l10n` regenerates the code.
