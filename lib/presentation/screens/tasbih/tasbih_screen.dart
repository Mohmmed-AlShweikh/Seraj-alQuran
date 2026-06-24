import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  static const _presets = [
    'سبحان الله',
    'الحمد لله',
    'الله أكبر',
    'لا إله إلا الله',
    'سبحان الله وبحمده',
    'سبحان الله العظيم',
    'اللهم صل على النبي',
    'لا حول ولا قوة إلا بالله',
  ];

  String _text = _presets.first;
  int _target = 33;
  int _count = 0;
  int _totalRounds = 0;

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  bool get _isComplete => _count >= _target;

  Future<void> _save() async {
    final repo = context.read<AppRepositoryProvider>().tasbihRepository;
    await repo.updateCounter(
      TasbihCounter(
        id: 'main',
        text: _text,
        targetCount: _target,
        currentCount: _count,
        createdAt: DateTime.now(),
        completedAt: _isComplete ? DateTime.now() : null,
      ),
    );
  }

  void _increment() {
    if (_isComplete) return;
    HapticFeedback.lightImpact();
    _animController.forward().then((_) => _animController.reverse());

    setState(() {
      _count++;
      if (_count >= _target) {
        HapticFeedback.mediumImpact();
      }
    });
    _save();
  }

  void _reset() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_isComplete) _totalRounds++;
      _count = 0;
    });
    _save();
  }

  void _fullReset() {
    setState(() {
      _count = 0;
      _totalRounds = 0;
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = context.isLandscape;
    final size = MediaQuery.of(context).size;
    final circleSize = isLandscape ? size.height * 0.42 : size.width * 0.60;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: isLandscape
            ? null
            : AppBar(
                title: const Text('عداد التسبيح'),
                centerTitle: true,
              ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(isLandscape ? 10.w : 16.w),
            child: isLandscape
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 2, child: _buildControls()),
                      SizedBox(width: 16.w),
                      Expanded(
                        flex: 3,
                        child: _buildCounter(circleSize, true),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildControls(),
                      const Spacer(),
                      _buildCounter(circleSize, false),
                      const Spacer(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          value: _text,
          decoration: InputDecoration(
            labelText: 'اختر الذكر',
            prefixIcon: const Icon(Icons.text_fields_rounded),
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          ),
          items: _presets
              .map((preset) => DropdownMenuItem(value: preset, child: Text(preset)))
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _text = value;
              _count = 0;
              _totalRounds = 0;
            });
            _save();
          },
        ),
        SizedBox(height: 12.h),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 33, label: Text('٣٣')),
            ButtonSegment(value: 99, label: Text('٩٩')),
            ButtonSegment(value: 100, label: Text('١٠٠')),
          ],
          selected: {_target},
          onSelectionChanged: (value) {
            setState(() {
              _target = value.first;
              _count = 0;
              _totalRounds = 0;
            });
            _save();
          },
        ),
        if (_totalRounds > 0) ...[
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.loop_rounded, size: 16.sp, color: AppTheme.secondaryColor),
                SizedBox(width: 6.w),
                Text(
                  'أتممت ${_toArabicNumber(_totalRounds)} دورة',
                  style: TextStyle(
                    color: AppTheme.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCounter(double circleSize, bool isLandscape) {
    final progress = _target > 0 ? (_count % _target) / _target : 0.0;
    final displayProgress = progress == 0 && _count > 0 ? 1.0 : progress;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: circleSize,
          height: circleSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: circleSize,
                height: circleSize,
                child: CircularProgressIndicator(
                  value: displayProgress,
                  strokeWidth: isLandscape ? 8 : 14,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isComplete ? AppTheme.secondaryColor : AppTheme.primaryColor,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _toArabicNumber(_count),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: isLandscape ? 28.sp : 52.sp,
                          color: _isComplete ? AppTheme.secondaryColor : AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'من ${_toArabicNumber(_target)}',
                    style: TextStyle(
                      fontSize: isLandscape ? 11.sp : 16.sp,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _text,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isLandscape ? 9.sp : 13.sp,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: isLandscape ? 10.h : 24.h),
        ScaleTransition(
          scale: _scaleAnim,
          child: GestureDetector(
            onTap: _isComplete ? null : _increment,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isLandscape ? 64.w : 90.w,
              height: isLandscape ? 64.w : 90.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isComplete ? AppTheme.secondaryColor : AppTheme.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: (_isComplete ? AppTheme.secondaryColor : AppTheme.primaryColor)
                        .withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                _isComplete ? Icons.check_rounded : Icons.add_rounded,
                color: Colors.white,
                size: isLandscape ? 28.sp : 38.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: isLandscape ? 8.h : 14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: _reset,
              icon: Icon(Icons.refresh_rounded, size: 16.sp),
              label: Text(
                _isComplete ? 'جولة جديدة' : 'إعادة',
                style: TextStyle(fontSize: isLandscape ? 10.sp : 13.sp),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isLandscape ? 10.w : 14.w,
                  vertical: isLandscape ? 6.h : 8.h,
                ),
              ),
            ),
            if (_totalRounds > 0) ...[
              SizedBox(width: 8.w),
              TextButton.icon(
                onPressed: _fullReset,
                icon: Icon(Icons.restart_alt_rounded, size: 16.sp),
                label: Text(
                  'تصفير الكل',
                  style: TextStyle(fontSize: isLandscape ? 10.sp : 13.sp),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade400,
                  padding: EdgeInsets.symmetric(
                    horizontal: isLandscape ? 10.w : 14.w,
                    vertical: isLandscape ? 6.h : 8.h,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
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
