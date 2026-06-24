import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/quran/quran_provider.dart';

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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم حفظ العلامة')));
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
            IconButton(
              icon: const Icon(Icons.bookmark_add_outlined),
              onPressed: _saveBookmark,
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                context.isLandscape
                    ? SizedBox()
                    : _CompactSurahHeader(surah: widget.surah),

                Expanded(
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
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              bottom: 14.h,
              left: 16.w,
              right: 16.w,
              child: _ReaderControls(
                pageIndex: _pageIndex,
                totalPages: _pages.length,
                onNext: () {
                  if (_pageIndex < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                },
                onPrevious: () {
                  if (_pageIndex > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactSurahHeader extends StatelessWidget {
  final Surah surah;

  const _CompactSurahHeader({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: context.isLandscape ? 18.sp : 24.sp,
            color: AppTheme.primaryColor,
          ),
          SizedBox(width: 10.w),

          Expanded(
            child: Text(
              surah.nameArabic,
              style: TextStyle(
                fontSize: context.isLandscape ? 16.sp : 20.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '${_toArabicNumber(surah.verseCount)} آية',
              style: TextStyle(
                fontSize: context.isLandscape ? 10.sp : 12.sp,
                color: AppTheme.secondaryColor,
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

  const _MushafPage({
    required this.surah,
    required this.verses,
    required this.pageNumber,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.isLandscape ? 14.w : 18.w,
        vertical: context.isLandscape ? 10.h : 18.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (surah.number != 9 && pageNumber == 1) ...[
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: context.isLandscape ? 18.sp : 24.sp,
                  color: AppTheme.primaryColor,
                  height: 1.8,
                ),
              ),
              SizedBox(height: 14.h),
            ],

            RichText(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: context.isLandscape ? 16.sp : 22.sp,
                  height: context.isLandscape ? 1.8 : 2.15,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  for (final verse in verses) ...[
                    TextSpan(text: verse.text),
                    TextSpan(
                      text: ' ﴿${_toArabicNumber(verse.ayahNumber)}﴾ ',
                      style: theme.textTheme.titleLarge?.copyWith(
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left_rounded),
            color: Colors.black.withValues(alpha: 0.6),
          ),
          Expanded(
            child: Center(
              child: Text(
                '${_toArabicNumber(pageIndex + 1)} / ${_toArabicNumber(totalPages)}',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right_rounded),
            color: Colors.black.withValues(alpha: 0.6),
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

  if (current.isNotEmpty) {
    pages.add(current);
  }

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
