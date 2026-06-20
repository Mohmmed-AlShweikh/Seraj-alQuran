import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';
import 'package:seraj_quran/data/datasources/adhkar_local_datasource.dart';
import 'package:seraj_quran/data/datasources/asma_ul_husna_local_datasource.dart';
import 'package:seraj_quran/data/datasources/duas_local_datasource.dart';
import 'package:seraj_quran/data/datasources/roqia_datasource.dart';
import 'package:seraj_quran/data/datasources/quran_local_datasource.dart';
import 'package:seraj_quran/data/datasources/tasbih_local_datasource.dart';
import 'package:seraj_quran/data/repositories/adhkar_repository_impl.dart';
import 'package:seraj_quran/data/repositories/asma_ul_husna_repository_impl.dart';
import 'package:seraj_quran/data/repositories/duas_repository_impl.dart';
import 'package:seraj_quran/data/repositories/quran_repository_impl.dart';
import 'package:seraj_quran/data/repositories/roqia_repository_impl.dart';
import 'package:seraj_quran/data/repositories/tasbih_repository_impl.dart';
import 'package:seraj_quran/domain/repositories/repositories.dart';

/// App Repository Provider
class AppRepositoryProvider extends ChangeNotifier {
  late QuranRepository quranRepository;
  late AdhkarRepository adhkarRepository;
  late DuasRepository duasRepository;
  late AsmaUlHusnaRepository asmaUlHusnaRepository;
  late TasbihRepository tasbihRepository;
  late RoqiaRepository roqiaRepository;
  bool isInitialized = false;

  /// Initialize all repositories
  Future<void> init() async {
    try {
      // Get Hive boxes
      final quranBox = Hive.box(AppConstants.quranBoxName);
      final adhkarBox = Hive.box(AppConstants.adhkarBoxName);
      final duasBox = Hive.box(AppConstants.duasBoxName);
      final asmaBox = Hive.box(AppConstants.asmaBoxName);
      final roqiaBox = Hive.box(AppConstants.roqiaBoxName);
      final tasbihBox = Hive.box(AppConstants.readingProgressBoxName);

      // Initialize data sources
      final quranDataSource = QuranLocalDataSource(quranBox);
      await quranDataSource.init();

      final adhkarDataSource = AdhkarLocalDataSource(adhkarBox);
      await adhkarDataSource.init();

      final duasDataSource = DuasLocalDataSource(duasBox);
      await duasDataSource.init();

      final asmaDataSource = AsmaUlHusnaLocalDataSource(asmaBox);
      await asmaDataSource.init();

      final roqiaDataSource = RoqiaLocalDataSource(roqiaBox);
      await roqiaDataSource.init();

      final tasbihDataSource = TasbihLocalDataSource(tasbihBox);

      // Initialize repositories
      quranRepository = QuranRepositoryImpl(quranDataSource);
      adhkarRepository = AdhkarRepositoryImpl(adhkarDataSource);
      duasRepository = DuasRepositoryImpl(duasDataSource);
      asmaUlHusnaRepository = AsmaUlHusnaRepositoryImpl(asmaDataSource);
      roqiaRepository = RoqiaRepositoryImpl(roqiaDataSource) as RoqiaRepository;
      tasbihRepository = TasbihRepositoryImpl(tasbihDataSource);

      isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing repositories: $e');
      rethrow;
    }
  }
}
