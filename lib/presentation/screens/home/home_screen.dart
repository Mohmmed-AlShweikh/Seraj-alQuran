import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/presentation/screens/adhkar/adhkar_screen.dart';
import 'package:seraj_quran/presentation/screens/asma_ul_husna/asma_ul_husna_screen.dart';
import 'package:seraj_quran/presentation/screens/duas/duas_screen.dart';
import 'package:seraj_quran/presentation/screens/roqia/roqia_screen.dart';
import 'package:seraj_quran/presentation/screens/quran/quran_screen.dart';
import 'package:seraj_quran/presentation/screens/settings/settings_screen.dart';
import 'package:seraj_quran/presentation/screens/tasbih/tasbih_screen.dart';
import 'package:hijri/hijri_calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سراج القرآن'),
          actions: [
            IconButton(
              tooltip: 'الإعدادات',
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => _openPage(context, const SettingsScreen()),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            children: [
              _Header(theme: theme),
              const SizedBox(height: 20),
              _Section(
                title: 'القرآن الكريم',
                subtitle: 'قراءة وتصفح السور',
                items: [
                  _HomeAction(
                    title: 'المصحف',
                    subtitle: 'افتح قائمة السور',
                    icon: Icons.menu_book_rounded,
                    color: AppTheme.primaryColor,
                    page: const QuranScreen(),
                  ),
                  _HomeAction(
                    title: 'الرقية الشرعية',
                    subtitle: 'أدعية الرقية الشرعية',
                    icon: Icons.auto_stories,
                    color: AppTheme.primaryColor,
                    page: const RoqiaScreen(),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _Section(
                title: 'الأذكار والأدعية',
                subtitle: 'وردك اليومي في مكان واحد',
                items: [
                  _HomeAction(
                    title: 'الأذكار',
                    subtitle: 'أذكار الصباح والمساء',
                    icon: Icons.wb_twilight_rounded,
                    color: AppTheme.primaryColor,
                    page: const AdhkarScreen(),
                  ),
                  _HomeAction(
                    title: 'الأدعية',
                    subtitle: 'أدعية مختارة ومنظمة',
                    icon: Icons.pan_tool_alt_rounded,
                    color: AppTheme.primaryColor,
                    page: const DuasScreen(),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _Section(
                title: 'الذكر والتعلم',
                subtitle: 'أدوات بسيطة للعبادة اليومية',
                items: [
                  _HomeAction(
                    title: 'أسماء الله الحسنى',
                    subtitle: 'تأمل الأسماء والمعاني',
                    icon: Icons.auto_awesome_rounded,
                    color: AppTheme.primaryColor,
                    page: const AsmaUlHusnaScreen(),
                  ),
                  _HomeAction(
                    title: 'التسبيح',
                    subtitle: 'عداد تسبيح سهل وسريع',
                    icon: Icons.touch_app_rounded,
                    color: AppTheme.primaryColor,
                    page: const TasbihScreen(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class _Header extends StatelessWidget {
  final ThemeData theme;

  const _Header({required this.theme});

  @override
  Widget build(BuildContext context) {
    final hijri = HijriCalendar.now();

    final weekDay = [
      '',
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];

    final months = [
      '',
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الآخر',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة',
    ];

    final dateText =
        '${weekDay[hijri.weekDay()]}, ${hijri.hDay} ${months[hijri.hMonth]} ${hijri.hYear} هـ';
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.light_mode_rounded,
              color: theme.colorScheme.onPrimary,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أهلاً بك', style: theme.textTheme.headlineSmall),

                const SizedBox(height: 4),

                Text(
                  dateText,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'اختر القسم الذي تريد الانتقال إليه.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<_HomeAction> items;

  const _Section({
    required this.title,
    required this.subtitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 560;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 2 : 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 92,
              ),
              itemBuilder: (context, index) => items[index],
            );
          },
        ),
      ],
    );
  }
}

class _HomeAction extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget page;

  const _HomeAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => HomeScreen._openPage(context, page),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              Container(
                width: 46.w,
                height: 46.h,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: color, size: 27.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.62,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_left_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.44),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
