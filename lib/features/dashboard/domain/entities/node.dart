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

  /// Total penggunaan air (m³) -- dari perhitungan lokal lama, bisa null
  /// kalau node baru terdeteksi (belum lengkap) atau data belum tersedia.
  final double waterUsageM3;

  /// Debit air tertinggi (L/min)
  final double peakFlow;

  /// Status valve
  final bool valveOpen;

  /// Kategori Hemat/Normal/Boros -- SUMBER RESMI dari backend
  /// (StatusPenggunaanService, sama persis dengan fetchKlasifikasi()).
  /// null kalau data belum cukup / node ini belum mengirim telemetri.
  final String? kategori;

  /// Flow rate TERKINI langsung dari ThingsBoard (bukan agregat bulanan).
  final String? flowTerkini;

  const Node({
    required this.id,
    required this.code,
    required this.online,
    required this.owner,
    required this.totalUsers,
    required this.waterUsageM3,
    required this.peakFlow,
    required this.valveOpen,
    this.kategori,
    this.flowTerkini,
  });

  /// Dipakai untuk endpoint LAMA (/gateways/{id}/nodes) -- dipertahankan
  /// untuk kompatibilitas kalau masih dipakai di tempat lain.
  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      id: json['id'].toString(), // lentur: terima int ataupun String
      code: json['code'] as String,
      online: json['online'] as bool,
      owner: json['owner'] as String,
      totalUsers: json['totalUsers'] as int,
      waterUsageM3: (json['waterUsageM3'] as num).toDouble(),
      peakFlow: (json['peakFlow'] as num).toDouble(),
      valveOpen: json['valveOpen'] as bool,
    );
  }

  /// Dipakai untuk endpoint BARU (/api/tb/gateways/{id}), bentuknya
  /// snake_case dan menyertakan telemetry + status_penggunaan bawaan
  /// ThingsBoard/StatusPenggunaanService -- INI yang jadi sumber kategori.
  factory Node.fromTbJson(Map<String, dynamic> json) {
    final telemetry = json['telemetry'] as Map<String, dynamic>?;
    final status = json['status_penggunaan'] as Map<String, dynamic>?;

    return Node(
      id: json['id'].toString(),
      code: json['kode_node']?.toString() ?? '-',
      online: json['online'] == 1 || json['online'] == true,
      owner: json['nama_pemilik']?.toString() ?? '(Belum diisi)',
      totalUsers: json['jumlah_penghuni'] ?? 0,
      // waterUsageM3/peakFlow dari cara lama sudah tidak dipakai lagi
      // di jalur ini -- konsumsi resmi ada di status?['konsumsi_liter'].
      waterUsageM3: 0,
      peakFlow: telemetry?['flow'] != null
          ? double.tryParse(telemetry!['flow'].toString()) ?? 0
          : 0,
      valveOpen: telemetry?['valve']?.toString() == '1',
      kategori: status?['kategori']?.toString(),
      flowTerkini: telemetry?['flow']?.toString(),
    );
  }

  /// Penggunaan normal per bulan dalam LITER (bukan m3) -- 1800 liter/
  /// orang/bulan, mengikuti standar yang sama dipakai backend
  /// (StatusPenggunaanService, ambang 1799/1851 liter per orang).
  /// Dipakai sebagai angka pembanding di UI selagi hasil resmi
  /// (Klasifikasi.konsumsiLiter) belum selesai dimuat.
  double get normalUsageLiter => totalUsers * 1800.0;

  /// @deprecated -- disisakan untuk kompatibilitas kode lama yang masih
  /// memakai satuan m3. Pakai normalUsageLiter untuk tampilan baru.
  double get normalUsageM3 => normalUsageLiter / 1000;

  /// @deprecated JANGAN dipakai lagi -- ini hitungan lokal yang bisa
  /// beda hasil dari backend (StatusPenggunaanService). Pakai `kategori`
  /// (dari Node.fromTbJson) atau hasil fetchKlasifikasi() sebagai gantinya.
  /// PENTING: dibandingkan dengan normalUsageM3 (bukan normalUsageLiter)
  /// karena waterUsageM3 memang bersatuan m3, bukan liter.
  String get usageStatus {
    final normal = normalUsageM3;
    final lower = normal * 0.9;
    final upper = normal * 1.1;

    if (waterUsageM3 < lower) return "HEMAT";
    if (waterUsageM3 > upper) return "BOROS";
    return "NORMAL";
  }
}
