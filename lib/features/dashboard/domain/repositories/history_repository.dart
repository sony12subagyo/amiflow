import 'package:amiflow/features/dashboard/domain/entities/usage_history.dart';

abstract class HistoryRepository {
  Future<List<UsageHistory>> getDailyHistory(String nodeId);
}