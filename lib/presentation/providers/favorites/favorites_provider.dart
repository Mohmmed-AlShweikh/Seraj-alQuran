import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesProvider extends ChangeNotifier {
  Box? _box;
  final Set<String> _favoriteIds = {};

  static const String boxName = 'favorites_box';

  Future<void> init() async {
    _box = await Hive.openBox(boxName);
    _favoriteIds.addAll(_box!.keys.cast<String>());
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  int get count => _favoriteIds.length;

  List<Map<String, dynamic>> get allFavorites {
    if (_box == null) return [];
    final items = _box!.keys.cast<String>().map((key) {
      final raw = _box!.get(key);
      if (raw is Map) return Map<String, dynamic>.from(raw);
      return <String, dynamic>{};
    }).where((m) => m.isNotEmpty).toList();
    items.sort((a, b) {
      final aDate = a['addedAt'] as String? ?? '';
      final bDate = b['addedAt'] as String? ?? '';
      return bDate.compareTo(aDate);
    });
    return items;
  }

  Future<void> toggle(
    String id,
    String text,
    String type, {
    String? reference,
  }) async {
    if (_box == null) return;
    if (_favoriteIds.contains(id)) {
      await _box!.delete(id);
      _favoriteIds.remove(id);
    } else {
      await _box!.put(id, {
        'id': id,
        'text': text,
        'type': type,
        'reference': reference,
        'addedAt': DateTime.now().toIso8601String(),
      });
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  Future<void> remove(String id) async {
    if (_box == null) return;
    await _box!.delete(id);
    _favoriteIds.remove(id);
    notifyListeners();
  }
}
