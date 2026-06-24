import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:share_plus/share_plus.dart';

class RoqiaCard extends StatelessWidget {
  final Dhikr dhikr;

  const RoqiaCard({super.key, required this.dhikr});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 3.h,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.r),
                topLeft: Radius.circular(16.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  dhikr.text,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 18.sp,
                    height: 1.9,
                  ),
                ),
                if (dhikr.reference != null && dhikr.reference!.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    dhikr.reference!,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: 'مشاركة',
                    onPressed: () async {
                      final text = dhikr.reference != null && dhikr.reference!.isNotEmpty
                          ? '${dhikr.text}\n\n— ${dhikr.reference}'
                          : dhikr.text;
                      await Share.share(text);
                    },
                    icon: Icon(
                      Icons.share_rounded,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      size: 20.sp,
                    ),
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.all(6.w),
                      minimumSize: Size(34.w, 34.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
