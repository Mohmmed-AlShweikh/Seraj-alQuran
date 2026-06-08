import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  static const _presets = ['سبحان الله', 'الحمد لله', 'الله أكبر', 'لا إله إلا الله'];

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
    final progress = (_count / _target).clamp(0.0, 1.0);
    return Scaffold(
      appBar: AppBar(title: const Text('التسبيح'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _text,
              decoration: const InputDecoration(labelText: 'الذكر'),
              items: _presets
                  .map((preset) => DropdownMenuItem(value: preset, child: Text(preset)))
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
                ButtonSegment(value: 33, label: Text('33')),
                ButtonSegment(value: 99, label: Text('99')),
                ButtonSegment(value: 100, label: Text('100')),
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
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_count',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text('/ $_target', style: Theme.of(context).textTheme.titleMedium),
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
                minimumSize: const Size.fromHeight(64),
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.add, size: 36),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
