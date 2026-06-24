import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
import 'package:seraj_quran/presentation/providers/favorites/favorites_provider.dart';
import 'package:share_plus/share_plus.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المفضلة'),
          centerTitle: true,
        ),
        body: Consumer<FavoritesProvider>(
          builder: (context, fav, _) {
            final items = fav.allFavorites;

            if (items.isEmpty) {
              return _EmptyFavorites();
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _FavoriteItem(
                    item: item,
                    onRemove: () => fav.remove(item['id'] as String),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        final isLandscape = context.isLandscape;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isLandscape ? 40.w : 80.w,
            height: isLandscape ? 40.w : 80.w,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_outline_rounded,
              size: isLandscape ? 28.sp : 38.sp,
              color: Colors.red.shade300,
            ),
          ),
          SizedBox(height: isLandscape ? 10.h : 20.h),
          Text(
            'لا توجد مفضلات بعد',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: isLandscape ? 6.h : 12.h),
          Text(
            'أضف الأذكار والأدعية التي تحبها\nبالضغط على أيقونة القلب',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isLandscape ? 10.sp : 14.sp,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;

  const _FavoriteItem({required this.item, required this.onRemove});

  String get _typeLabel {
    switch (item['type'] as String?) {
      case 'dhikr':
        return 'ذكر';
      case 'dua':
        return 'دعاء';
      default:
        return '';
    }
  }

  Color get _typeColor {
    switch (item['type'] as String?) {
      case 'dhikr':
        return AppTheme.primaryColor;
      case 'dua':
        return const Color(0xFF7B1FA2);
      default:
        return AppTheme.secondaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = item['text'] as String? ?? '';
    final reference = item['reference'] as String?;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 3.h,
            decoration: BoxDecoration(
              color: _typeColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.r),
                topLeft: Radius.circular(16.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: _typeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        _typeLabel,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: _typeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.favorite_rounded,
                      size: 14.sp,
                      color: Colors.red.shade300,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  text,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16.sp,
                    height: 1.75,
                  ),
                ),
                if (reference != null && reference.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Text(
                    reference,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11.sp,
                      color: _typeColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      tooltip: 'مشاركة',
                      onPressed: () async {
                        final shareText = reference != null && reference.isNotEmpty
                            ? '$text\n\n— $reference'
                            : text;
                        await Share.share(shareText);
                      },
                      icon: Icon(
                        Icons.share_rounded,
                        size: 20.sp,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.all(6.w),
                        minimumSize: Size(34.w, 34.w),
                      ),
                    ),
                    IconButton(
                      tooltip: 'إزالة من المفضلة',
                      onPressed: onRemove,
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 20.sp,
                        color: Colors.red.shade400,
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
