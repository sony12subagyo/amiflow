import 'package:amiflow/features/dashboard/domain/entities/usage_history.dart';

class UsageHistoryModel extends UsageHistory {
  const UsageHistoryModel({required super.date, required super.usageLiter});

  /// Backend (GET /api/nodes/{id}/chart) mengirim bentuk per-hari:
  /// { "date": "2026-08-05", "day": "Rab", "label": "05 Agustus 2026",
  ///   "usageLiter": 630.12 }
  /// -- 'date' adalah string tanggal (bisa langsung di-parse DateTime),
  /// bukan 'timestamp' epoch seperti dugaan sebelumnya.
  factory UsageHistoryModel.fromJson(Map<String, dynamic> json) {
    return UsageHistoryModel(
      date: DateTime.parse(json['date'] as String),
      usageLiter: (json['usageLiter'] as num).toDouble(),
    );
  }
}
