#!/usr/bin/env bash
set -e
flutter pub get
flutter build web --release --base-href /
