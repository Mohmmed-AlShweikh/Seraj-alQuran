---
name: Siraj App Architecture
description: Provider/Hive/Repository pattern, key provider classes, and data flow for the Siraj Quran app.
---

## State Management
- Provider package with `MultiProvider` in `main.dart`.
- Key providers: `ThemeProvider`, `QuranProvider`, `FavoritesProvider`, `AppRepositoryProvider`.
- All providers have an `init()` async method called at startup.

## Data Layer
- Hive for local storage; boxes opened in `main.dart` before providers init.
- Box names all defined in `AppConstants` (e.g. `favoritesBoxName = 'favorites_box'`).
- `AppRepositoryProvider` wires datasources → repositories; accessed via `context.read<AppRepositoryProvider>().xRepository`.

## Key Providers
- `FavoritesProvider`: Hive-backed, exposes `toggle(id,text,type,{reference})`, `isFavorite(id)`, `remove(id)`, `allFavorites`, `count`.
- `ThemeProvider`: `themeMode`, `quranFontSize` (16–32, stored in settings_box under `fontSizeKey`), `setThemeMode()`, `setQuranFontSize()`.
- `QuranProvider`: `surahs`, `readingProgress` (ReadingProgressModel), `saveReadingProgress(surah,ayah,page)`.

## Theming
- `AppTheme.lightTheme` / `darkTheme` in `lib/config/theme/app_theme.dart`.
- Primary: `#1B7A3F` (green), Secondary: `#C9934D` (gold).
- Responsive extension in `lib/config/theme/responsive.dart`: `context.isLandscape`.

## `_toArabicNumber` helper
- Duplicated in: `dhikrCard.dart`, `nameCard.dart`, `roqiaCard.dart`, `surah_detail_screen.dart`, `tasbih_screen.dart`, `surahCard.dart`.
- Known tech debt — not yet centralized into a shared utility.

**Why:** Centralizing into a utils file is safe but low-priority; duplicates work fine.
