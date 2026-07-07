import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/schedule/domain/schedule_result.dart';
import 'package:flutter/material.dart';

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

  Future<void> _selectOpenTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: openTime,
    );

    if (picked != null) {
      setState(() {
        openTime = picked;
      });
    }
  }

  Future<void> _selectCloseTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: closeTime,
    );

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
                        "Set Schedule",
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
              title: "Open Time",
              value: _formatTime(openTime),
              onTap: _selectOpenTime,
            ),

            const SizedBox(height: 18),

            _timeField(
              title: "Close Time",
              value: _formatTime(closeTime),
              onTap: _selectCloseTime,
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Enable Schedule",
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
                    "Apply to all days?",
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
                        "CANCEL",
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

                        Navigator.pop(context, result);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "SAVE",
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
