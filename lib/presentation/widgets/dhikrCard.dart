import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/favorites/favorites_provider.dart';
import 'package:share_plus/share_plus.dart';

class DhikrCard extends StatefulWidget {
  final Dhikr dhikr;

  const DhikrCard({super.key, required this.dhikr});

  @override
  State<DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<DhikrCard>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  int get _target => widget.dhikr.count <= 0 ? 1 : widget.dhikr.count;
  bool get _isComplete => _count >= _target;

  void _increment() {
    if (_isComplete) return;
    HapticFeedback.lightImpact();
    _animController.forward().then((_) => _animController.reverse());
    setState(() {
      _count = (_count + 1).clamp(0, _target);
    });
  }

  void _reset() {
    setState(() => _count = 0);
  }

  Future<void> _share() async {
    final text = widget.dhikr.reference != null
        ? '${widget.dhikr.text}\n\n— ${widget.dhikr.reference}'
        : widget.dhikr.text;
    await Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = _target > 0 ? _count / _target : 0.0;

    final accentColor = _isComplete ? AppTheme.secondaryColor : AppTheme.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _isComplete
              ? AppTheme.secondaryColor.withValues(alpha: 0.4)
              : theme.dividerTheme.color ?? Colors.grey.withValues(alpha: 0.2),
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
            height: 4.h,
            decoration: BoxDecoration(
              color: _isComplete ? AppTheme.secondaryColor : AppTheme.primaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.r),
                topLeft: Radius.circular(16.r),
              ),
            ),
            child: FractionallySizedBox(
              widthFactor: progress,
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  color: _isComplete ? AppTheme.secondaryColorDark : AppTheme.primaryColorDark,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.r),
                    topLeft: _isComplete ? Radius.circular(16.r) : Radius.zero,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.dhikr.text,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 19.sp,
                    height: 1.85,
                    color: _isComplete
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
                        : theme.colorScheme.onSurface,
                  ),
                ),
                if (widget.dhikr.reference != null) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      widget.dhikr.reference!,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: accentColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 12.h),
                Row(
                  children: [
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: _isComplete
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: AppTheme.secondaryColor,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'اكتمل ✓',
                                    style: TextStyle(
                                      color: AppTheme.secondaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : FilledButton.icon(
                              onPressed: _increment,
                              icon: Icon(Icons.add_rounded, size: 18.sp),
                              label: Text(
                                '${_toArabicNumber(_count)} / ${_toArabicNumber(_target)}',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                    ),
                    SizedBox(width: 6.w),
                    if (_count > 0)
                      IconButton.outlined(
                        tooltip: 'إعادة العد',
                        onPressed: _reset,
                        icon: Icon(Icons.refresh_rounded, size: 18.sp),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.all(6.w),
                          minimumSize: Size(34.w, 34.w),
                        ),
                      ),
                    const Spacer(),
                    Consumer<FavoritesProvider>(
                      builder: (context, fav, _) {
                        final isFav = fav.isFavorite(widget.dhikr.id);
                        return IconButton(
                          tooltip: isFav ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                          onPressed: () => fav.toggle(
                            widget.dhikr.id,
                            widget.dhikr.text,
                            'dhikr',
                            reference: widget.dhikr.reference,
                          ),
                          icon: Icon(
                            isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                            color: isFav ? Colors.red.shade400 : theme.colorScheme.onSurface.withValues(alpha: 0.4),
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

String _toArabicNumber(num value) {
  const western = '0123456789';
  const eastern = '٠١٢٣٤٥٦٧٨٩';
  return value.toString().split('').map((char) {
    final index = western.indexOf(char);
    return index == -1 ? char : eastern[index];
  }).join();
}
