import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  static const _presets = [
    'سبحان الله',
    'الحمد لله',
    'الله أكبر',
    'لا إله إلا الله',
  ];

  String _text = _presets.first;
  int _target = 33;
  int _count = 0;

  Future<void> _save() async {
    final repo = context.read<AppRepositoryProvider>().tasbihRepository;

    await repo.updateCounter(
      TasbihCounter(
        id: 'main',
        text: _text,
        targetCount: _target,
        currentCount: _count,
        createdAt: DateTime.now(),
        completedAt: _count >= _target ? DateTime.now() : null,
      ),
    );
  }

  void _increment() {
    setState(() {
      _count++;
    });
    _save();
  }

  void _reset() {
    setState(() {
      _count = 0;
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_count % _target) / _target;

    final rounds = _count ~/ _target;

    final isLandscape = context.isLandscape;

    final size = MediaQuery.of(context).size;

    final circleSize = isLandscape ? size.height * 0.42 : size.width * 0.62;

    final numberSize = isLandscape ? 30.sp : 55.sp;

    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        appBar: isLandscape
            ? null
            : AppBar(title: const Text('التسبيح'), centerTitle: true),

        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(isLandscape ? 10.w : 20.w),

            child: isLandscape
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Expanded(flex: 2, child: _buildControls()),

                      SizedBox(width: 15.w),

                      Expanded(
                        flex: 3,

                        child: _buildCounter(
                          progress,
                          rounds,
                          circleSize,
                          numberSize,
                          true,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [
                      _buildControls(),

                      const Spacer(),

                      _buildCounter(
                        progress,
                        rounds,
                        circleSize,
                        numberSize,
                        false,
                      ),

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

      children: [
        DropdownButtonFormField<String>(
          initialValue: _text,

          decoration: const InputDecoration(labelText: 'الذكر'),

          items: _presets
              .map(
                (preset) =>
                    DropdownMenuItem(value: preset, child: Text(preset)),
              )
              .toList(),

          onChanged: (value) {
            if (value == null) return;

            setState(() {
              _text = value;
              _count = 0;
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
            });

            _save();
          },
        ),
      ],
    );
  }

  Widget _buildCounter(
    double progress,
    int rounds,
    double circleSize,
    double numberSize,
    bool landscape,
  ) {
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
                  value: progress == 0 && _count > 0 ? 1 : progress,

                  strokeWidth: landscape ? 7 : 12,
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Text(
                    _toArabicNumber(_count),

                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(fontSize: numberSize),
                  ),

                  Text(
                    'من ${_toArabicNumber(_target)}',

                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: landscape ? 12.sp : null,
                    ),
                  ),

                  if (rounds > 0)
                    Text(
                      'أتممت ${_toArabicNumber(rounds)} مرة',

                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: landscape ? 10.sp : null,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: landscape ? 8.h : 25.h),

        FilledButton(
          onPressed: _increment,

          style: FilledButton.styleFrom(
            minimumSize: Size(landscape ? 45.w : 90.w, landscape ? 45.h : 90.h),

            shape: const CircleBorder(),
          ),

          child: Icon(Icons.add, size: landscape ? 22.sp : 36.sp),
        ),

        SizedBox(height: landscape ? 1.h : 16.h),

        SizedBox(
          height: landscape ? 50.h : null,
          width: landscape ? 120.w : null,

          child: OutlinedButton.icon(
            onPressed: _reset,

            icon: const Icon(Icons.refresh),

            label: const Text('إعادة العد'),
          ),
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
