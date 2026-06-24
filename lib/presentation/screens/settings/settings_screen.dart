import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';
import 'package:seraj_quran/presentation/providers/theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الإعدادات'), centerTitle: true),
        body: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                _SectionHeader(title: 'المظهر'),
                SizedBox(height: 8.h),
                _SettingsCard(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.palette_outlined, size: 20.sp, color: AppTheme.primaryColor),
                              SizedBox(width: 8.w),
                              Text('السمة', style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          SegmentedButton<ThemeMode>(
                            segments: const [
                              ButtonSegment(
                                value: ThemeMode.light,
                                label: Text('فاتح'),
                                icon: Icon(Icons.light_mode_rounded),
                              ),
                              ButtonSegment(
                                value: ThemeMode.dark,
                                label: Text('داكن'),
                                icon: Icon(Icons.dark_mode_rounded),
                              ),
                              ButtonSegment(
                                value: ThemeMode.system,
                                label: Text('تلقائي'),
                                icon: Icon(Icons.brightness_auto_rounded),
                              ),
                            ],
                            selected: {themeProvider.themeMode},
                            onSelectionChanged: (value) {
                              if (value.isNotEmpty) {
                                themeProvider.setThemeMode(value.first);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _SectionHeader(title: 'القرآن الكريم'),
                SizedBox(height: 8.h),
                _SettingsCard(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.text_fields_rounded, size: 20.sp, color: AppTheme.primaryColor),
                              SizedBox(width: 8.w),
                              Text('حجم خط القرآن', style: Theme.of(context).textTheme.titleMedium),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  '${themeProvider.quranFontSize.round()}',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Text(
                                'أ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                              Expanded(
                                child: Slider(
                                  value: themeProvider.quranFontSize,
                                  min: AppConstants.minQuranFontSize,
                                  max: AppConstants.maxQuranFontSize,
                                  divisions: 8,
                                  activeColor: AppTheme.primaryColor,
                                  onChanged: themeProvider.setQuranFontSize,
                                ),
                              ),
                              Text(
                                'أ',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Text(
                              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: AppConstants.arabicFontName,
                                fontSize: themeProvider.quranFontSize,
                                height: 1.7,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _SectionHeader(title: 'عن التطبيق'),
                SizedBox(height: 8.h),
                _SettingsCard(
                  children: [
                    _InfoTile(
                      icon: Icons.apps_rounded,
                      title: 'اسم التطبيق',
                      value: AppConstants.appNameArabic,
                    ),
                    const Divider(height: 1),
                    _InfoTile(
                      icon: Icons.info_outline_rounded,
                      title: 'الإصدار',
                      value: AppConstants.appVersion,
                    ),
                    const Divider(height: 1),
                    _InfoTile(
                      icon: Icons.auto_awesome_rounded,
                      title: 'الهدف',
                      value: 'تيسير الذكر والتلاوة للمسلمين',
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: AppTheme.primaryColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).dividerTheme.color ?? Colors.grey.withValues(alpha: 0.15),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(children: children),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: AppTheme.primaryColor.withValues(alpha: 0.7)),
          SizedBox(width: 10.w),
          Text(
            title,
            style: theme.textTheme.bodyMedium,
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
