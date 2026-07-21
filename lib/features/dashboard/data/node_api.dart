import 'dart:convert';
import 'package:amiflow/features/dashboard/domain/entities/klasifikasi.dart';
import 'package:http/http.dart' as http;
import 'package:amiflow/core/config/app_config.dart';
import 'package:amiflow/features/dashboard/domain/entities/node.dart';

class NodeApi {
  Future<List<Node>> fetchNodes(String gatewayId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/gateways/$gatewayId/nodes');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Node.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat node (${response.statusCode})');
    }
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

  Future<bool> updateValve(String nodeId, bool open) async {
    final url = Uri.parse('${AppConfig.baseUrl}/nodes/$nodeId/valve');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({'open': open}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['valveOpen'] as bool; // status terbaru dari server
    } else {
      throw Exception('Gagal mengubah valve (${response.statusCode})');
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
