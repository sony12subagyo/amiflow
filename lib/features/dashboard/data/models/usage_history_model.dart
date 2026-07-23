import 'package:amiflow/features/dashboard/domain/entities/usage_history.dart';

class UsageHistoryModel extends UsageHistory {
  const UsageHistoryModel({
    required super.date,
    required super.usageLiter,
  });

  factory UsageHistoryModel.fromJson(Map<String, dynamic> json) {
    return UsageHistoryModel(
      date: DateTime.parse(json['date']),
      usageLiter: (json['usage_liter'] as num).toDouble(),
    );
  }
}