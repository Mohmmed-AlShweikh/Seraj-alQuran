import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';
import 'package:seraj_quran/core/services/app_init_service.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';
import 'package:seraj_quran/presentation/providers/quran/quran_provider.dart';
import 'package:seraj_quran/presentation/providers/theme/theme_provider.dart';
import 'package:seraj_quran/presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitService.initialize();
  final repositoryProvider = AppRepositoryProvider();
  final themeProvider = ThemeProvider();
  await repositoryProvider.init();
  await themeProvider.init();
  runApp(
    SirajQuranApp(
      repositoryProvider: repositoryProvider,
      themeProvider: themeProvider,
    ),
  );
}

class SirajQuranApp extends StatefulWidget {
  final AppRepositoryProvider repositoryProvider;
  final ThemeProvider themeProvider;

  const SirajQuranApp({
    required this.repositoryProvider,
    required this.themeProvider,
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
        ProxyProvider<AppRepositoryProvider, QuranProvider>(
          create: (context) => QuranProvider(
            context.read<AppRepositoryProvider>().quranRepository,
          )..init(),
          update: (context, repository, previous) =>
              previous ?? QuranProvider(repository.quranRepository),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
