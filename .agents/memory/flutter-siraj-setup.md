---
name: Flutter Siraj App Setup
description: Environment setup, build commands, and SDK constraints for the Siraj Quran Flutter app.
---

## SDK & Runtime
- Flutter 3.32.0 / Dart 3.8.0 installed via Nix (`flutter` system package).
- pubspec.yaml SDK constraint: `sdk: '>=3.0.0 <4.0.0'`
- `shared_preferences: ^2.3.0` (downgraded from ^2.4.x to avoid constraint conflict)

## Build & Dev Server
- Build: `flutter build web --release --base-href "/"`
- Serve: `python3 -m http.server 5000 --directory build/web --bind 0.0.0.0`
- After ANY code change, must rebuild then restart the workflow.

## Deployment
- Static deployment: build command `flutter build web --release --base-href /`, publicDir `build/web`.

**Why:** The replit preview pane is a proxied iframe; `--base-href /` is mandatory or asset paths break.
