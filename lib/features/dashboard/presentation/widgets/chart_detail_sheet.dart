import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/dashboard/domain/entities/chart_filter.dart';
import 'package:amiflow/features/dashboard/domain/entities/usage_history.dart';

class ChartBottomSheet extends StatelessWidget {
  final UsageHistory history;

  /// Filter yang sedang dipilih
  final ChartFilter filter;

  /// Jumlah penghuni node
  final int totalUsers;

  /// Total penggunaan pada periode tersebut
  final double totalUsage;

  const ChartBottomSheet({
    super.key,
    required this.history,
    required this.filter,
    required this.totalUsers,
    required this.totalUsage,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = history.contribution(totalUsage);

    final status = history.status(totalUsers);

    final statusColor = history.statusColor(totalUsers);

    String title;

    switch (filter) {
      case ChartFilter.day:
        title = history.fullDate;
        break;

      case ChartFilter.week:
        title = history.fullDate;
        break;

      case ChartFilter.month:
        title = history.fullDate;
        break;

      case ChartFilter.year:
        title = history.fullDate;
        break;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Handle
            Container(
              width: 55,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            const SizedBox(height: 24),

            /// Judul
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _buildItem(
              Icons.pie_chart_outline,
              "Kontribusi",
              "${percentage.toStringAsFixed(1)} %",
            ),

            const SizedBox(height: 16),

            _buildItem(
              Icons.water_drop_outlined,
              "Penggunaan Air",
              "${history.usageLiter.toStringAsFixed(2)} Liter",
            ),

            const SizedBox(height: 16),

            // _buildItem(
            //   Icons.analytics_outlined,
            //   "Total Periode",
            //   "${totalUsage.toStringAsFixed(1)} Liter",
            // ),

            //const SizedBox(height: 16),

            _buildItem(Icons.circle, "Status", status, valueColor: statusColor),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
    IconData icon,
    String title,
    String value, {
    Color valueColor = AppColors.accent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),

          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
