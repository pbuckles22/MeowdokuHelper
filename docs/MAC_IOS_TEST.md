# iOS / Mac device testing (Phase 1b+)

Run after Wordle cleanup on a **Mac** with Xcode and CocoaPods installed.

## Prerequisites

```bash
cd meowdoku_helper
flutter pub get
cd ios && pod install && cd ..
```

## Tier 1b — unit tests (Mac)

```bash
cd meowdoku_helper
flutter test
```

FFI smoke test runs on macOS (not skipped like on Windows).

## Tier 2 — iPhone / simulator smoke

List devices:

```bash
flutter devices
```

Run integration smoke (placeholder UI + FFI init + pets icon):

```bash
flutter test integration_test/app_smoke_test.dart -d <device-id>
```

Or run the app:

```bash
flutter run -d <iphone-or-simulator-id>
```

Expect: **MeowdokuHelper** title, teal placeholder shell, **Rust bridge ready** after init.

## Windows note

`flutter test` on Windows skips native FFI load (no `rust_lib_meowdoku_helper.dll` in test harness). Use Mac for full bridge validation before iOS ship.
