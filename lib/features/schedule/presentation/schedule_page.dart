import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/schedule/data/schedule_api.dart';
import 'package:amiflow/features/schedule/domain/schedule_day.dart';
import 'package:amiflow/features/schedule/domain/schedule_result.dart';
import 'package:amiflow/features/schedule/presentation/schedule_dialog.dart';
import 'package:amiflow/features/schedule/presentation/widgets/day_schedule_card.dart';
import 'package:amiflow/features/schedule/presentation/widgets/global%20override_switch.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  final String nodeId;

  const SchedulePage({super.key, required this.nodeId});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final ScheduleApi _api = ScheduleApi();
  List<ScheduleDay> schedules = [];
  bool globalOverride = false;

  bool _loading = true; // <-- BARU
  String? _error;
  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final dataServer = await _api.fetchSchedules(widget.nodeId);

      // Mulai dengan 7 hari kosong
      final hariList = [
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
        'Minggu',
      ];
      final lengkap = hariList.map((namaHari) {
        // cari apakah hari ini ada di data server
        final adaDiServer = dataServer.where((s) => s.day == namaHari);
        if (adaDiServer.isNotEmpty) {
          return adaDiServer.first; // pakai data dari server
        }
        return ScheduleDay(day: namaHari); // default: nonaktif
      }).toList();

      setState(() {
        schedules = lengkap;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat jadwal. Cek koneksi / ngrok.';
        _loading = false;
      });
    }
  }

  Future<void> _simpanKeServer(
    ScheduleResult result,
    ScheduleDay schedule,
  ) async {
    try {
      if (result.applyAllDays) {
        // kirim untuk semua hari
        for (final item in schedules) {
          await _api.saveSchedule(
            nodeId: widget.nodeId,
            hari: item.day,
            aktif: item.enabled,
            jamBuka: item.startTime,
            jamTutup: item.endTime,
          );
        }
      } else {
        // kirim satu hari yang diubah
        await _api.saveSchedule(
          nodeId: widget.nodeId,
          hari: schedule.day,
          aktif: schedule.enabled,
          jamBuka: schedule.startTime,
          jamTutup: schedule.endTime,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Jadwal tersimpan')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan jadwal ke server')),
      );
    }
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
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_error!, textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _loadSchedules,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    )
                  : ListView(
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
                                  // 1) Perbarui tampilan lokal (seperti semula)
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

                                  // 2) Kirim perubahan ke server
                                  await _simpanKeServer(result, schedule);
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
