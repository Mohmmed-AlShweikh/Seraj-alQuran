import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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
      _count += 1;
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('التسبيح'), centerTitle: true),
        body: Padding(
          padding:  EdgeInsets.all(24.w),
          child: Column(
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
              const SizedBox(height: 16),
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
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 250.w,
                  height: 250.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 250.w,
                        height: 250.h,
                        child: CircularProgressIndicator(
                          value: progress == 0 && _count > 0 ? 1 : progress,
                          strokeWidth: 12,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _toArabicNumber(_count),
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          Text(
                            'من ${_toArabicNumber(_target)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (rounds > 0)
                            Text(
                              'أتممت ${_toArabicNumber(rounds)} مرة',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: _increment,
                style: FilledButton.styleFrom(
                  minimumSize:  Size.fromHeight(64.h),
                  shape: const CircleBorder(),
                ),
                child:  Icon(Icons.add, size: 36.sp),
              ),
               SizedBox(height: 16.h),
              OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة العد'),
              ),
            ],
          ),
        ),
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
