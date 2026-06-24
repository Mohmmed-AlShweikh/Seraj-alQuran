import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:seraj_quran/data/models/models.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

class AsmaUlHusnaLocalDataSource {
  final Box _asmaBox;
  List<AsmaNameModel> _asmaCache = [];

  AsmaUlHusnaLocalDataSource(this._asmaBox);

  Future<void> init() async {
    await _asmaBox.clear();
    await _loadNamesFromAssets();
    _loadCache();
  }

  Future<void> _loadNamesFromAssets() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/asma_ul_husna.json',
    );

    final jsonData = jsonDecode(jsonString) as List<dynamic>;

    for (final item in jsonData) {
      final model = AsmaNameModel.fromJson(item as Map<String, dynamic>);

      await _asmaBox.put('asma_${model.number}', jsonEncode(model.toJson()));
    }
  }

  void _loadCache() {
    _asmaCache = [];

    for (var i = 0; i < _asmaBox.length; i++) {
      final key = _asmaBox.keyAt(i);
      final data = _asmaBox.getAt(i);

      if (key.toString().startsWith('asma_') && data != null) {
        _asmaCache.add(AsmaNameModel.fromJson(jsonDecode(data)));
      }
    }
  }

  List<AsmaName> getAllNames() {
    return _asmaCache.map(_modelToEntity).toList();
  }

  AsmaName? getName(int number) {
    try {
      final model = _asmaCache.firstWhere((e) => e.number == number);

      return _modelToEntity(model);
    } catch (_) {
      return null;
    }
  }

  AsmaName _modelToEntity(AsmaNameModel model) {
    return AsmaName(
      number: model.number,
      nameArabic: model.nameArabic,
      nameTransliteration: model.nameTransliteration,
      meaning: model.meaning,
      explanation: model.explanation,
    );
  }

  List<AsmaName> searchNames(String query) {
    final lowerQuery = query.toLowerCase();

    return _asmaCache
        .where(
          (model) =>
              model.nameArabic.contains(query) ||
              model.nameTransliteration.toLowerCase().contains(lowerQuery) ||
              model.meaning.toLowerCase().contains(lowerQuery) ||
              (model.explanation?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .map(_modelToEntity)
        .toList();
  }
}
