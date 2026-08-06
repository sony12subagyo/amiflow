import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/dashboard/domain/entities/chart_filter.dart';

class UsageChart extends StatelessWidget {
  final ChartFilter selectedFilter;
  final List<double> data;
  final List<String> labels;

  /// Callback ketika user memilih filter
  final ValueChanged<ChartFilter> onFilterChanged;

  /// Callback ketika user menekan salah satu bar chart
  final ValueChanged<int>? onBarTap;

  const UsageChart({
    super.key,
    required this.selectedFilter,
    required this.data,
    required this.labels,
    required this.onFilterChanged,
    this.onBarTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = data.isNotEmpty;

    // PENTING: cek data kosong SAJA tidak cukup -- kalau ada 7 baris data
    // tapi SEMUA nilainya 0 (node belum ada pemakaian tercatat), maxValue
    // jadi 0, lalu (value/maxValue) = 0/0 = NaN -> crash "BoxConstraints
    // has NaN values". Jadi maxValue dipaksa minimal 1.
    final rawMax = hasData ? data.reduce((a, b) => a > b ? a : b) : 0.0;
    final maxValue = rawMax > 0 ? rawMax : 1.0;
    return Column(
      children: [
        /// ================= FILTER =================
        Container(
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _buildFilterButton("Hari", ChartFilter.day),

              _buildFilterButton("Minggu", ChartFilter.week),

              _buildFilterButton("Bulan", ChartFilter.month),

              _buildFilterButton("Tahun", ChartFilter.year),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// =================BAGIAN BATANG CHART =================
        SizedBox(
          height: 200,
          child: Row(
            children: [
              // _buildYAxis(maxValue),
              const SizedBox(width: 8),
              Expanded(
                child: !hasData
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bar_chart_rounded,
                              color: Colors.white24,
                              size: 70,
                            ),

                            SizedBox(height: 12),

                            Text(
                              _getEmptyTitle(),
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              _getEmptySubtitle(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final barWidth = constraints.maxWidth / 7;

                          return Scrollbar(
                            thumbVisibility: true,
                            trackVisibility: true,

                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),

                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: data.length * barWidth,
                                  child: Stack(
                                    children: [
                                      _buildGrid(data.length * barWidth),

                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,

                                        children: List.generate(data.length, (
                                          index,
                                        ) {
                                          final value = data[index];

                                          return SizedBox(
                                            width: barWidth,
                                            child: GestureDetector(
                                              onTap: () {
                                                onBarTap?.call(index);
                                              },

                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,

                                                      child: AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                              milliseconds: 250,
                                                            ),

                                                        margin:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 2,
                                                            ),

                                                        height:
                                                            (value / maxValue) *
                                                            160,

                                                        decoration: BoxDecoration(
                                                          color: AppColors
                                                              .accent
                                                              .withOpacity(.85),

                                                          borderRadius:
                                                              const BorderRadius.vertical(
                                                                top:
                                                                    Radius.circular(
                                                                      4,
                                                                    ),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(height: 12),

                                                  Text(
                                                    labels[index],

                                                    style: const TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================ BAGIAN GRID =================
  Widget _buildGrid(double width) {
    return SizedBox(
      width: width,
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 13),
          child: Column(
            children: List.generate(
              6,
              (index) => Expanded(
                child: Center(
                  child: Container(
                    height: 1,
                    color: Colors.white.withOpacity(.06),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= BAGIAN Y-AXIS =================
  Widget _buildYAxis(double maxValue) {
    final step = maxValue / 5;

    return SizedBox(
      width: 40,
      child: Column(
        children: List.generate(6, (index) {
          final value = maxValue - (step * index);

          return Expanded(
            child: Center(
              child: Text(
                value.toStringAsFixed(0),
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ================ BAGIAN FILTER =================
  Widget _buildFilterButton(String text, ChartFilter filter) {
    final selected = selectedFilter == filter;

    return Expanded(
      child: GestureDetector(
        onTap: () => onFilterChanged(filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.black : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getEmptyTitle() {
    switch (selectedFilter) {
      case ChartFilter.day:
        return "Belum ada riwayat harian";
      case ChartFilter.week:
        return "Belum ada riwayat mingguan";
      case ChartFilter.month:
        return "Belum ada riwayat bulanan";
      case ChartFilter.year:
        return "Belum ada riwayat tahunan";
    }
  }

  String _getEmptySubtitle() {
    switch (selectedFilter) {
      case ChartFilter.day:
        return "Data akan muncul ketika telemetry harian tersedia.";
      case ChartFilter.week:
        return "Data akan muncul setelah penggunaan mencakup minimal satu minggu.";
      case ChartFilter.month:
        return "Data akan muncul setelah penggunaan mencakup minimal satu bulan.";
      case ChartFilter.year:
        return "Data akan muncul setelah penggunaan mencakup minimal satu tahun.";
    }
  }
}
