import 'dart:convert';
import 'package:amiflow/features/dashboard/domain/entities/klasifikasi.dart';
import 'package:http/http.dart' as http;
import 'package:amiflow/core/config/app_config.dart';
import 'package:amiflow/features/dashboard/domain/entities/node.dart';
import 'package:amiflow/features/dashboard/domain/entities/node_detail.dart';

class NodeApi {
  /// BARU -- detail satu node LENGKAP: info MySQL + telemetry live
  /// ThingsBoard + status_penggunaan resmi (StatusPenggunaanService),
  /// lewat endpoint GET /api/tb/nodes/{id}. Dipakai NodeDetailPage.
  Future<NodeDetail> fetchNodeDetail(String nodeId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/tb/nodes/$nodeId');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NodeDetail.fromJson(body['data']);
    } else {
      throw Exception('Gagal memuat detail node (${response.statusCode})');
    }
  }

  /// LAMA -- dipertahankan untuk kompatibilitas kalau masih dipakai
  /// di tempat lain. Untuk DashboardPage, pakai fetchNodesFromGateway().
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

  /// BARU -- ambil node dalam satu gateway LENGKAP dengan telemetry
  /// live ThingsBoard + status Hemat/Normal/Boros resmi dari backend
  /// (StatusPenggunaanService, sama sumbernya dengan fetchKlasifikasi()),
  /// lewat endpoint GET /api/tb/gateways/{id}.
  ///
  /// Pakai ini untuk menggantikan fetchNodes() di DashboardPage, supaya
  /// kartu node langsung menampilkan status terkini tanpa panggilan
  /// terpisah per node.
  Future<List<Node>> fetchNodesFromGateway(String gatewayId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/tb/gateways/$gatewayId');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> nodesJson = body['data']['nodes'];
      return nodesJson.map((json) => Node.fromTbJson(json)).toList();
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
  /// Ini SUMBER RESMI yang sama dipakai fetchNodesFromGateway() -- pastikan
  /// dua-duanya selalu menampilkan kategori yang identik untuk node yang sama.
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
