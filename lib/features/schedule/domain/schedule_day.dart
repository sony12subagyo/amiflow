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

  /// Total menit Open Time
  int? get openMinutes {
    if (startTime == null) return null;

    final parts = startTime!.split(":");

    return int.parse(parts[0]) * 60 +
        int.parse(parts[1]);
  }

  /// Total menit Close Time
  int? get closeMinutes {
    if (endTime == null) return null;

    final parts = endTime!.split(":");

    return int.parse(parts[0]) * 60 +
        int.parse(parts[1]);
  }

  /// Apakah Close Time berada di hari berikutnya
  bool get isNextDay {
    if (openMinutes == null || closeMinutes == null) {
      return false;
    }

    return closeMinutes! <= openMinutes!;
  }

  /// Apakah valve berjalan 24 jam
  bool get isTwentyFourHours {
    if (openMinutes == null || closeMinutes == null) {
      return false;
    }

    return openMinutes == closeMinutes;
  }
}