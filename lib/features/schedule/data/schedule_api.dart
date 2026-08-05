import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amiflow/core/config/app_config.dart';
import 'package:amiflow/features/schedule/domain/schedule_day.dart';

class ScheduleApi {
  Future<List<ScheduleDay>> fetchSchedules(String nodeId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/penjadwalan/$nodeId');
    print('>>> MEMANGGIL: $url');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    print('>>> STATUS: ${response.statusCode}');
    print('>>> BODY: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ScheduleDay.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat jadwal (${response.statusCode})');
    }
  }

  /// Simpan SATU jadwal (satu hari) -- dipakai saat user cuma mengubah
  /// satu kartu hari tanpa mencentang "terapkan ke semua hari".
  Future<void> saveSchedule({
    required String nodeId,
    required String hari,
    required bool aktif,
    String? jamBuka,
    String? jamTutup,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/penjadwalan');

    final bodyData = {
      'node_id': nodeId,
      'hari': hari,
      'aktif': aktif,
      'jam_buka': aktif ? jamBuka : null,
      'jam_tutup': aktif ? jamTutup : null,
    };
    print('>>> KIRIM: $bodyData'); // <-- lihat data yang dikirim

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode(bodyData),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Gagal menyimpan jadwal (${response.statusCode})');
    }
  }

  /// Simpan BANYAK jadwal sekaligus dalam SATU request (bukan loop
  /// berkali-kali) -- dipakai saat user mencentang "terapkan ke semua
  /// hari", supaya ketujuh hari terkirim dalam satu kali panggilan API.
  ///
  /// [items] adalah list objek, masing-masing berisi:
  /// { node_id, hari, aktif, jam_buka, jam_tutup }
  Future<void> saveScheduleBatch(List<Map<String, dynamic>> items) async {
    final url = Uri.parse('${AppConfig.baseUrl}/penjadwalan/batch');

    print('>>> KIRIM BATCH: $items');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode(items),
    );

    print('>>> STATUS BATCH: ${response.statusCode}');
    print('>>> BODY BATCH: ${response.body}');

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Gagal menyimpan jadwal batch (${response.statusCode})');
    }
  }
}
