import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
import 'package:seraj_quran/presentation/providers/favorites/favorites_provider.dart';
import 'package:seraj_quran/presentation/providers/quran/quran_provider.dart';
import 'package:seraj_quran/presentation/screens/adhkar/adhkar_screen.dart';
import 'package:seraj_quran/presentation/screens/asma_ul_husna/asma_ul_husna_screen.dart';
import 'package:seraj_quran/presentation/screens/duas/duas_screen.dart';
import 'package:seraj_quran/presentation/screens/favorites/favorites_screen.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/screens/quran/quran_screen.dart';
import 'package:seraj_quran/presentation/screens/quran/surah_detail_screen.dart';
import 'package:seraj_quran/presentation/screens/roqia/roqia_screen.dart';
import 'package:seraj_quran/presentation/screens/settings/settings_screen.dart';
import 'package:seraj_quran/presentation/screens/tasbih/tasbih_screen.dart';
import 'package:hijri/hijri_calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static void openPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
  toolbarHeight: 64,
  centerTitle: true,
  title: Text(
    'سراج القرآن',
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppTheme.primaryColor,
    ),
  ),
  actions: [
    Consumer<FavoritesProvider>(
      builder: (context, fav, _) => Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            color: AppTheme.secondaryColor,
            onPressed: () =>
                openPage(context, const FavoritesScreen()),
          ),
          if (fav.count > 0)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${fav.count}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
    IconButton(
      icon: const Icon(Icons.settings_outlined),
      onPressed: () =>
          openPage(context, const SettingsScreen()),
    ),
  ],
),
        body: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 32.h),
          children: [
            const _HeaderCard(),
            SizedBox(height: 16.h),
            const _ContinueReadingCard(),
            const _QuranSection(),
            SizedBox(height: 16.h),
            const _AdhkarSection(),
            SizedBox(height: 16.h),
            const _LearnSection(),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    final hijri = HijriCalendar.now();
    final months = [
      '',
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة',
    ];
    final dateText = '${hijri.hDay} ${months[hijri.hMonth]} ${hijri.hYear} هـ';

    return Container(
      padding: EdgeInsets.all(context.isLandscape ? 14.w : 22.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D4620), Color(0xFF1B7A3F), Color(0xFF2E9E57)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -18,
            left: -18,
            child: Icon(
              Icons.mosque_rounded,
              size: context.isLandscape ? 70.sp : 140.sp,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            bottom: -12,
            right: -8,
            child: Icon(
              Icons.star_rounded,
              size: context.isLandscape ? 50.sp : 100.sp,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
          if (context.isLandscape)
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'أهلاً بك',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        dateText,
                        style: TextStyle(color: Colors.white60, fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '﴿ وَذَكِّرْ فَإِنَّ الذِّكْرَىٰ تَنفَعُ الْمُؤْمِنِينَ ﴾',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14.sp,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'أهلاً بك في سراج القرآن',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, color: Colors.white60, size: 14),
                    SizedBox(width: 6.w),
                    Text(
                      dateText,
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: Text(
                    '﴿ وَذَكِّرْ فَإِنَّ الذِّكْرَىٰ تَنفَعُ الْمُؤْمِنِينَ ﴾',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      height: 1.7,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  const _ContinueReadingCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (context, quranProvider, _) {
        final progress = quranProvider.readingProgress;
        if (progress == null) return const SizedBox.shrink();

        Surah? bookmarkedSurah;
        try {
          bookmarkedSurah = quranProvider.surahs.firstWhere(
            (s) => s.number == progress.currentSurah,
          );
        } catch (_) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SurahDetailScreen(
                    surah: bookmarkedSurah!,
                    initialPage: progress.currentPage,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.bookmark_rounded, color: Colors.white, size: 22.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'متابعة القراءة',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${bookmarkedSurah.nameArabic} • الآية ${progress.currentAyah}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 16.sp,
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 22.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuranSection extends StatelessWidget {
  const _QuranSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'القرآن الكريم',
          subtitle: 'قراءة وتصفح السور',
          color: AppTheme.primaryColor,
        ),
        if (context.isLandscape)
          Row(
            children: [
              Expanded(
                child: _NavCard(
                  title: 'المصحف الشريف',
                  subtitle: 'تصفح ١١٤ سورة',
                  icon: Icons.menu_book_rounded,
                  gradient: const [Color(0xFF0D4620), Color(0xFF1B7A3F)],
                  page: const QuranScreen(),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _NavCard(
                  title: 'الرقية الشرعية',
                  subtitle: 'آيات وأدعية الرقية',
                  icon: Icons.shield_rounded,
                  gradient: const [Color(0xFF1A4731), Color(0xFF2D7A52)],
                  page: const RoqiaScreen(),
                ),
              ),
            ],
          )
        else ...[
          _NavCard(
            title: 'المصحف الشريف',
            subtitle: 'تصفح ١١٤ سورة كاملة',
            icon: Icons.menu_book_rounded,
            gradient: const [Color(0xFF0D4620), Color(0xFF1B7A3F)],
            page: const QuranScreen(),
          ),
          SizedBox(height: 10.h),
          _NavCard(
            title: 'الرقية الشرعية',
            subtitle: 'آيات وأدعية الرقية الشرعية',
            icon: Icons.shield_rounded,
            gradient: const [Color(0xFF1A4731), Color(0xFF2D7A52)],
            page: const RoqiaScreen(),
          ),
        ],
      ],
    );
  }
}

class _AdhkarSection extends StatelessWidget {
  const _AdhkarSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'الأذكار والأدعية',
          subtitle: 'وردك اليومي في مكان واحد',
          color: Color(0xFF1565C0),
        ),
        if (context.isLandscape)
          Row(
            children: [
              Expanded(
                child: _NavCard(
                  title: 'الأذكار اليومية',
                  subtitle: 'صباح ومساء وبعد الصلاة',
                  icon: Icons.wb_sunny_rounded,
                  gradient: const [Color(0xFF0D47A1), Color(0xFF1976D2)],
                  page: const AdhkarScreen(),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _NavCard(
                  title: 'الأدعية المأثورة',
                  subtitle: 'أدعية قرآنية ونبوية',
                  icon: Icons.volunteer_activism_rounded,
                  gradient: const [Color(0xFF4A148C), Color(0xFF7B1FA2)],
                  page: const DuasScreen(),
                ),
              ),
            ],
          )
        else ...[
          _NavCard(
            title: 'الأذكار اليومية',
            subtitle: 'أذكار الصباح والمساء وبعد الصلاة',
            icon: Icons.wb_sunny_rounded,
            gradient: const [Color(0xFF0D47A1), Color(0xFF1976D2)],
            page: const AdhkarScreen(),
          ),
          SizedBox(height: 10.h),
          _NavCard(
            title: 'الأدعية المأثورة',
            subtitle: 'أدعية قرآنية ونبوية مختارة',
            icon: Icons.volunteer_activism_rounded,
            gradient: const [Color(0xFF4A148C), Color(0xFF7B1FA2)],
            page: const DuasScreen(),
          ),
        ],
      ],
    );
  }
}

class _LearnSection extends StatelessWidget {
  const _LearnSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'الذكر والتعلم',
          subtitle: 'أدوات بسيطة للعبادة اليومية',
          color: AppTheme.secondaryColor,
        ),
        if (context.isLandscape)
          Row(
            children: [
              Expanded(
                child: _NavCard(
                  title: 'أسماء الله الحسنى',
                  subtitle: 'تأمل في ٩٩ اسماً',
                  icon: Icons.auto_awesome_rounded,
                  gradient: const [Color(0xFF7B4F00), Color(0xFFC9934D)],
                  page: const AsmaUlHusnaScreen(),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _NavCard(
                  title: 'عداد التسبيح',
                  subtitle: 'سبحان الله والحمد لله',
                  icon: Icons.loop_rounded,
                  gradient: const [Color(0xFF6B2D00), Color(0xFFE65100)],
                  page: const TasbihScreen(),
                ),
              ),
            ],
          )
        else ...[
          _NavCard(
            title: 'أسماء الله الحسنى',
            subtitle: 'تأمل في تسعة وتسعين اسماً',
            icon: Icons.auto_awesome_rounded,
            gradient: const [Color(0xFF7B4F00), Color(0xFFC9934D)],
            page: const AsmaUlHusnaScreen(),
          ),
          SizedBox(height: 10.h),
          _NavCard(
            title: 'عداد التسبيح',
            subtitle: 'سبحان الله والحمد لله والله أكبر',
            icon: Icons.loop_rounded,
            gradient: const [Color(0xFF6B2D00), Color(0xFFE65100)],
            page: const TasbihScreen(),
          ),
        ],
      ],
    );
  }
}

class _NavCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final Widget page;

  const _NavCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape = context.isLandscape;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: () => HomeScreen.openPage(context, page),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? 12.w : 16.w,
            vertical: isLandscape ? 14.h : 18.h,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: isLandscape ? 38.w : 46.w,
                height: isLandscape ? 38.w : 46.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isLandscape ? 18.sp : 22.sp,
                ),
              ),
              SizedBox(width: isLandscape ? 10.w : 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isLandscape ? 11.sp : 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isLandscape) ...[
                      SizedBox(height: 3.h),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white.withValues(alpha: 0.7),
                size: isLandscape ? 13.sp : 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
