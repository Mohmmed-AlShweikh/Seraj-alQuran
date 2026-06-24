import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/favorites/favorites_provider.dart';
import 'package:share_plus/share_plus.dart';

class DuaCard extends StatelessWidget {
  final Dua dua;

  const DuaCard({super.key, required this.dua});

  Future<void> _share() async {
    final text = dua.reference != null
        ? '${dua.text}\n\n— ${dua.reference}'
        : dua.text;
    await Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.grey.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black).withValues(alpha: 0.05),
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
              color: const Color(0xFF7B1FA2).withValues(alpha: 0.7),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.r),
                topLeft: Radius.circular(16.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  dua.text,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 19.sp,
                    height: 1.85,
                  ),
                ),
                if (dua.reference != null) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B1FA2).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      dua.reference!,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: const Color(0xFF7B1FA2),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<FavoritesProvider>(
                      builder: (context, fav, _) {
                        final isFav = fav.isFavorite(dua.id);
                        return IconButton(
                          tooltip: isFav ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                          onPressed: () => fav.toggle(
                            dua.id,
                            dua.text,
                            'dua',
                            reference: dua.reference,
                          ),
                          icon: Icon(
                            isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                            color: isFav
                                ? Colors.red.shade400
                                : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            size: 20.sp,
                          ),
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.all(6.w),
                            minimumSize: Size(34.w, 34.w),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      tooltip: 'مشاركة',
                      onPressed: _share,
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
