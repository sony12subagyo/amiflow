import 'package:amiflow/features/dashboard/data/datasources/history_remote_datasource.dart';
import 'package:amiflow/features/dashboard/domain/entities/usage_history.dart';
import 'package:amiflow/features/dashboard/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<UsageHistory>> getDailyHistory(String nodeId) async {
    return await remoteDataSource.getDailyHistory(nodeId);
  }
}