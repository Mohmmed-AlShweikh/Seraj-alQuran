import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

class DhikrCard extends StatefulWidget {
  final Dhikr dhikr;

  const DhikrCard({required this.dhikr});

  @override
  State<DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<DhikrCard> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    final target = widget.dhikr.count <= 0 ? 1 : widget.dhikr.count;
    return Card(
      margin:  EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding:  EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.dhikr.text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(height: 1.9.h),
            ),
            if (widget.dhikr.reference != null) ...[
               SizedBox(height: 12.h),
              Text(
                widget.dhikr.reference!,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
             SizedBox(height: 12.h),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () =>
                      setState(() => _count = (_count + 1).clamp(0, target)),
                  icon: const Icon(Icons.add),
                  label: Text('$_count / $target'),
                ),
                 SizedBox(width: 8.h),
                IconButton.outlined(
                  tooltip: 'إعادة العد',
                  onPressed: () => setState(() => _count = 0),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
