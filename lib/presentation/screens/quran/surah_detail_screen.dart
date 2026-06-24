import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/quran/quran_provider.dart';
import 'package:seraj_quran/presentation/providers/theme/theme_provider.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;
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
  late final List<List<Verse>> _pages;
  int _pageIndex = 0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    _pageIndex = widget.initialPage;
    _pages = _buildPages(widget.surah.verses);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _saveBookmark() async {
    final currentPage = _pages[_pageIndex];
    final lastAyah = currentPage.isEmpty ? 1 : currentPage.last.ayahNumber;

    await context.read<QuranProvider>().saveReadingProgress(
          widget.surah.number,
          lastAyah,
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.surah.nameArabic),
          centerTitle: true,
          actions: [
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) => IconButton(
                icon: const Icon(Icons.text_increase_rounded),
                tooltip: 'حجم الخط',
                onPressed: () => _showFontSizeDialog(context, themeProvider),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_add_outlined),
              tooltip: 'حفظ العلامة',
              onPressed: _saveBookmark,
            ),
          ],
        ),
        body: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return Stack(
              children: [
                Column(
                  children: [
                    if (!context.isLandscape)
                      _CompactSurahHeader(surah: widget.surah),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showControls = !_showControls),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: PageView.builder(
                            controller: _pageController,
                            reverse: true,
                            itemCount: _pages.length,
                            onPageChanged: (index) {
                              setState(() => _pageIndex = index);
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 80.h),
                                child: _MushafPage(
                                  surah: widget.surah,
                                  verses: _pages[index],
                                  pageNumber: index + 1,
                                  totalPages: _pages.length,
                                  fontSize: themeProvider.quranFontSize,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  bottom: _showControls ? 14.h : -80.h,
                  left: 16.w,
                  right: 16.w,
                  child: _ReaderControls(
                    pageIndex: _pageIndex,
                    totalPages: _pages.length,
                    onNext: () {
                      if (_pageIndex < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    onPrevious: () {
                      if (_pageIndex > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context, ThemeProvider themeProvider) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setStateSheet) {
              return Padding(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 32.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'حجم الخط',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
                      ),
                      child: Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: AppConstants.arabicFontName,
                          fontSize: themeProvider.quranFontSize,
                          height: 1.7,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        const Text('أ', style: TextStyle(fontSize: 12)),
                        Expanded(
                          child: Slider(
                            value: themeProvider.quranFontSize,
                            min: AppConstants.minQuranFontSize,
                            max: AppConstants.maxQuranFontSize,
                            divisions: 8,
                            activeColor: AppTheme.primaryColor,
                            onChanged: (val) {
                              setStateSheet(() {});
                              themeProvider.setQuranFontSize(val);
                            },
                          ),
                        ),
                        const Text('أ', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CompactSurahHeader extends StatelessWidget {
  final Surah surah;

  const _CompactSurahHeader({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.menu_book_rounded, size: 20.sp, color: AppTheme.primaryColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              surah.nameArabic,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '${_toArabicNumber(surah.verseCount)} آية',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.secondaryColorDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MushafPage extends StatelessWidget {
  final Surah surah;
  final List<Verse> verses;
  final int pageNumber;
  final int totalPages;
  final double fontSize;

  const _MushafPage({
    required this.surah,
    required this.verses,
    required this.pageNumber,
    required this.totalPages,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape = context.isLandscape;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 20.w : 20.w,
        vertical: isLandscape ? 12.h : 20.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (surah.number != 9 && pageNumber == 1) ...[
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppConstants.arabicFontName,
                  fontSize: (fontSize * 1.05).clamp(18.0, 36.0),
                  color: AppTheme.primaryColor,
                  height: 2.0,
                ),
              ),
              SizedBox(height: 10.h),
              Divider(color: AppTheme.primaryColor.withValues(alpha: 0.15), height: 1),
              SizedBox(height: 16.h),
            ],
            RichText(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: AppConstants.arabicFontName,
                  fontSize: fontSize,
                  height: isLandscape ? 1.9 : 2.2,
                  color: theme.colorScheme.onSurface,
                ),
                children: [
                  for (final verse in verses) ...[
                    TextSpan(text: verse.text),
                    TextSpan(
                      text: ' ﴿${_toArabicNumber(verse.ayahNumber)}﴾ ',
                      style: TextStyle(
                        fontFamily: AppConstants.arabicFontName,
                        fontSize: (fontSize * 0.75).clamp(12.0, 24.0),
                        color: AppTheme.secondaryColorDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderControls extends StatelessWidget {
  final int pageIndex;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _ReaderControls({
    required this.pageIndex,
    required this.totalPages,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.darkSurfaceColor.withValues(alpha: 0.97)
            : Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: pageIndex > 0 ? onPrevious : null,
            icon: const Icon(Icons.chevron_left_rounded),
            color: AppTheme.primaryColor,
            disabledColor: Colors.grey.withValues(alpha: 0.3),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_toArabicNumber(pageIndex + 1)} / ${_toArabicNumber(totalPages)}',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'صفحة',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: pageIndex < totalPages - 1 ? onNext : null,
            icon: const Icon(Icons.chevron_right_rounded),
            color: AppTheme.primaryColor,
            disabledColor: Colors.grey.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

List<List<Verse>> _buildPages(List<Verse> verses) {
  const maxCharsPerPage = 900;
  final pages = <List<Verse>>[];
  var current = <Verse>[];
  var currentLength = 0;

  for (final verse in verses) {
    final nextLength = currentLength + verse.text.length + 8;
    if (current.isNotEmpty && nextLength > maxCharsPerPage) {
      pages.add(current);
      current = <Verse>[];
      currentLength = 0;
    }
    current.add(verse);
    currentLength += verse.text.length + 8;
  }

  if (current.isNotEmpty) pages.add(current);
  return pages.isEmpty ? [const <Verse>[]] : pages;
}

String _toArabicNumber(num value) {
  const western = '0123456789';
  const eastern = '٠١٢٣٤٥٦٧٨٩';
  return value.toString().split('').map((char) {
    final index = western.indexOf(char);
    return index == -1 ? char : eastern[index];
  }).join();
}
