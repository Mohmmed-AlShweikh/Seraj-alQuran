import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:seraj_quran/data/models/models.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

class RoqiaLocalDataSource {

  final Box _roqiaBox;
  List<DhikrModel> _roqiaCache = [];

  RoqiaLocalDataSource(this._roqiaBox);

  Future<void> init() async {
    await _roqiaBox.clear();
    await _loadRoqiaFromAssets();
    _loadRoqiaCache();
  }

  Future<void> _loadRoqiaFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/data/roqia.json');
    final jsonData = jsonDecode(jsonString) as List<dynamic>;

    for (final adhkarData in jsonData) {
      final dhikr = DhikrModel.fromJson(adhkarData as Map<String, dynamic>);
      await _roqiaBox.put('dhikr_${dhikr.id}', jsonEncode(dhikr));
    }
  }

  void _loadRoqiaCache() {
    _roqiaCache = [];
    for (var i = 0; i < _roqiaBox.length; i++) {
      final key = _roqiaBox.keyAt(i);
      final data = _roqiaBox.getAt(i);
      if (key.toString().startsWith('dhikr_') && data != null) {
        _roqiaCache.add(DhikrModel.fromJson(jsonDecode(data)));
      }
    }
  }

  List<Dhikr> getAllRoqia() {
    return _roqiaCache.map(_modelToEntity).toList();
  }

  List<Dhikr> getRoqiaByCategory(String category) {
    return _roqiaCache
        .where((model) => model.category == category)
        .map(_modelToEntity)
        .toList();
  }

  List<Dhikr> searchRoqia(String query) {
    final lowerQuery = query.toLowerCase();
    return _roqiaCache
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
