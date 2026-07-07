// lib/features/dashboard/domain/entities/node.dart

class Node {
  final String id;

  /// ID LoRa / Device
  final String code;

  /// Status koneksi node
  final bool online;

  /// Nama pemilik
  final String owner;

  /// Jumlah pengguna air
  final int totalUsers;

  /// Total penggunaan air (m³)
  final double waterUsageM3;

  /// Debit air tertinggi (L/min)
  final double peakFlow;

  /// Status valve
  final bool valveOpen;

  const Node({
    required this.id,
    required this.code,
    required this.online,
    required this.owner,
    required this.totalUsers,
    required this.waterUsageM3,
    required this.peakFlow,
    required this.valveOpen,
  });

  /// ============================================
  /// Penggunaan normal air
  ///
  /// Standar:
  /// 1 orang = 60 Liter/hari
  /// 1000 Liter = 1 m³
  /// ============================================

  double get normalUsageM3 {
    return (totalUsers * 60) / 1000;
  }

  /// ============================================
  /// Status penggunaan air
  ///
  /// Hemat
  /// Normal
  /// Boros
  /// ============================================

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