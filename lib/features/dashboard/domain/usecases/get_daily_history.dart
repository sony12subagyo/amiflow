import 'package:amiflow/features/dashboard/domain/entities/usage_history.dart';
import 'package:amiflow/features/dashboard/domain/repositories/history_repository.dart';

class GetDailyHistory {
  final HistoryRepository repository;

  GetDailyHistory(this.repository);

  Future<List<UsageHistory>> call(String nodeId) {
    return repository.getDailyHistory(nodeId);
  }
}