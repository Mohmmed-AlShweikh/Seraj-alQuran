import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:seraj_quran/data/models/models.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

class DuasLocalDataSource {
  final Box _duasBox;
  List<DuaModel> _duasCache = [];

  DuasLocalDataSource(this._duasBox);

  Future<void> init() async {
    await _duasBox.clear();
    await _loadDuasFromAssets();
    _loadDuasCache();
  }

  Future<void> _loadDuasFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/data/duas.json');
    final jsonData = jsonDecode(jsonString) as List<dynamic>;

    for (final duaData in jsonData) {
      final dua = DuaModel.fromJson(duaData as Map<String, dynamic>);
      await _duasBox.put('dua_${dua.id}', jsonEncode(dua));
    }
  }

  void _loadDuasCache() {
    _duasCache = [];
    for (var i = 0; i < _duasBox.length; i++) {
      final key = _duasBox.keyAt(i);
      final data = _duasBox.getAt(i);
      if (key.toString().startsWith('dua_') && data != null) {
        _duasCache.add(DuaModel.fromJson(jsonDecode(data)));
      }
    }
  }

  List<Dua> getAllDuas() {
    return _duasCache.map(_modelToEntity).toList();
  }

  List<Dua> getDuasByCategory(String category) {
    return _duasCache
        .where((model) => model.category == category)
        .map(_modelToEntity)
        .toList();
  }

  List<Dua> searchDuas(String query) {
    final lowerQuery = query.toLowerCase();
    return _duasCache
        .where(
          (model) =>
              model.text.contains(query) ||
              model.category.toLowerCase().contains(lowerQuery) ||
              (model.reference?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .map(_modelToEntity)
        .toList();
  }

  Dua _modelToEntity(DuaModel model) {
    return Dua(
      id: model.id,
      text: model.text,
      category: model.category,
      reference: model.reference,
      transliteration: model.transliteration,
    );
  }
}
