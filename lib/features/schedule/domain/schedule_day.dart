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
}