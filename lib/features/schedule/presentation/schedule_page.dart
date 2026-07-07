import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/schedule/data/dummy_schedule.dart';
import 'package:amiflow/features/schedule/domain/schedule_day.dart';
import 'package:amiflow/features/schedule/domain/schedule_result.dart';
import 'package:amiflow/features/schedule/presentation/schedule_dialog.dart';
import 'package:amiflow/features/schedule/presentation/widgets/day_schedule_card.dart';
import 'package:amiflow/features/schedule/presentation/widgets/global%20override_switch.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late List<ScheduleDay> schedules;
  bool globalOverride = false;

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
                    "Valve Schedule",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Configure weekly automated flow routines.",
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
