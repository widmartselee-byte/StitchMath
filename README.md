# Stitch Math

A four-step knitting calculator. Count your swatch, describe the piece, pick the yarn — the app
returns the cast-on, the row count, the yarn in metres and how many skeins to buy.

Pure SwiftUI, iOS 17+, **fully offline**: no account, no network requests, no third-party SDKs,
no advertising, no in-app purchases.

## The four steps

| Step | What you enter | What you get |
|---|---|---|
| 1 Gauge | stitches and rows counted over 10 cm or 4 in | density per 10 cm, stitch width and row height |
| 2 Size | finished width/height, pattern repeat and edge stitches | cast-on rounded to the repeat, row count |
| 3 Yarn | yarn weight, metres per skein, grams per skein, safety margin | yarn in metres, skeins to buy |
| 4 Result | a name, if you want to keep it | everything above, saveable to the plan library |

The repeat step matters more than it sounds: a repeat of 8 with 2 edge stitches means the cast-on
must be a multiple of 8 plus 2, and the app rounds up to the next legal number instead of leaving
you to unpick the first row.

## How the yarn figure is reached

```
yarn (cm) ≈ stitches worked × 0.072 × (stitch width + row height)
```

then scaled by the safety margin (0 / 10 / 20 %). The 0.072 coefficient is reverse-engineered from
finished stockinette; cables, lace and ribbing eat more, which is why 10 % is the default. It is a
planning number, not a promise — see the About sheet inside the app.

## Structure

```
StitchMath.xcodeproj/          hand-maintained pbxproj
StitchMath/
  StitchMathApp.swift          @main, StitchAppState, StitchPalette
  Models/
    StitchGauge.swift          swatch, units, per-cm conversions
    StitchProject.swift        finished size + pattern-repeat alignment
    StitchYarn.swift           yarn weights, skein, plan calculation
    StitchSavedProject.swift   what a saved plan contains
    StitchLibrary.swift        JSON persistence in the app sandbox
  Support/
    StitchText.swift           every user-facing string
    StitchFormat.swift         numbers, metres, dates
    StitchSettings.swift       units and display preferences
  Views/
    StitchWizardView.swift     step shell, progress, About/Settings sheet
    StitchGaugeStep.swift      step 1
    StitchSizeStep.swift       step 2
    StitchYarnStep.swift       step 3
    StitchResultView.swift     step 4 + saved-plans sheet
    StitchNumberField.swift    shared rows, tiles and card container
  Resources/
    Assets.xcassets/           AppIcon (1024, no alpha), AccentColor
codemagic.yaml                 compile-check / ios-build / demo-capture
support.html, privacy.html     App Store support + privacy pages
tools/                         icon generator, self-check
```

No `Localizable.strings` on purpose: this build is English-only, so there is one fewer resource to
keep in sync.

## Before the first signed build

Replace `com.example.stitchmath` in three places:

1. `StitchMath.xcodeproj/project.pbxproj` (Debug and Release)
2. `codemagic.yaml` → `ios_signing.bundle_identifier`
3. `codemagic.yaml` → `app-store-connect fetch-signing-files`

## Build

1. Push the **contents** of this folder to a GitHub repository
2. Codemagic → Add application → Native iOS → `codemagic.yaml`
3. Settings → Integrations → Developer Portal → add the App Store Connect API key
4. Settings → Environment variables → group with `APP_STORE_CONNECT_PRIVATE_KEY`
5. Run `compile-check`, then `ios-build`

## Self-check

```
python3 tools/selfcheck.py
```

Exits non-zero if the project file and the folder disagree, if a bracket is unbalanced, if a
networking symbol appears, or if the icon is not 1024×1024 RGB.

## App Review notes for this submission

The app is a **four-step wizard**. Step one asks for a swatch count; the Continue button is
disabled until both counts are above zero. Steps two and three show live results, and step four
holds the summary plus the save action. Saved plans are reachable from the ••• menu. No account,
no permissions, no network.
