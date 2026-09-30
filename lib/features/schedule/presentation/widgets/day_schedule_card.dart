import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';

class DayScheduleCard extends StatelessWidget {
  final String day;
  final String? startTime;
  final String? endTime;

  /// Status apakah schedule diaktifkan
  final bool enabled;

  /// Apakah `day` ini adalah hari berjalan sekarang -- HANYA jadwal hari
  /// ini yang benar-benar sedang aktif mengontrol device (lihat
  /// App\Console\Commands\PushJadwalHarian di backend). Hari lain yang
  /// enabled=true statusnya baru "terjadwal", belum diterapkan ke alat.
  final bool isToday;

  final VoidCallback onTap;

  const DayScheduleCard({
    super.key,
    required this.day,
    required this.enabled,
    required this.onTap,
    this.startTime,
    this.endTime,
    this.isToday = false,
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
              color: isToday
                  ? AppColors.accent
                  : !enabled
                  ? Colors.white10
                  : AppColors.accent.withOpacity(.7),
              width: isToday ? 1.8 : 1.3,
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
                          child: Row(
                            children: [
                              Text(
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
                              if (isToday) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withOpacity(.18),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "HARI INI",
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .8,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        if (enabled)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              // Cuma jadwal hari ini yang benar-benar
                              // sedang jalan di device; hari lain yang
                              // enabled cuma "terjadwal" nunggu giliran.
                              isToday ? "Aktif" : "Terjadwal",
                              style: const TextStyle(
                                color: Colors.greenAccent,
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
