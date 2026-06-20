import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

class DuaCard extends StatelessWidget {
  final Dua dua;

  const DuaCard({required this.dua});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:  EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding:  EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              dua.text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(height: 1.9.h),
            ),
            if (dua.reference != null) ...[
               SizedBox(height: 12.h),
              Text(
                dua.reference!,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}