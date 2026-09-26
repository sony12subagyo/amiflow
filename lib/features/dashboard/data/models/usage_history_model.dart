import 'package:amiflow/features/dashboard/domain/entities/usage_history.dart';

class UsageHistoryModel extends UsageHistory {
  const UsageHistoryModel({
    required super.date,
    required super.usageLiter,
    super.week,
    super.startDate,
    super.endDate,
  });

  factory UsageHistoryModel.fromJson(Map<String, dynamic> json) {
    return UsageHistoryModel(
      date: DateTime.parse(json['date'] as String),
      usageLiter: (json['usageLiter'] as num).toDouble(),
      week: json['week'] as int?,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
    );
  }
}
