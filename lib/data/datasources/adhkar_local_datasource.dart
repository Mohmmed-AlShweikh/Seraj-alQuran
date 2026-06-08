import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:seraj_quran/data/models/models.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

class AdhkarLocalDataSource {
  final Box _adhkarBox;
  List<DhikrModel> _adhkarCache = [];

  AdhkarLocalDataSource(this._adhkarBox);

  Future<void> init() async {
    await _adhkarBox.clear();
    await _loadAdhkarFromAssets();
    _loadAdhkarCache();
  }

  Future<void> _loadAdhkarFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/data/adhkar.json');
    final jsonData = jsonDecode(jsonString) as List<dynamic>;

    for (final adhkarData in jsonData) {
      final dhikr = DhikrModel.fromJson(adhkarData as Map<String, dynamic>);
      await _adhkarBox.put('dhikr_${dhikr.id}', jsonEncode(dhikr));
    }
  }

  void _loadAdhkarCache() {
    _adhkarCache = [];
    for (var i = 0; i < _adhkarBox.length; i++) {
      final key = _adhkarBox.keyAt(i);
      final data = _adhkarBox.getAt(i);
      if (key.toString().startsWith('dhikr_') && data != null) {
        _adhkarCache.add(DhikrModel.fromJson(jsonDecode(data)));
      }
    }
  }

  List<Dhikr> getAllAdhkar() {
    return _adhkarCache.map(_modelToEntity).toList();
  }

  List<Dhikr> getAdhkarByCategory(String category) {
    return _adhkarCache
        .where((model) => model.category == category)
        .map(_modelToEntity)
        .toList();
  }

  List<Dhikr> searchAdhkar(String query) {
    final lowerQuery = query.toLowerCase();
    return _adhkarCache
        .where(
          (model) =>
              model.text.contains(query) ||
              model.category.toLowerCase().contains(lowerQuery) ||
              (model.reference?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .map(_modelToEntity)
        .toList();
  }

  Dhikr _modelToEntity(DhikrModel model) {
    return Dhikr(
      id: model.id,
      text: model.text,
      category: model.category,
      count: model.count,
      reference: model.reference,
      userCount: model.userCount,
    );
  }
}
