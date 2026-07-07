class ScheduleResult {
  final String startTime;
  final String endTime;

  /// apakah schedule diaktifkan
  final bool enabled;

  /// apakah diterapkan ke semua hari
  final bool applyAllDays;

  const ScheduleResult({
    required this.startTime,
    required this.endTime,
    required this.enabled,
    required this.applyAllDays,
  });
}