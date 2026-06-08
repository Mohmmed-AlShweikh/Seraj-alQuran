import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:seraj_quran/data/models/models.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

/// Favorites Local Data Source
class FavoritesLocalDataSource {
  final Box _favoritesBox;

  FavoritesLocalDataSource(this._favoritesBox);

  /// Get all favorites
  List<FavoriteItem> getAllFavorites() {
    final favorites = <FavoriteItem>[];

    for (var i = 0; i < _favoritesBox.length; i++) {
      final key = _favoritesBox.keyAt(i);
      final data = _favoritesBox.getAt(i);

      if (key.toString().startsWith('favorite_') && data != null) {
        try {
          final model = FavoriteItemModel.fromJson(jsonDecode(data));
          favorites.add(_modelToEntity(model));
        } catch (e) {
          print('Error parsing favorite: $e');
        }
      }
    }

    // Sort by date (newest first)
    favorites.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    return favorites;
  }

  /// Get favorites by type
  List<FavoriteItem> getFavoritesByType(String type) {
    return getAllFavorites().where((fav) => fav.type == type).toList();
  }

  /// Add favorite
  Future<void> addFavorite(FavoriteItem favorite) async {
    try {
      final model = FavoriteItemModel(
        id: favorite.id,
        type: favorite.type,
        content: favorite.content,
        metadata: favorite.metadata,
        addedAt: favorite.addedAt,
      );
      await _favoritesBox.put('favorite_${favorite.id}', jsonEncode(model));
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  /// Remove favorite
  Future<void> removeFavorite(String id) async {
    try {
      await _favoritesBox.delete('favorite_$id');
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  /// Check if favorite
  bool isFavorite(String id) {
    return _favoritesBox.containsKey('favorite_$id');
  }

  /// Convert model to entity
  FavoriteItem _modelToEntity(FavoriteItemModel model) {
    return FavoriteItem(
      id: model.id,
      type: model.type,
      content: model.content,
      metadata: model.metadata,
      addedAt: model.addedAt,
    );
  }
}
