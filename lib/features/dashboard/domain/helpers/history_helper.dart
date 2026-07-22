import 'package:amiflow/features/dashboard/domain/entities/usage_history.dart';

class HistoryHelper {
  /// Total penggunaan dari seluruh data
  static double totalUsage(List<UsageHistory> data) {
    return data.fold(
      0,
      (sum, item) => sum + item.usageLiter,
    );
  }
}