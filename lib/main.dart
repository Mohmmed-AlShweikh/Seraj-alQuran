import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';
import 'package:seraj_quran/core/services/app_init_service.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';
import 'package:seraj_quran/presentation/providers/favorites/favorites_provider.dart';
import 'package:seraj_quran/presentation/providers/quran/quran_provider.dart';
import 'package:seraj_quran/presentation/providers/theme/theme_provider.dart';
import 'package:seraj_quran/presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInitService.initialize();

  final repositoryProvider = AppRepositoryProvider();
  final themeProvider = ThemeProvider();
  final favoritesProvider = FavoritesProvider();

  await repositoryProvider.init();
  await themeProvider.init();
  await favoritesProvider.init();

  runApp(
    SirajQuranApp(
      repositoryProvider: repositoryProvider,
      themeProvider: themeProvider,
      favoritesProvider: favoritesProvider,
    ),
  );
}

class SirajQuranApp extends StatefulWidget {
  final AppRepositoryProvider repositoryProvider;
  final ThemeProvider themeProvider;
  final FavoritesProvider favoritesProvider;

  const SirajQuranApp({
    required this.repositoryProvider,
    required this.themeProvider,
    required this.favoritesProvider,
    super.key,
  });

  @override
  State<SirajQuranApp> createState() => _SirajQuranAppState();
}

class _SirajQuranAppState extends State<SirajQuranApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.themeProvider),
        ChangeNotifierProvider.value(value: widget.repositoryProvider),
        ChangeNotifierProvider.value(value: widget.favoritesProvider),
        ChangeNotifierProxyProvider<AppRepositoryProvider, QuranProvider>(
          create: (context) => QuranProvider(
            context.read<AppRepositoryProvider>().quranRepository,
          )..init(),
          update: (context, repository, previous) =>
              previous ?? QuranProvider(repository.quranRepository),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return MaterialApp(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.themeMode,
                home: const HomeScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
