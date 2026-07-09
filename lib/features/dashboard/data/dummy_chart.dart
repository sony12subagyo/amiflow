import 'package:amiflow/features/dashboard/domain/entities/chart_filter.dart';

final Map<ChartFilter, List<double>> dummyChartData = {
  ChartFilter.day: [
  18,
  22,
  16,
  27,
  21,
  30,
  24,
],

  ChartFilter.week: [
  145,
  182,
  165,
  201,
],

  ChartFilter.month: [
  180,
  210,
  230,
  260,
  245,
  220,
  240,
  255,
  235,
  210,
  225,
  250,
],

  ChartFilter.year: [
  980,
  1120,
  1080,
  1250,
  1340,
  1415,
],
};

/// Total penggunaan sesuai filter
final Map<ChartFilter, double> dummyTotalUsage = {
  ChartFilter.day: 0.32,
  ChartFilter.week: 2.15,
  ChartFilter.month: 8.74,
  ChartFilter.year: 96.82,
};

final Map<ChartFilter, List<String>> dummyChartLabels = {

  ChartFilter.day: [
    "Sen",
    "Sel",
    "Rab",
    "Kam",
    "Jum",
    "Sab",
    "Min",
  ],

  ChartFilter.week: [
    "W1",
    "W2",
    "W3",
    "W4",
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
