import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

class NameCard extends StatelessWidget {
  final AsmaName name;

  const NameCard({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showNameDetails(context, name),
        child: Container(
          padding:  EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.18),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding:  EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      _toArabicNumber(name.number),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.secondaryColorDark,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.star_rounded,
                    size: 20.sp,
                    color: AppTheme.secondaryColorDark,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                name.nameArabic,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  height: 1.35.h,
                ),
              ),
              const Spacer(),
              Text(
                'اضغط للتأمل',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.56),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNameDetails(BuildContext context, AsmaName name) {
    final explanation = name.explanation;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding:  EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 28.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name.nameArabic,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 SizedBox(height: 12.h),
                Text(
                  explanation == null || explanation.trim().isEmpty
                      ? 'اسم من أسماء الله الحسنى.'
                      : explanation,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.7.h),
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
