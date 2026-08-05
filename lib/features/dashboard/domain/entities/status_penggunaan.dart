class StatusPenggunaan {
  final String status;
  final String? kategori;
  final String message;

  final int hariTerekam;
  final int hariDalamBulan;

  final double cakupanData;

  const StatusPenggunaan({
    required this.status,
    this.kategori,
    required this.message,
    required this.hariTerekam,
    required this.hariDalamBulan,
    required this.cakupanData,
  });

  factory StatusPenggunaan.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const StatusPenggunaan(
        status: '',
        kategori: null,
        message: '',
        hariTerekam: 0,
        hariDalamBulan: 0,
        cakupanData: 0,
      );
    }

    return StatusPenggunaan(
      status: json['status'] ?? '',
      kategori: json['kategori'],
      message: json['message'] ?? '',
      hariTerekam: json['hari_terekam'] ?? 0,
      hariDalamBulan: json['hari_dalam_bulan'] ?? 0,
      cakupanData:
          double.tryParse(json['cakupan_data'].toString()) ?? 0,
    );
  }
}