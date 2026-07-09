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
              _buildYAxis(),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  children: [
                    _buildGrid(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: List.generate(data.length, (index) {
                        final value = data[index];

                        final maxValue = data.reduce((a, b) => a > b ? a : b);

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              onBarTap?.call(index);
                            },

                            child: Column(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,

                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),

                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),

                                      height: (value / maxValue) * 160,

                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withOpacity(
                                          .85,
                                        ),

                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(4),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 6),

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
            ],
          ),
        ),
      ],
    );
  }

  // ================ BAGIAN GRID =================
  Widget _buildGrid() {
    return IgnorePointer(
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
    );
  }

  // ================= BAGIAN Y-AXIS =================
  Widget _buildYAxis() {
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final step = (maxValue / 5);
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
}
