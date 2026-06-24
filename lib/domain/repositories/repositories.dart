import 'package:seraj_quran/data/models/models.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

/// Quran Repository Interface
abstract class QuranRepository {
  /// Get all surahs
  Future<List<Surah>> getAllSurahs();

  /// Get specific surah
  Future<Surah?> getSurah(int surahNumber);

  /// Get verse
  Future<Verse?> getVerse(int surahNumber, int ayahNumber);

  /// Search verses
  Future<List<Verse>> searchVerses(String query);

  /// Get reading progress
  Future<ReadingProgressModel?> getReadingProgress();

  /// Save reading progress
  Future<void> saveReadingProgress(ReadingProgressModel progress);
}

/// Adhkar Repository Interface
abstract class AdhkarRepository {
  /// Get all adhkar
  Future<List<Dhikr>> getAllAdhkar();

  /// Get adhkar by category
  Future<List<Dhikr>> getAdhkarByCategory(String category);

  /// Search adhkar
  Future<List<Dhikr>> searchAdhkar(String query);
}

/// Roqia Repository Interface
abstract class RoqiaRepository {
  /// Get all roqia
  Future<List<Dhikr>> getAllRoqia();

  /// Get roqia by category
  Future<List<Dhikr>> getRoqiaByCategory(String category);

  /// Search roqia
  Future<List<Dhikr>> searchRoqia(String query);
}

/// Duas Repository Interface
abstract class DuasRepository {
  /// Get all duas
  Future<List<Dua>> getAllDuas();

  /// Get duas by category
  Future<List<Dua>> getDuasByCategory(String category);

  /// Search duas
  Future<List<Dua>> searchDuas(String query);
}

/// Asma Ul Husna Repository Interface
abstract class AsmaUlHusnaRepository {
  /// Get all names
  Future<List<AsmaName>> getAllNames();

  /// Get specific name
  Future<AsmaName?> getName(int number);

  /// Search names
  Future<List<AsmaName>> searchNames(String query);
}

/// Favorites Repository Interface
abstract class FavoritesRepository {
  /// Get all favorites
  Future<List<FavoriteItem>> getAllFavorites();

  /// Get favorites by type
  Future<List<FavoriteItem>> getFavoritesByType(String type);

  /// Add favorite
  Future<void> addFavorite(FavoriteItem favorite);

  /// Remove favorite
  Future<void> removeFavorite(String id);

  /// Check if favorite
  Future<bool> isFavorite(String id);
}

/// Tasbih Repository Interface
abstract class TasbihRepository {
  /// Get all counters
  Future<List<TasbihCounter>> getAllCounters();

  /// Create counter
  Future<void> createCounter(TasbihCounter counter);

  /// Update counter
  Future<void> updateCounter(TasbihCounter counter);

  /// Delete counter
  Future<void> deleteCounter(String id);
}
