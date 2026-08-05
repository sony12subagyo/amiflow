import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:amiflow/core/config/app_config.dart';
import 'package:amiflow/features/dashboard/data/models/usage_history_model.dart';

class HistoryRemoteDataSource {
  Future<List<UsageHistoryModel>> getDailyHistory(String nodeId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/nodes/$nodeId/chart');

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

    final json = jsonDecode(response.body);

    final List data = json['data'];

    return data.map((e) => UsageHistoryModel.fromJson(e)).toList();
  }
}
