import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:seraj_quran/data/models/models.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

/// Tasbih Local Data Source
class TasbihLocalDataSource {
  final Box _tasbihBox;

  TasbihLocalDataSource(this._tasbihBox);

  /// Get all counters
  List<TasbihCounter> getAllCounters() {
    final counters = <TasbihCounter>[];

    for (var i = 0; i < _tasbihBox.length; i++) {
      final key = _tasbihBox.keyAt(i);
      final data = _tasbihBox.getAt(i);

      if (key.toString().startsWith('counter_') && data != null) {
        try {
          final model = TasbihCounterModel.fromJson(jsonDecode(data));
          counters.add(_modelToEntity(model));
        } catch (e) {
          print('Error parsing counter: $e');
        }
      }
    }

    return counters;
  }

  /// Create counter
  Future<void> createCounter(TasbihCounter counter) async {
    try {
      final model = TasbihCounterModel(
        id: counter.id,
        text: counter.text,
        targetCount: counter.targetCount,
        currentCount: counter.currentCount,
        createdAt: counter.createdAt,
        completedAt: counter.completedAt,
      );
      await _tasbihBox.put('counter_${counter.id}', jsonEncode(model));
    } catch (e) {
      print('Error creating counter: $e');
    }
  }

  /// Update counter
  Future<void> updateCounter(TasbihCounter counter) async {
    try {
      final model = TasbihCounterModel(
        id: counter.id,
        text: counter.text,
        targetCount: counter.targetCount,
        currentCount: counter.currentCount,
        createdAt: counter.createdAt,
        completedAt: counter.completedAt,
      );
      await _tasbihBox.put('counter_${counter.id}', jsonEncode(model));
    } catch (e) {
      print('Error updating counter: $e');
    }
  }

  /// Delete counter
  Future<void> deleteCounter(String id) async {
    try {
      await _tasbihBox.delete('counter_$id');
    } catch (e) {
      print('Error deleting counter: $e');
    }
  }

  /// Convert model to entity
  TasbihCounter _modelToEntity(TasbihCounterModel model) {
    return TasbihCounter(
      id: model.id,
      text: model.text,
      targetCount: model.targetCount,
      currentCount: model.currentCount,
      createdAt: model.createdAt,
      completedAt: model.completedAt,
    );
  }
}
