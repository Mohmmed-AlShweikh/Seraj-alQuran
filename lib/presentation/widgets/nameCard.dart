import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:share_plus/share_plus.dart';

class NameCard extends StatelessWidget {
  final AsmaName name;

  const NameCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final landscape = context.isLandscape;

    return Material(
      color: theme.cardTheme.color,
      borderRadius: BorderRadius.circular(14.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showNameDetails(context, name),
        child: Container(
          padding: EdgeInsets.all(landscape ? 8.w : 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: landscape ? 5.w : 8.w,
                      vertical: landscape ? 2.h : 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      _toArabicNumber(name.number),
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: landscape ? 9.sp : 12.sp,
                        color: AppTheme.secondaryColorDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: landscape ? 12.sp : 16.sp,
                    color: AppTheme.secondaryColor.withValues(alpha: 0.6),
                  ),
                ],
              ),
              Text(
                name.nameArabic,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: landscape ? 13.sp : 19.sp,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              Text(
                name.meaning,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: landscape ? 8.sp : 11.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNameDetails(BuildContext context, AsmaName name) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _toArabicNumber(name.number),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  name.nameArabic,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  name.meaning,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 14.h),
                if (name.explanation != null && name.explanation!.trim().isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      name.explanation!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.75),
                    ),
                  ),
                SizedBox(height: 16.h),
                OutlinedButton.icon(
                  onPressed: () async {
                    final text = 'الله ${name.nameArabic}\n${name.meaning}';
                    await Share.share(text);
                  },
                  icon: const Icon(Icons.share_rounded),
                  label: const Text('مشاركة الاسم'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _toArabicNumber(num value) {
  const western = '0123456789';
  const eastern = '٠١٢٣٤٥٦٧٨٩';
  return value.toString().split('').map((char) {
    final index = western.indexOf(char);
    return index == -1 ? char : eastern[index];
  }).join();
}
