import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:amiflow/core/config/app_config.dart';
import 'package:amiflow/features/dashboard/data/models/usage_history_model.dart';

class HistoryRemoteDataSource {
  Future<List<UsageHistoryModel>> getDailyHistory(String nodeId) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/nodes/$nodeId/daily-history',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil riwayat penggunaan');
    }

    final List data = jsonDecode(response.body);

    return data
        .map((e) => UsageHistoryModel.fromJson(e))
        .toList();
  }
}