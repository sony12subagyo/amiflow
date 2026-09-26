import 'package:amiflow/features/dashboard/domain/entities/usage_history.dart';
import 'package:amiflow/features/dashboard/domain/repositories/history_repository.dart';

class GetWeeklyHistory {
  final HistoryRepository repository;

  GetWeeklyHistory(this.repository);

  Future<List<UsageHistory>> call(String nodeId) {
    return repository.getWeeklyHistory(nodeId);
  }
}