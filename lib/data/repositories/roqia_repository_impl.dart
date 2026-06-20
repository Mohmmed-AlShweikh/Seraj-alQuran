import 'package:seraj_quran/data/datasources/roqia_datasource.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/domain/repositories/repositories.dart';

class RoqiaRepositoryImpl implements RoqiaRepository {
  final RoqiaLocalDataSource _localDataSource;

  RoqiaRepositoryImpl(this._localDataSource);

  @override
  Future<List<Dhikr>> getAllRoqia() async {
    return _localDataSource.getAllRoqia();
  }

  @override
  Future<List<Dhikr>> getRoqiaByCategory(String category) async {
    return _localDataSource.getRoqiaByCategory(category);
  }

  @override
  Future<List<Dhikr>> searchRoqia(String query) async {
    return _localDataSource.searchRoqia(query);
  }
  
}
