import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';
import 'package:seraj_quran/core/data/mushaf_page_data.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/screens/quran/widgets/overflow_detector.dart';

/// Renders a single Mushaf page for [surah], showing exactly the verses
/// described by [page] (a [MushaafPage] from the page-metadata layer).
///
/// By default the content is NOT scrollable (NeverScrollableScrollPhysics).
/// If the current [fontSize] makes the content overflow the available area,
/// [OverflowDetector] enables vertical scrolling automatically.
class QuranPageWidget extends StatelessWidget {
  final Surah surah;
  final MushaafPage page;
  final double fontSize;
  final double availableHeight;

  const QuranPageWidget({
    required this.surah,
    required this.page,
    required this.fontSize,
    required this.availableHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape = context.isLandscape;

    final verses = surah.verses
        .where((v) =>
            v.ayahNumber >= page.startAyah && v.ayahNumber <= page.endAyah)
        .toList();

    final showBasmala = surah.number != 9 && page.startAyah == 1;

    final hPad = isLandscape ? 12.w : 10.w;
    final vPad = isLandscape ? 6.h : 10.h;

    return QuranPageLayout(
      availableHeight: availableHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showBasmala) ...[
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
              SizedBox(height: 6.h),
              Divider(
                color: AppTheme.primaryColor.withValues(alpha: 0.15),
                height: 1,
              ),
              SizedBox(height: 10.h),
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

/// Wraps [child] so it fills the available height without scrolling by
/// default. If the content overflows [availableHeight], it automatically
/// enables vertical scrolling for that page only (per requirement §6 & §8).
class QuranPageLayout extends StatelessWidget {
  final Widget child;
  final double availableHeight;

  const QuranPageLayout({
    required this.child,
    required this.availableHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: availableHeight,
      child: OverflowDetector(
        maxHeight: availableHeight,
        child: child,
      ),
    );
  }
}

String _toArabicNumber(num value) {
  const w = '0123456789';
  const e = '٠١٢٣٤٥٦٧٨٩';
  return value.toString().split('').map((c) {
    final i = w.indexOf(c);
    return i == -1 ? c : e[i];
  }).join();
}
