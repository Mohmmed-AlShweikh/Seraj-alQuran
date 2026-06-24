import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

class SurahListTile extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const SurahListTile({required this.surah, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape = context.isLandscape;

    final revelation = _arabicRevelation(surah.revelation);

    return Card(
      elevation: 2,

      margin: EdgeInsets.symmetric(vertical: isLandscape ? 3.h : 6.h),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),

      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),

        onTap: onTap,

        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? 4.w : 8.w,

            vertical: isLandscape ? 6.h : 10.h,
          ),

          child: Row(
            children: [
              CircleAvatar(
                radius: isLandscape ? 16.r : 22.r,

                backgroundColor: AppTheme.primaryColor,

                child: Text(
                  _toArabicNumber(surah.number),

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: isLandscape ? 10.sp : 14.sp,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(width: isLandscape ? 10.w : 14.w),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      surah.nameArabic,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      textDirection: TextDirection.rtl,

                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: isLandscape ? 9.sp : 22.sp,
                        height: 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      '${_toArabicNumber(surah.verseCount)} آية • $revelation',

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      textDirection: TextDirection.rtl,

                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: isLandscape ? 9.sp : 12.sp,

                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 6.w),

              Icon(
                Icons.chevron_left_rounded,

                size: isLandscape ? 22.sp : 28.sp,

                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _arabicRevelation(String value) {
  final normalized = value.toLowerCase();

  if (normalized.contains('med')) {
    return 'مدنية';
  }

  if (normalized.contains('mec')) {
    return 'مكية';
  }

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
