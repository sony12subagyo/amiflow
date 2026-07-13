import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amiflow/core/config/app_config.dart';
import 'package:amiflow/features/gateway/domain/entities/gateway.dart';

class GatewayApi {
  Future<List<Gateway>> fetchGateways() async {
    final url = Uri.parse('${AppConfig.baseUrl}/gateways');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning':
            'true', // agar ngrok tidak balas halaman peringatan
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Gateway.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat gateway (${response.statusCode})');
    }
  }

  Future<void> deleteGateway(String id) async {
    final url = Uri.parse('${AppConfig.baseUrl}/gateways/$id');

    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus gateway (${response.statusCode})');
    }
  }

  Future<Gateway> addGateway({
    required String kodeGateway,
    required String nama,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/gateways');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({'kode_gateway': kodeGateway, 'nama': nama}),
    );

    if (response.statusCode == 201) {
      return Gateway.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal menambah gateway (${response.statusCode})');
    }
  }
}
