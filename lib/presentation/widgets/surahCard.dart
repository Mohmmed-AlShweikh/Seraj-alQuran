import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

class SurahListTile extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const SurahListTile({required this.surah, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final revelation = _arabicRevelation(surah.revelation);

    return Card(
      margin:  EdgeInsets.symmetric(vertical: 6.h),
      child: ListTile(
        onTap: onTap,
        contentPadding:  EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 10.h,
        ),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          child: Text(_toArabicNumber(surah.number)),
        ),
        title: Text(
          surah.nameArabic,
          style: theme.textTheme.titleLarge,
          textDirection: TextDirection.rtl,
        ),
        subtitle: Text(
          '${_toArabicNumber(surah.verseCount)} آية • $revelation',
          textDirection: TextDirection.rtl,
        ),
        trailing: const Icon(Icons.chevron_left_rounded),
      ),
    );
  }
}

String _arabicRevelation(String value) {
  final normalized = value.toLowerCase();
  if (normalized.contains('med')) return 'مدنية';
  if (normalized.contains('mec')) return 'مكية';
  return value;
}

String _toArabicNumber(num value) {
  const western = '0123456789';
  const eastern = '٠١٢٣٤٥٦٧٨٩';
  return value.toString().split('').map((char) {
    final index = western.indexOf(char);
    return index == -1 ? char : eastern[index];
  }).join();
}
