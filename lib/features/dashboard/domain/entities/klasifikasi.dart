// lib/features/dashboard/domain/entities/klasifikasi.dart

/// Hasil dari endpoint KlasifikasiController::hitung().
///
/// Backend bisa mengembalikan 3 bentuk respons berbeda:
/// - 400: data < 2 baris -> [kategori] null, field lain kosong
/// - 202: ML belum aktif (< 90% hari kalender data) -> [kategori] null,
///        [hariTerekam] terisi, field konsumsi/batas null
/// - 200: klasifikasi lengkap -> semua field terisi
class Klasifikasi {
  final String? kategori; // null selama belum bisa diklasifikasi
  final int hariTerekam;

  /// SATUAN LITER (bukan m3) -- backend mengirim key `konsumsi_liter`
  /// sejak ambang batas Hemat/Normal/Boros diubah ke satuan liter.
  final double? konsumsiLiter;
  final double? batasHemat;
  final double? batasBoros;
  final bool? relayDimatikan;
  final String message;

  const Klasifikasi({
    required this.kategori,
    required this.hariTerekam,
    required this.konsumsiLiter,
    required this.batasHemat,
    required this.batasBoros,
    required this.relayDimatikan,
    required this.message,
  });

  /// true selama data belum genap 30 hari kalender (respons 202).
  bool get mlBelumAktif => kategori == null && hariTerekam > 0;

  factory Klasifikasi.fromJson(Map<String, dynamic> json) {
    return Klasifikasi(
      kategori: json['kategori'] as String?,
      hariTerekam: (json['hari_terekam'] as num?)?.toInt() ?? 0,
      // Sebelumnya membaca 'konsumsi_m3' -- key itu SUDAH TIDAK ADA lagi
      // di respons backend (diganti 'konsumsi_liter'), sehingga field ini
      // selalu bernilai null tanpa disadari.
      konsumsiLiter: (json['konsumsi_liter'] as num?)?.toDouble(),
      batasHemat: (json['batas_hemat'] as num?)?.toDouble(),
      batasBoros: (json['batas_boros'] as num?)?.toDouble(),
      relayDimatikan: json['relay_dimatikan'] as bool?,
      message: json['message'] as String? ?? '',
    );
  }
}
