import 'package:flutter/material.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:share_plus/share_plus.dart';

class NameCard extends StatelessWidget {
  final AsmaName name;

  const NameCard({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    final isDesktop = width >= 1024;

    return Material(
      color: theme.cardTheme.color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showNameDetails(context, name),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
  children: [
    Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            _toArabicNumber(name.number),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const Spacer(),
        Icon(
          Icons.auto_awesome_rounded,
          color: AppTheme.secondaryColor,
          size: 16,
        ),
      ],
    ),

    const Spacer(),

    Flexible(
      flex: 3,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          name.nameArabic,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),

    const SizedBox(height: 8),

    Flexible(
      child: Text(
        name.meaning,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 11,
        ),
      ),
    ),
  ],
)
        ),
      ),
    );
  }

  void _showNameDetails(BuildContext context, AsmaName name) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name.nameArabic,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(name.meaning),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  await Share.share(
                    'الله ${name.nameArabic}\n${name.meaning}',
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('مشاركة الاسم'),
              ),
            ],
          ),
        );
      },
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