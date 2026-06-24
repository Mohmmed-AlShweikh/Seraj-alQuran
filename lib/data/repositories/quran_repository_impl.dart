import 'package:seraj_quran/data/datasources/quran_local_datasource.dart';
import 'package:seraj_quran/data/models/models.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/domain/repositories/repositories.dart';

/// Quran Repository Implementation
class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDataSource _localDataSource;

  QuranRepositoryImpl(this._localDataSource);

  @override
  Future<List<Surah>> getAllSurahs() async {
    return _localDataSource.getAllSurahs();
  }

  @override
  Future<Surah?> getSurah(int surahNumber) async {
    return _localDataSource.getSurah(surahNumber);
  }

  @override
  Future<Verse?> getVerse(int surahNumber, int ayahNumber) async {
    return _localDataSource.getVerse(surahNumber, ayahNumber);
  }

  @override
  Future<List<Verse>> searchVerses(String query) async {
    return _localDataSource.searchVerses(query);
  }

  @override
  Future<ReadingProgressModel?> getReadingProgress() async {
    return _localDataSource.getReadingProgress();
  }

  @override
  Future<void> saveReadingProgress(ReadingProgressModel progress) async {
    await _localDataSource.saveReadingProgress(progress);
  }
}
