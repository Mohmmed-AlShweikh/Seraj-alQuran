import 'package:seraj_quran/data/datasources/adhkar_local_datasource.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/domain/repositories/repositories.dart';

/// Adhkar Repository Implementation
class AdhkarRepositoryImpl implements AdhkarRepository {
  final AdhkarLocalDataSource _localDataSource;

  AdhkarRepositoryImpl(this._localDataSource);

  @override
  Future<List<Dhikr>> getAllAdhkar() async {
    return _localDataSource.getAllAdhkar();
  }

  @override
  Future<List<Dhikr>> getAdhkarByCategory(String category) async {
    return _localDataSource.getAdhkarByCategory(category);
  }

  @override
  Future<List<Dhikr>> searchAdhkar(String query) async {
    return _localDataSource.searchAdhkar(query);
  }
}
