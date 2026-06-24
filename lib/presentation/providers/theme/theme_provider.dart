import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';

class ThemeProvider extends ChangeNotifier {
  late Box _settingsBox;
  late ThemeMode _themeMode;
  double _quranFontSize = AppConstants.defaultQuranFontSize;

  ThemeProvider() {
    _themeMode = ThemeMode.system;
  }

  Future<void> init() async {
    _settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
    _loadThemeMode();
    _loadFontSize();
  }

  ThemeMode get themeMode => _themeMode;
  double get quranFontSize => _quranFontSize;

  void _loadThemeMode() {
    final savedTheme = _settingsBox.get(AppConstants.themeKey, defaultValue: 'system');
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

  void _loadFontSize() {
    _quranFontSize = (_settingsBox.get(
      AppConstants.fontSizeKey,
      defaultValue: AppConstants.defaultQuranFontSize,
    ) as num).toDouble();
  }

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

  Future<void> setQuranFontSize(double size) async {
    _quranFontSize = size.clamp(
      AppConstants.minQuranFontSize,
      AppConstants.maxQuranFontSize,
    );
    await _settingsBox.put(AppConstants.fontSizeKey, _quranFontSize);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
