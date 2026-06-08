import 'package:seraj_quran/data/datasources/favorites_local_datasource.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/domain/repositories/repositories.dart';

/// Favorites Repository Implementation
class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource _localDataSource;

  FavoritesRepositoryImpl(this._localDataSource);

  @override
  Future<List<FavoriteItem>> getAllFavorites() async {
    return _localDataSource.getAllFavorites();
  }

  @override
  Future<List<FavoriteItem>> getFavoritesByType(String type) async {
    return _localDataSource.getFavoritesByType(type);
  }

  @override
  Future<void> addFavorite(FavoriteItem favorite) async {
    await _localDataSource.addFavorite(favorite);
  }

  @override
  Future<void> removeFavorite(String id) async {
    await _localDataSource.removeFavorite(id);
  }

  @override
  Future<bool> isFavorite(String id) async {
    return _localDataSource.isFavorite(id);
  }
}
