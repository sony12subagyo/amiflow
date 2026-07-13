import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/schedule/data/dummy_schedule.dart';
import 'package:amiflow/features/schedule/domain/schedule_day.dart';
import 'package:amiflow/features/schedule/domain/schedule_result.dart';
import 'package:amiflow/features/schedule/presentation/schedule_dialog.dart';
import 'package:amiflow/features/schedule/presentation/widgets/day_schedule_card.dart';
import 'package:amiflow/features/schedule/presentation/widgets/global_override_switch.dart';
import 'package:amiflow/features/schedule/presentation/widgets/schedule_toast.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late List<ScheduleDay> schedules;
  bool globalOverride = false;
  int _toMinutes(String time) {
    final parts = time.split(":");

    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  String _durationText(String start, String end) {
    final open = _toMinutes(start);
    final close = _toMinutes(end);

    int minutes;

    if (close > open) {
      minutes = close - open;
    } else if (close == open) {
      minutes = 24 * 60;
    } else {
      minutes = (24 * 60 - open) + close;
    }

    final hour = minutes ~/ 60;
    final minute = minutes % 60;

    if (minute == 0) {
      return "$hour jam";
    }

    return "$hour jam $minute menit";
  }

  bool _isNextDay(String start, String end) {
    return _toMinutes(end) <= _toMinutes(start);
  }

  @override
  void initState() {
    super.initState();

    schedules = List.from(dummySchedules);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),

                  const Text(
                    "AMIFLOW",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const Spacer(),

                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.refresh, color: Colors.white70),
                  // ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const Text(
                    "Jadwal Valve",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Konfigurasikan rutinitas aliran otomatis mingguan.",
                    style: TextStyle(color: Colors.white54),
                  ),

                  const SizedBox(height: 24),

                  ...schedules.asMap().entries.map((entry) {
                    final index = entry.key;
                    final schedule = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DayScheduleCard(
                        day: schedule.day,
                        enabled: schedule.enabled,
                        globalOverride: globalOverride,
                        startTime: schedule.startTime,
                        endTime: schedule.endTime,

                        onTap: () async {
                          final ScheduleResult? result =
                              await showDialog<ScheduleResult>(
                                context: context,
                                builder: (_) => ScheduleDialog(
                                  day: schedule.day,
                                  startTime: schedule.startTime,
                                  endTime: schedule.endTime,
                                ),
                              );
                          if (result != null) {
                            setState(() {
                              if (result.applyAllDays) {
                                for (final item in schedules) {
                                  item.enabled = result.enabled;

                                  item.startTime = result.enabled
                                      ? result.startTime
                                      : null;

                                  item.endTime = result.enabled
                                      ? result.endTime
                                      : null;
                                }
                              } else {
                                schedule.enabled = result.enabled;

                                schedule.startTime = result.enabled
                                    ? result.startTime
                                    : null;

                                schedule.endTime = result.enabled
                                    ? result.endTime
                                    : null;
                              }
                            });

                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (!mounted) return;

                              if (result.enabled) {
                                final duration = _durationText(
                                  result.startTime,
                                  result.endTime,
                                );

                                ScheduleToast.show(
                                  context,
                                  message: "Valve aktif selama $duration",
                                );
                              } else {
                                ScheduleToast.show(
                                  context,
                                  message:
                                      "Jadwal ${schedule.day} berhasil dinonaktifkan",
                                );
                              }
                            });
                          }
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 20),
                  GlobalOverrideSwitch(
                    value: globalOverride,
                    onChanged: (value) {
                      setState(() {
                        globalOverride = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
