import 'dart:convert';
import 'package:amiflow/features/dashboard/domain/entities/klasifikasi.dart';
import 'package:http/http.dart' as http;
import 'package:amiflow/core/config/app_config.dart';
import 'package:amiflow/features/dashboard/domain/entities/node.dart';
import 'package:amiflow/features/dashboard/domain/entities/node_detail.dart';

class NodeApi {
  Future<List<Node>> fetchNodes(String gatewayId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/tb/nodes');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final List<dynamic> data = body['data'];

      final nodes = data.map((e) => Node.fromJson(e)).toList();
      print("========== HASIL PARSING ==========");

      for (final node in nodes) {
        print("${node.code} -> ${node.online}");
      }
      for (final node in nodes) {
        print("====================");
        print("Node   : ${node.code}");
        print("Online : ${node.online}");
      }

      return nodes;
    }

    throw Exception('Gagal memuat node (${response.statusCode})');
  }

  Future<NodeDetail> fetchNodeDetail(String nodeId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/tb/nodes/$nodeId');

    print("DETAIL URL = $url");

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    print("DETAIL STATUS = ${response.statusCode}");

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // Debug JSON dari Laravel
      print("========== RAW JSON ==========");
      print(body);

      final detail = NodeDetail.fromJson(body['data']);

      // Debug hasil parsing Flutter
      print("========== NODE DETAIL ==========");
      print("TB DEVICE : ${detail.tbDeviceId}");
      print("Volume    : ${detail.telemetry.volume}");
      print("Flow      : ${detail.telemetry.flow}");
      print("Valve     : ${detail.telemetry.valveOpen}");

      return detail;
    }

    print(response.body);

    throw Exception('Gagal memuat detail node (${response.statusCode})');
  }

  Future<void> deleteNode(String id) async {
    final url = Uri.parse('${AppConfig.baseUrl}/nodes/$id');

    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus node (${response.statusCode})');
    }
  }

  Future<Node> addNode({
    required String gatewayId,
    required String kodeNode,
    required String namaPemilik,
    required int jumlahPenghuni,
    required String password,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/nodes');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        'gateway_id': gatewayId,
        'kode_node': kodeNode,
        'nama_pemilik': namaPemilik,
        'jumlah_penghuni': jumlahPenghuni,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return Node.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal menambah node (${response.statusCode})');
    }
  }

  Future<Node> updateNode({
    required String id,
    required String namaPemilik,
    required int jumlahPenghuni,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/nodes/$id');

    final response = await http.put(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        'nama_pemilik': namaPemilik,
        'jumlah_penghuni': jumlahPenghuni,
      }),
    );

    if (response.statusCode == 200) {
      return Node.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengubah node (${response.statusCode})');
    }
  }

  Future<void> updateValve({
    required String deviceId,
    required bool open,
  }) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/thingsboard/devices/$deviceId/valve',
    );

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({'open': open}),
    );

    print("=== UPDATE VALVE ===");
    print("Device ID : $deviceId");
    print("Status    : ${response.statusCode}");
    print(response.body);

    if (response.statusCode != 200) {
      throw Exception('Gagal mengirim perintah valve (${response.statusCode})');
    }
  }

  /// Ambil hasil klasifikasi Hemat/Normal/Boros dari KlasifikasiController.
  ///
  /// CATATAN: path endpoint di bawah ini ASUMSI ('/klasifikasi/{nodeId}/{tahun}/{bulan}').
  /// Cek routes/api.php di Laravel untuk path aslinya, sesuaikan jika beda.
  ///
  /// Backend bisa balas 200 (lengkap), 202 (ML belum aktif, < 30 hari data),
  /// atau 400 (data < 2 baris) -- ketiganya tetap di-parse jadi [Klasifikasi],
  /// bukan dilempar sebagai error, karena ini kondisi valid yang perlu
  /// ditampilkan ke user, bukan kegagalan jaringan.
  Future<Klasifikasi> fetchKlasifikasi(
    String nodeId,
    int tahun,
    int bulan,
  ) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/klasifikasi/$nodeId/$tahun/$bulan',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200 ||
        response.statusCode == 202 ||
        response.statusCode == 400) {
      return Klasifikasi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat klasifikasi (${response.statusCode})');
    }
  }
}
