import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';

/// Theme Provider using ChangeNotifier
class ThemeProvider extends ChangeNotifier {
  late Box _settingsBox;
  late ThemeMode _themeMode;

  ThemeProvider() {
    _themeMode = ThemeMode.system;
  }

  /// Initialize the provider
  Future<void> init() async {
    _settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
    _loadThemeMode();
  }

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Load theme mode from Hive
  void _loadThemeMode() {
    final savedTheme = _settingsBox.get(
      AppConstants.themeKey,
      defaultValue: 'system',
    );

    switch (savedTheme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    final modeString = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
        ? 'dark'
        : 'system';

    await _settingsBox.put(AppConstants.themeKey, modeString);
    notifyListeners();
  }

  /// Toggle theme
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    await setThemeMode(newMode);
  }

  /// Check if dark mode
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
