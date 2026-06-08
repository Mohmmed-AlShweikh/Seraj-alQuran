import 'package:seraj_quran/data/datasources/duas_local_datasource.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/domain/repositories/repositories.dart';

/// Duas Repository Implementation
class DuasRepositoryImpl implements DuasRepository {
  final DuasLocalDataSource _localDataSource;

  DuasRepositoryImpl(this._localDataSource);

  @override
  Future<List<Dua>> getAllDuas() async {
    return _localDataSource.getAllDuas();
  }

  @override
  Future<List<Dua>> getDuasByCategory(String category) async {
    return _localDataSource.getDuasByCategory(category);
  }

  @override
  Future<List<Dua>> searchDuas(String query) async {
    return _localDataSource.searchDuas(query);
  }
}
