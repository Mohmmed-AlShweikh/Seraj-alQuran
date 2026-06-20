import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;

  const SurahDetailScreen({required this.surah, super.key});

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
    _pageController = PageController();
    _pages = _buildPages(widget.surah.verses);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.surah.nameArabic), centerTitle: true),
        body: SafeArea(
          child: Column(
            children: [
              _SurahHeader(surah: widget.surah),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  reverse: true,
                  itemCount: _pages.length,
                  onPageChanged: (index) => setState(() => _pageIndex = index),
                  itemBuilder: (context, index) {
                    return _MushafPage(
                      surah: widget.surah,
                      verses: _pages[index],
                      pageNumber: index + 1,
                      totalPages: _pages.length,
                    );
                  },
                ),
              ),
              Padding(
                padding:  EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 14.h),
                child: Row(
                  children: [
                    IconButton.filledTonal(
                      tooltip: 'الصفحة السابقة',
                      onPressed: _pageIndex == 0
                          ? null
                          : () => _pageController.previousPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            ),
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                    Expanded(
                      child: Text(
                        'صفحة ${_toArabicNumber(_pageIndex + 1)} من ${_toArabicNumber(_pages.length)}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'الصفحة التالية',
                      onPressed: _pageIndex == _pages.length - 1
                          ? null
                          : () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            ),
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  final Surah surah;

  const _SurahHeader({required this.surah});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final revelation = _arabicRevelation(surah.revelation);

    return Container(
      width: double.infinity,
      margin:  EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 10.h),
      padding:  EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          Text(
            surah.nameArabic,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoPill(
                icon: Icons.format_list_numbered_rtl_rounded,
                label: 'عدد الآيات',
                value: _toArabicNumber(surah.verseCount),
              ),
              _InfoPill(
                icon: Icons.location_city_rounded,
                label: 'النزول',
                value: revelation,
              ),
              _InfoPill(
                icon: Icons.category_rounded,
                label: 'النوع',
                value: revelation,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryColor),
          const SizedBox(width: 6),
          Text('$label: ', style: theme.textTheme.labelMedium),
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppTheme.primaryColor,
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
      margin:  EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      padding:  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (surah.number != 9 && pageNumber == 1) ...[
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
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
                  height: 2.15.h,
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
             SizedBox(height: 18.h),
            Text(
              '${_toArabicNumber(pageNumber)} / ${_toArabicNumber(totalPages)}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.52),
              ),
            ),
          ],
        ),
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

String _arabicRevelation(String value) {
  final normalized = value.toLowerCase();
  if (normalized.contains('med')) return 'مدنية';
  if (normalized.contains('mec')) return 'مكية';
  return value;
}

String _toArabicNumber(num value) {
  const western = '0123456789';
  const eastern = '٠١٢٣٤٥٦٧٨٩';
  return value.toString().split('').map((char) {
    final index = western.indexOf(char);
    return index == -1 ? char : eastern[index];
  }).join();
}
