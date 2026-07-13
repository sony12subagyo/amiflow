import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/schedule/domain/schedule_result.dart';
// import 'package:amiflow/features/schedule/presentation/widgets/schedule_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ScheduleDialog extends StatefulWidget {
  final String day;
  final String? startTime;
  final String? endTime;

  const ScheduleDialog({
    super.key,
    required this.day,
    this.startTime,
    this.endTime,
  });

  @override
  State<ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  late TimeOfDay openTime;
  late TimeOfDay closeTime;
  bool enabled = false;
  bool applyAllDays = false;

  @override
  void initState() {
    super.initState();

    openTime = _parseTime(widget.startTime ?? "06:00");
    closeTime = _parseTime(widget.endTime ?? "18:30");
    enabled = widget.startTime != null && widget.endTime != null;
  }

  TimeOfDay _parseTime(String value) {
    final split = value.split(":");

    return TimeOfDay(hour: int.parse(split[0]), minute: int.parse(split[1]));
  }

  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, "0");
    final m = time.minute.toString().padLeft(2, "0");

    return "$h:$m";
  }

  Future<TimeOfDay?> _showCupertinoTimePicker(TimeOfDay initialTime) async {
    int selectedHour = initialTime.hour;
    int selectedMinute = initialTime.minute;

    return await showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (_) {
        return Container(
          height: 470,
          decoration: const BoxDecoration(
            color: Color(0xff1F2024),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),

              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 10),

              Divider(color: Colors.white10, indent: 20, endIndent: 20),

              const SizedBox(height: 12),

              const Text(
                "Pilih Waktu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
              ),

              Expanded(
                child: Row(
                  children: [
                    /// JAM
                    Expanded(
                      child: CupertinoPicker.builder(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedHour,
                        ),

                        itemExtent: 55,

                        diameterRatio: 1.3,

                        squeeze: 1.15,

                        useMagnifier: true,

                        magnification: 1.15,

                        selectionOverlay: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.accent.withOpacity(.35),
                            ),
                          ),
                        ),

                        childCount: 24,

                        onSelectedItemChanged: (value) {
                          selectedHour = value;
                        },

                        itemBuilder: (_, index) {
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, "0"),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Container(
                      alignment: Alignment.center,
                      width: 40,
                      child: const Text(
                        ":",
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),

                    /// MENIT
                    Expanded(
                      child: CupertinoPicker.builder(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedMinute,
                        ),
                        itemExtent: 55,
                        diameterRatio: 1.3,
                        squeeze: 1.15,
                        useMagnifier: true,
                        magnification: 1.15,
                        selectionOverlay: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.accent.withOpacity(.35),
                            ),
                          ),
                        ),

                        childCount: 60,

                        onSelectedItemChanged: (value) {
                          selectedMinute = value;
                        },

                        itemBuilder: (_, index) {
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, "0"),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff42454A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            TimeOfDay(
                              hour: selectedHour,
                              minute: selectedMinute,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Pilih",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _toMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  Duration get activeDuration {
    final open = _toMinutes(openTime);
    final close = _toMinutes(closeTime);

    // Same Day
    if (close > open) {
      return Duration(minutes: close - open);
    }

    // Cross Day & 24 Hours
    return Duration(minutes: (24 * 60 - open) + close);
  }

  String get activeDurationText {
    final duration = activeDuration;

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours == 24 && minutes == 0) {
      return "24 jam";
    }

    if (minutes == 0) {
      return "$hours jam";
    }

    return "$hours jam $minutes menit";
  }

  bool get isNextDay {
    return _toMinutes(closeTime) <= _toMinutes(openTime);
  }

  bool get isFullDay {
    return _toMinutes(closeTime) == _toMinutes(openTime);
  }

  Future<void> _selectOpenTime() async {
    final picked = await _showCupertinoTimePicker(openTime);

    if (picked != null) {
      setState(() {
        openTime = picked;
      });
    }
  }

  Future<void> _selectCloseTime() async {
    final picked = await _showCupertinoTimePicker(closeTime);

    if (picked != null) {
      setState(() {
        closeTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,

      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.schedule, color: AppColors.accent),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Atur Jadwal",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      Text(
                        widget.day,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            _timeField(
              title: "Waktu Buka",
              value: _formatTime(openTime),
              onTap: _selectOpenTime,
            ),

            const SizedBox(height: 18),

            _timeField(
              title: "Waktu Tutup",
              value: _formatTime(closeTime),
              onTap: _selectCloseTime,
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Aktifkan Jadwal",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Switch(
                  value: enabled,
                  activeColor: AppColors.accent,
                  onChanged: (value) {
                    setState(() {
                      enabled = value;
                    });
                  },
                ),
              ],
            ),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Terapkan ke semua hari?",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Switch(
                  value: applyAllDays,
                  activeColor: AppColors.accent,
                  onChanged: (value) {
                    setState(() {
                      applyAllDays = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff42454A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final result = ScheduleResult(
                          startTime: _formatTime(openTime),
                          endTime: _formatTime(closeTime),
                          enabled: enabled,
                          applyAllDays: applyAllDays,
                        );
                        Future.delayed(const Duration(milliseconds: 900), () {
                          if (!mounted) return;

                          Navigator.pop(context, result);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeField({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),

        const SizedBox(height: 8),

        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const Spacer(),

                const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
