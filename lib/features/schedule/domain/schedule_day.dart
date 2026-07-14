class ScheduleDay {
  final String day;

  bool active;
  bool enabled;
  String? startTime;
  String? endTime;

  ScheduleDay({
    required this.day,
    this.active = false,
    this.enabled = false,
    this.startTime,
    this.endTime,
  });

  factory ScheduleDay.fromJson(Map<String, dynamic> json) {
    return ScheduleDay(
      day: json['hari'] as String,
      enabled:
          json['aktif'] == 1 || json['aktif'] == true, // terima 1 atau true
      startTime: _potongDetik(json['jam_buka']), // "06:00:00" -> "06:00"
      endTime: _potongDetik(json['jam_tutup']),
    );
  }

  // Membuang detik dari format jam: "06:00:00" -> "06:00"
  static String? _potongDetik(dynamic waktu) {
    if (waktu == null) return null;
    final s = waktu.toString();
    // ambil 5 karakter pertama (HH:MM) jika formatnya HH:MM:SS
    return s.length >= 5 ? s.substring(0, 5) : s;
  }
}
