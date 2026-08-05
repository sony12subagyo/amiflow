import 'telemetry.dart';

class Node {
  final String id;
  final String gatewayId;

  /// Kode node (NODE 01)
  final String code;

  /// Nama pemilik
  final String owner;

  /// Jumlah penghuni
  final int totalUsers;

  /// Status aktif
  final bool active;

  /// Status online
  final bool online;

  /// Data telemetry
  final Telemetry? telemetry;

  const Node({
    required this.id,
    required this.gatewayId,
    required this.code,
    required this.owner,
    required this.totalUsers,
    required this.active,
    required this.online,
    this.telemetry,
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      id: json['id'].toString(),

      gatewayId: json['gateway_id']?.toString() ?? '',

      code: json['kode_node'] ?? '',

      owner: json['nama_pemilik'] ?? 'Belum dikonfigurasi',

      totalUsers: json['jumlah_penghuni'] ?? 0,

      active: (json['aktif'] ?? 0) == 1,

      online: json['online'] == true,

      telemetry: json['telemetry'] != null
          ? Telemetry.fromJson(json['telemetry'])
          : null,
    );
  }

  /// ==========================
  /// Shortcut Telemetry
  /// ==========================

  double get waterUsageM3 => telemetry?.volume ?? 0;

  double get peakFlow => telemetry?.flow ?? 0;

  bool get valveOpen => telemetry?.valveOpen ?? false;

  /// ==========================
  /// Normal Usage
  /// ==========================

  double get normalUsageM3 {
    return (totalUsers * 1800) / 1000;
  }

  /// ==========================
  /// Status Penggunaan
  /// ==========================

  String get usageStatus {
    final normal = normalUsageM3;

    final lower = normal * 0.9;
    final upper = normal * 1.1;

    if (waterUsageM3 < lower) {
      return "HEMAT";
    }

    if (waterUsageM3 > upper) {
      return "BOROS";
    }

    return "NORMAL";
  }
}
