import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
import 'package:seraj_quran/presentation/screens/adhkar/adhkar_screen.dart';
import 'package:seraj_quran/presentation/screens/asma_ul_husna/asma_ul_husna_screen.dart';
import 'package:seraj_quran/presentation/screens/duas/duas_screen.dart';
import 'package:seraj_quran/presentation/screens/quran/quran_screen.dart';
import 'package:seraj_quran/presentation/screens/roqia/roqia_screen.dart';
import 'package:seraj_quran/presentation/screens/settings/settings_screen.dart';
import 'package:seraj_quran/presentation/screens/tasbih/tasbih_screen.dart';
import 'package:hijri/hijri_calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سراج القرآن'),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => _openPage(context, const SettingsScreen()),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            children: [
              const _Header(),
              SizedBox(height: 24.h),

              _Section(
                title: 'القرآن الكريم',
                subtitle: 'قراءة وتصفح السور',
                items: [
                  _HomeAction(
                    title: 'المصحف',
                    subtitle: 'افتح قائمة السور',
                    imagePath: 'assets/icons/quran.jpg',
                    gradient: const [Color(0xFF1B5E20), Color(0xFF43A047)],
                    page: const QuranScreen(),
                  ),
                  _HomeAction(
                    title: 'الرقية الشرعية',
                    subtitle: 'أدعية الرقية الشرعية',
                    imagePath: 'assets/icons/roqia.jpg',
                    gradient: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                    page: const RoqiaScreen(),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              _Section(
                title: 'الأذكار والأدعية',
                subtitle: 'وردك اليومي في مكان واحد',
                items: [
                  _HomeAction(
                    title: 'الأذكار',
                    subtitle: 'أذكار الصباح والمساء',
                    imagePath: 'assets/icons/azkar.png',
                    gradient: const [Color(0xFF1565C0), Color(0xFF42A5F5)],
                    page: const AdhkarScreen(),
                  ),
                  _HomeAction(
                    title: 'الأدعية',
                    subtitle: 'أدعية مختارة ومنظمة',
                    imagePath: 'assets/icons/duaa.png',
                    gradient: const [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
                    page: const DuasScreen(),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              _Section(
                title: 'الذكر والتعلم',
                subtitle: 'أدوات بسيطة للعبادة اليومية',
                items: [
                  _HomeAction(
                    title: 'أسماء الله الحسنى',
                    subtitle: 'تأمل الأسماء والمعاني',
                    imagePath: 'assets/icons/asmaa.png',
                    gradient: const [Color(0xFFF9A825), Color(0xFFFFD54F)],
                    page: const AsmaUlHusnaScreen(),
                  ),
                  _HomeAction(
                    title: 'التسبيح',
                    subtitle: 'عداد تسبيح سهل وسريع',
                    imagePath: 'assets/icons/tasbeeh.jpg',
                    gradient: const [Color(0xFFEF6C00), Color(0xFFFFB74D)],
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
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final hijri = HijriCalendar.now();

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

    final dateText = '${hijri.hDay} ${months[hijri.hMonth]} ${hijri.hYear} هـ';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.isLandscape ? 14.w : 20.w,
        vertical: context.isLandscape ? 8.h : 22.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.75),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            left: -10,
            child: Icon(
              Icons.mosque_rounded,
              size: context.isLandscape ? 42.sp : 130.sp,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          Positioned(
            bottom: -5,
            right: -5,
            child: Icon(
              Icons.star_rounded,
              size: context.isLandscape ? 24.sp : 100.sp,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),

          context.isLandscape
              ? Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'أهلاً بك في سراج القرآن',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dateText,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '﴿ وَذَكِّرْ فَإِنَّ الذِّكْرَىٰ تَنفَعُ الْمُؤْمِنِينَ ﴾',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أهلاً بك في سراج القرآن',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      dateText,
                      style: TextStyle(color: Colors.white70, fontSize: 15.sp),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '﴿ وَذَكِّرْ فَإِنَّ الذِّكْرَىٰ تَنفَعُ الْمُؤْمِنِينَ ﴾',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        height: 1.6,
                      ),
                    ),
                  ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 4.h),
        Text(subtitle),
        SizedBox(height: 14.h),

        LayoutBuilder(
          builder: (context, constraints) {
            if (context.isLandscape || context.isTablet) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: context.isLandscape ? 8.w : 12.w,
                  mainAxisSpacing: context.isLandscape ? 8.h : 12.h,
                  childAspectRatio: context.isLandscape ? 6.2 : 3.4,
                ),
                itemBuilder: (context, index) => items[index],
              );
            }

            return Column(children: items);
          },
        ),
      ],
    );
  }
}

class _HomeAction extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<Color> gradient;
  final Widget page;

  const _HomeAction({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.gradient,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.isLandscape ? 0 : 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () => HomeScreen._openPage(context, page),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.isLandscape ? 10.w : 14.w,
              vertical: context.isLandscape ? 8.h : 12.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 14,
                  spreadRadius: 2,
                  color: Colors.black.withValues(alpha: 0.06),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: context.isLandscape ? 18.r : 26.r,

                  backgroundColor: Colors.transparent,

                  backgroundImage: AssetImage(imagePath),
                ),
                SizedBox(width: context.isLandscape ? 8.w : 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: context.isLandscape ? 10.sp : 25.sp,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      context.isLandscape
                          ? SizedBox.shrink()
                          : Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14.sp,
                              ),
                            ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: context.isLandscape ? 13.sp : 18.sp,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
