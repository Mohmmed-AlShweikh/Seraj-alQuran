import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
import 'package:seraj_quran/core/data/mushaf_page_data.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/quran/quran_provider.dart';
import 'package:seraj_quran/presentation/providers/theme/theme_provider.dart';
import 'package:seraj_quran/presentation/screens/quran/widgets/floating_page_navigation.dart';
import 'package:seraj_quran/presentation/screens/quran/widgets/font_size_controller.dart';
import 'package:seraj_quran/presentation/screens/quran/widgets/quran_page_widget.dart';

/// Full-screen Mushaf reader.
///
/// Layout rules:
/// - No cards, no rounded containers, no large padding — text fills the page.
/// - PageView (NeverScrollableScrollPhysics) for left/right Mushaf pagination.
/// - Vertical scrolling enabled per-page only when font size causes overflow.
/// - FloatingPageNavigation fades in on tap and auto-hides after 3 s.
/// - Page metadata follows official Mushaf page divisions via [MushaafPage].
class SurahDetailScreen extends StatefulWidget {
  final Surah surah;

  /// 0-based index into the surah's Mushaf pages (not raw verse index).
  final int initialPage;

  const SurahDetailScreen({
    required this.surah,
    this.initialPage = 0,
    super.key,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late final PageController _pageController;
  late final List<MushaafPage> _mushaafPages;
  int _pageIndex = 0;
  bool _showNav = false; // controls FloatingPageNavigation visibility

  @override
  void initState() {
    super.initState();
    _mushaafPages = getMushaafPagesForSurah(
      widget.surah.number,
      widget.surah.verseCount,
    );
    final clampedInitial =
        widget.initialPage.clamp(0, (_mushaafPages.length - 1).clamp(0, 9999));
    _pageIndex = clampedInitial;
    _pageController = PageController(initialPage: clampedInitial);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ── Bookmark ──────────────────────────────────────────────────────────────

  Future<void> _saveBookmark() async {
    final page = _mushaafPages[_pageIndex];
    await context.read<QuranProvider>().saveReadingProgress(
          widget.surah.number,
          page.startAyah,
          _pageIndex,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.bookmark_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('تم حفظ العلامة'),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Navigation helpers ────────────────────────────────────────────────────

  void _goNext() {
    if (_pageIndex < _mushaafPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _goPrevious() {
    if (_pageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _toggleNav() => setState(() => _showNav = !_showNav);

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: _buildAppBar(themeProvider),
            body: _buildBody(themeProvider),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeProvider themeProvider) {
    return AppBar(
      centerTitle: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.surah.nameArabic,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${_toArabicNumber(widget.surah.verseCount)} آية',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppTheme.primaryColor.withValues(alpha: 0.75),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.text_increase_rounded),
          tooltip: 'حجم الخط',
          onPressed: () => FontSizeController.show(context, themeProvider),
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_add_outlined),
          tooltip: 'حفظ العلامة',
          onPressed: _saveBookmark,
        ),
      ],
    );
  }

  Widget _buildBody(ThemeProvider themeProvider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = context.isLandscape;
        // Available height for the page content area
        final availableHeight = constraints.maxHeight;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _toggleNav,
          child: Stack(
            children: [
              // ── PageView ────────────────────────────────────────────
              Directionality(
                textDirection: TextDirection.ltr,
                child: PageView.builder(
                  controller: _pageController,
                  // RTL Mushaf: swipe right = previous page (reverse: true flips it)
                  reverse: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _mushaafPages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                      _showNav = true; // briefly show nav on page change
                    });
                  },
                  itemBuilder: (context, index) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: QuranPageWidget(
                        key: ValueKey(
                          '${widget.surah.number}_${_mushaafPages[index].mushaafPageNumber}_${themeProvider.quranFontSize}',
                        ),
                        surah: widget.surah,
                        page: _mushaafPages[index],
                        fontSize: themeProvider.quranFontSize,
                        availableHeight: availableHeight -
                            (isLandscape ? 4.h : 8.h),
                      ),
                    );
                  },
                ),
              ),

              // ── Floating navigation overlay ─────────────────────────
              Positioned.fill(
                child: IgnorePointer(
                  // Let taps reach the PageView; only the buttons are interactive
                  ignoring: false,
                  child: FloatingPageNavigation(
                    visible: _showNav,
                    currentPage: _pageIndex + 1,
                    totalPages: _mushaafPages.length,
                    onNext: _mushaafPages.length > 1 ? _goNext : null,
                    onPrevious: _mushaafPages.length > 1 ? _goPrevious : null,
                    onHide: () => setState(() => _showNav = false),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────

String _toArabicNumber(num value) {
  const w = '0123456789';
  const e = '٠١٢٣٤٥٦٧٨٩';
  return value.toString().split('').map((c) {
    final i = w.indexOf(c);
    return i == -1 ? c : e[i];
  }).join();
}
