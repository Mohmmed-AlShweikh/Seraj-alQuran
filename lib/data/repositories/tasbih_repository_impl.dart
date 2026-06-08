import 'package:seraj_quran/data/datasources/tasbih_local_datasource.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/domain/repositories/repositories.dart';

/// Tasbih Repository Implementation
class TasbihRepositoryImpl implements TasbihRepository {
  final TasbihLocalDataSource _localDataSource;

  TasbihRepositoryImpl(this._localDataSource);

  @override
  Future<List<TasbihCounter>> getAllCounters() async {
    return _localDataSource.getAllCounters();
  }

  @override
  Future<void> createCounter(TasbihCounter counter) async {
    await _localDataSource.createCounter(counter);
  }

  @override
  Future<void> updateCounter(TasbihCounter counter) async {
    await _localDataSource.updateCounter(counter);
  }

  @override
  Future<void> deleteCounter(String id) async {
    await _localDataSource.deleteCounter(id);
  }
}
