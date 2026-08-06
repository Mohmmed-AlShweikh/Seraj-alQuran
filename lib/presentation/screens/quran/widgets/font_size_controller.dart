import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';
import 'package:seraj_quran/presentation/providers/theme/theme_provider.dart';

/// Bottom-sheet content for adjusting the Quran font size.
/// Show via [FontSizeController.show].
class FontSizeController extends StatelessWidget {
  final ThemeProvider themeProvider;

  const FontSizeController({required this.themeProvider, super.key});

  static void show(BuildContext context, ThemeProvider themeProvider) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => FontSizeController(themeProvider: themeProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: AppConstants.arabicFontName,
                      fontSize: themeProvider.quranFontSize,
                      height: 1.8,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      'أ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
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
                    Text(
                      'أ',
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
