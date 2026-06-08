import 'package:flutter/material.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/presentation/screens/adhkar/adhkar_screen.dart';
import 'package:seraj_quran/presentation/screens/asma_ul_husna/asma_ul_husna_screen.dart';
import 'package:seraj_quran/presentation/screens/duas/duas_screen.dart';
import 'package:seraj_quran/presentation/screens/favorites/favorites_screen.dart';
import 'package:seraj_quran/presentation/screens/quran/quran_screen.dart';
import 'package:seraj_quran/presentation/screens/settings/settings_screen.dart';
import 'package:seraj_quran/presentation/screens/tasbih/tasbih_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: const Icon(Icons.menu_book), label: 'Quran'),
    BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: 'Adhkar'),
    BottomNavigationBarItem(
      icon: const Icon(Icons.volunteer_activism),
      label: 'Duas',
    ),
    BottomNavigationBarItem(icon: const Icon(Icons.star), label: 'Names'),
    BottomNavigationBarItem(icon: const Icon(Icons.calculate), label: 'Tasbih'),
    BottomNavigationBarItem(
      icon: const Icon(Icons.bookmark),
      label: 'Favorites',
    ),
    BottomNavigationBarItem(icon: const Icon(Icons.history), label: 'Continue'),
    BottomNavigationBarItem(
      icon: const Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  final List<Widget> _screens = const [
    QuranScreen(),
    AdhkarScreen(),
    DuasScreen(),
    AsmaUlHusnaScreen(),
    TasbihScreen(),
    FavoritesScreen(),
    QuranScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Theme.of(context).colorScheme.outline,
          items: _navItems,
        ),
      ),
    );
  }
}
