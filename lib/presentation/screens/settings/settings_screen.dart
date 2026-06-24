import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'المظهر',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'السمة',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 12.h),
                        SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.light,
                              label: Text('فاتح'),
                              icon: Icon(Icons.light_mode),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              label: Text('داكن'),
                              icon: Icon(Icons.dark_mode),
                            ),
                            ButtonSegment(
                              value: ThemeMode.system,
                              label: Text('النظام'),
                              icon: Icon(Icons.brightness_auto),
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.h, left: 16.w, right: 16.w),
                  child: Text(
                    'عن التطبيق',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: const Text('الإصدار'),
                          subtitle: Text(AppConstants.appVersion),
                          contentPadding: EdgeInsets.zero,
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('اسم التطبيق'),
                          subtitle: Text(AppConstants.appNameArabic),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
