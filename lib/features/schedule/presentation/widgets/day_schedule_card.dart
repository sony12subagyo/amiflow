import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';

class DayScheduleCard extends StatelessWidget {
  final String day;
  final String? startTime;
  final String? endTime;

  /// Status apakah schedule diaktifkan
  final bool enabled;
  final bool globalOverride;
  final VoidCallback onTap;

  const DayScheduleCard({
    super.key,
    required this.day,
    required this.enabled,
    required this.globalOverride,
    required this.onTap,
    this.startTime,
    this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: !enabled
                  ? Colors.white10
                  : globalOverride
                  ? Colors.amber
                  : AppColors.accent.withOpacity(.7),
              width: 1.3,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            day,
                            style: TextStyle(
                              color: enabled
                                  ? AppColors.accent
                                  : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        if (enabled)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: globalOverride
                                  ? Colors.orange.withOpacity(.18)
                                  : Colors.green.withOpacity(.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              globalOverride ? "Jeda" : "Aktif",
                              style: TextStyle(
                                color: globalOverride
                                    ? Colors.orange
                                    : Colors.greenAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .8,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    if (enabled && startTime != null && endTime != null)
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 4,
                            backgroundColor: AppColors.accent,
                          ),

                          const SizedBox(width: 8),

                          Text(
                            "$startTime - $endTime",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    else
                      const Row(
                        children: [
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.white24,
                          ),

                          SizedBox(width: 8),

                          Text(
                            "Tidak ada jadwal",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right_rounded, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}
