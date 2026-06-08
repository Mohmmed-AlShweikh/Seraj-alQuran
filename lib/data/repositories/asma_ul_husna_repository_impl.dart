import 'package:seraj_quran/data/datasources/asma_ul_husna_local_datasource.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/domain/repositories/repositories.dart';

class AsmaUlHusnaRepositoryImpl
    implements AsmaUlHusnaRepository {

  final AsmaUlHusnaLocalDataSource _localDataSource;

  AsmaUlHusnaRepositoryImpl(this._localDataSource);

  @override
  Future<List<AsmaName>> getAllNames() async {
    return _localDataSource.getAllNames();
  }

  @override
  Future<AsmaName?> getName(int number) async {
    return _localDataSource.getName(number);
  }
  
  @override
  Future<List<AsmaName>> searchNames(String query) async {
   return _localDataSource.searchNames(query);
  }
}