import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';

/// App Initialization Service
class AppInitService {
  /// Initialize the app
  static Future<void> initialize() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Open all required boxes
    await Future.wait([
      Hive.openBox(AppConstants.quranBoxName),
      Hive.openBox(AppConstants.adhkarBoxName),
      Hive.openBox(AppConstants.duasBoxName),
      Hive.openBox(AppConstants.asmaBoxName),
      Hive.openBox(AppConstants.roqiaBoxName),
      Hive.openBox(AppConstants.settingsBoxName),
      Hive.openBox(AppConstants.readingProgressBoxName),
    ]);

    debugPrint('App initialized successfully');
  }

  /// Dispose resources
  static Future<void> dispose() async {
    await Hive.close();
  }
}
