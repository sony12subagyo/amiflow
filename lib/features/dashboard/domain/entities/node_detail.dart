import 'node.dart';
import 'telemetry.dart';
import 'status_penggunaan.dart';

class NodeDetail {
  final String id;
  final String gatewayId;

  final String code;
  final String owner;

  final int totalUsers;

  final bool active;
  final bool online;

  final Telemetry telemetry;

  final StatusPenggunaan statusPenggunaan;

  const NodeDetail({
    required this.id,
    required this.gatewayId,
    required this.code,
    required this.owner,
    required this.totalUsers,
    required this.active,
    required this.online,
    required this.telemetry,
    required this.statusPenggunaan,
  });

  factory NodeDetail.fromJson(Map<String, dynamic> json) {
    return NodeDetail(
      id: json['id'].toString(),
      gatewayId: json['gateway_id'].toString(),
      code: json['kode_node'] ?? '',
      owner: json['nama_pemilik'] ?? '',
      totalUsers: json['jumlah_penghuni'] ?? 0,
      active: (json['aktif'] ?? 0) == 1,
      online: (json['online'] ?? 0) == 1,
      telemetry: Telemetry.fromJson(json['telemetry']),
      statusPenggunaan: StatusPenggunaan.fromJson(
        json['status_penggunaan'],
      ),
    );
  }

  /// Shortcut supaya gampang dipakai di UI

  double get volume => telemetry.volume;

  double get flow => telemetry.flow;

  bool get valveOpen => telemetry.valveOpen;
}