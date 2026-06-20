import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

class RoqiaCard extends StatefulWidget {
  final Dhikr dhikr;

  const RoqiaCard({required this.dhikr});

  @override
  State<RoqiaCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<RoqiaCard> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
 
    return Card(
      margin:  EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding:  EdgeInsets.all(16.w),
      
         child:   Text(
              widget.dhikr.text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(height: 1.9.sp),
            )
            ),
         
      
      );
  
  }
}
