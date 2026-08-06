---
name: Siraj App Architecture
description: Provider/Hive/repository pattern; key provider classes, Quran reader structure, and modular widget layout.
---

## State Management
- Provider (ChangeNotifier) throughout. Key providers:
  - `QuranProvider` — surah list, search, reading progress
  - `ThemeProvider` — theme mode, Quran font size (persisted in Hive settings box)
  - `FavoritesProvider` — favorites (Hive)

## Quran Reader — Post-Refactor Structure

### Files
- `lib/core/data/mushaf_page_data.dart` — Mushaf page metadata (604 pages, Hafs Uthmani). Key API:
  - `mushaafPages` (getter, cached) → `List<List<int>>` [surahNum, startAyah] per page
  - `getMushaafPagesForSurah(surahNumber, totalVerses)` → `List<MushaafPage>`
  - `MushaafPage` model: `{mushaafPageNumber, startAyah, endAyah}`
  - Precise intra-surah anchors for surahs 2–7; remaining surahs computed evenly from verse counts
- `lib/presentation/screens/quran/surah_detail_screen.dart` — `SurahDetailScreen`
  - Full-screen reader, no cards, no rounded containers
  - AppBar: surah name + verse count + font-size + bookmark actions
  - `PageView(reverse: true, physics: ClampingScrollPhysics)` for RTL horizontal swiping
  - `FloatingPageNavigation` overlay (fade-in on tap, auto-hide 3s)
- `lib/presentation/screens/quran/widgets/quran_page_widget.dart`
  - `QuranPageWidget` — renders verses for one MushaafPage
  - `QuranPageLayout` — wraps OverflowDetector, provides availableHeight constraint
- `lib/presentation/screens/quran/widgets/overflow_detector.dart`
  - `OverflowDetector` — SingleChildScrollView; checks `maxScrollExtent > 0` after first frame; enables ClampingScrollPhysics only if content overflows
- `lib/presentation/screens/quran/widgets/floating_page_navigation.dart`
  - `FloatingPageNavigation` — left/right edge buttons + page counter; AnimatedOpacity + Timer auto-hide
- `lib/presentation/screens/quran/widgets/font_size_controller.dart`
  - `FontSizeController.show(context, themeProvider)` — modal bottom sheet for font size

## Data Layer
- `assets/data/quran.json` — surah/verse data, loaded into Hive `quran_box`
- `lib/data/datasources/quran_local_datasource.dart` — Hive access
- `lib/data/repositories/quran_repository_impl.dart`
- `lib/domain/entities/entities.dart` — domain models (Surah, Verse, etc.)

## Font
- Arabic: `UthmanTN1` (`assets/fonts/UthmanTN1-Ver10.otf`)
- `AppConstants.arabicFontName = 'UthmanTN1'`

**Why:** Mushaf page metadata is stored (not calculated) per the requirement for official Hafs page divisions. OverflowDetector enables vertical scroll only when content overflows — no nested scroll views.
