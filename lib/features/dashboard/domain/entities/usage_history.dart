import 'package:amiflow/features/dashboard/domain/entities/chart_filter.dart';
import 'package:flutter/material.dart';

class UsageHistory {
  final DateTime date;
  final double usageLiter;

  const UsageHistory({
    required this.date,
    required this.usageLiter,
  });

  String get dayLabel {
    const days = [
      "Min",
      "Sen",
      "Sel",
      "Rab",
      "Kam",
      "Jum",
      "Sab",
    ];

    return days[date.weekday % 7];
  }

  String get fullDate {
    const months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];

    return "$dayLabel, ${date.day} ${months[date.month - 1]} ${date.year}";
  }

  String status(int totalUsers) {
    final batasHemat = totalUsers * 50;
    final batasBoros = totalUsers * 70;

    if (usageLiter <= batasHemat) {
      return "HEMAT";
    }

    if (usageLiter >= batasBoros) {
      return "BOROS";
    }

    return "NORMAL";
  }

  Color statusColor(int totalUsers) {
    switch (status(totalUsers)) {
      case "HEMAT":
        return Colors.greenAccent;

      case "BOROS":
        return Colors.redAccent;

      default:
        return Colors.orangeAccent;
    }
  }

  double contribution(double totalPeriode) {
    if (totalPeriode == 0) return 0;
    return (usageLiter / totalPeriode) * 100;
  }
}

/// ======================================================
/// Dummy Data Harian (7 hari)
/// ======================================================

final List<UsageHistory> dummyDailyUsage = [
  UsageHistory(date: DateTime(2026, 7, 21), usageLiter: 182),
  UsageHistory(date: DateTime(2026, 7, 22), usageLiter: 176),
  UsageHistory(date: DateTime(2026, 7, 23), usageLiter: 194),
  UsageHistory(date: DateTime(2026, 7, 24), usageLiter: 168),
  UsageHistory(date: DateTime(2026, 7, 25), usageLiter: 201),
  UsageHistory(date: DateTime(2026, 7, 26), usageLiter: 185),
  UsageHistory(date: DateTime(2026, 7, 27), usageLiter: 190),
];

/// ======================================================
/// Dummy Data Mingguan (4 minggu)
/// ======================================================

final List<UsageHistory> dummyWeeklyUsage = [
  UsageHistory(date: DateTime(2026, 7, 6), usageLiter: 1320),
  UsageHistory(date: DateTime(2026, 7, 13), usageLiter: 1410),
  UsageHistory(date: DateTime(2026, 7, 20), usageLiter: 1385),
  UsageHistory(date: DateTime(2026, 7, 27), usageLiter: 1498),
];

/// ======================================================
/// Dummy Data Bulanan (12 bulan)
/// ======================================================

final List<UsageHistory> dummyMonthlyUsage = [
  UsageHistory(date: DateTime(2026, 1, 1), usageLiter: 5200),
  UsageHistory(date: DateTime(2026, 2, 1), usageLiter: 5480),
  UsageHistory(date: DateTime(2026, 3, 1), usageLiter: 5100),
  UsageHistory(date: DateTime(2026, 4, 1), usageLiter: 5650),
  UsageHistory(date: DateTime(2026, 5, 1), usageLiter: 5400),
  UsageHistory(date: DateTime(2026, 6, 1), usageLiter: 5520),
  UsageHistory(date: DateTime(2026, 7, 1), usageLiter: 5380),
  UsageHistory(date: DateTime(2026, 8, 1), usageLiter: 5600),
  UsageHistory(date: DateTime(2026, 9, 1), usageLiter: 5450),
  UsageHistory(date: DateTime(2026, 10, 1), usageLiter: 5570),
  UsageHistory(date: DateTime(2026, 11, 1), usageLiter: 5490),
  UsageHistory(date: DateTime(2026, 12, 1), usageLiter: 5700),
];

/// ======================================================
/// SEMENTARA
/// Dipakai oleh chart yang belum dipindahkan.
/// Nanti akan dihapus ketika semua filter memakai UsageHistory.
/// ======================================================

final Map<ChartFilter, List<double>> dummyChartData = {
  ChartFilter.day: dummyDailyUsage.map((e) => e.usageLiter).toList(),
  ChartFilter.week: dummyWeeklyUsage.map((e) => e.usageLiter).toList(),
  ChartFilter.month: dummyMonthlyUsage.map((e) => e.usageLiter).toList(),
  ChartFilter.year: [
    62000,
    65800,
    64000,
    67200,
    68900,
    70150,
  ],
};

final Map<ChartFilter, double> dummyTotalUsage = {
  ChartFilter.day: dummyDailyUsage.fold(
    0,
    (sum, e) => sum + e.usageLiter,
  ),

  ChartFilter.week: dummyWeeklyUsage.fold(
    0,
    (sum, e) => sum + e.usageLiter,
  ),

  ChartFilter.month: dummyMonthlyUsage.fold(
    0,
    (sum, e) => sum + e.usageLiter,
  ),

  ChartFilter.year: 403050,
};

final Map<ChartFilter, List<String>> dummyChartLabels = {
  ChartFilter.day: dummyDailyUsage.map((e) => e.dayLabel).toList(),

  ChartFilter.week: [
    "M1",
    "M2",
    "M3",
    "M4",
  ],

  ChartFilter.month: [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "Mei",
    "Jun",
    "Jul",
    "Agu",
    "Sep",
    "Okt",
    "Nov",
    "Des",
  ],

  ChartFilter.year: [
    "2021",
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
  ],
};