import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/dashboard/domain/entities/chart_filter.dart';
import 'package:amiflow/features/dashboard/domain/entities/usage_history.dart';

class ChartBottomSheet extends StatelessWidget {
  final UsageHistory history;
  final ChartFilter filter;
  final int totalUsers;
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

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Handle
            Container(
              width: 70,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              _title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              _subtitle,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 24),

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

            _buildItem(
              _statusIcon(status),
              "Status",
              status,
              valueColor: statusColor,
            ),
          ],
        ),
      ),
    );
  }

  ///========================
  /// Title
  ///========================

  String get _title {
    switch (filter) {
      case ChartFilter.day:
        return history.fullDate;

      case ChartFilter.week:
        return history.fullDate; // nanti diganti Minggu ke-x

      case ChartFilter.month:
        return history.fullDate; // nanti diganti Juli 2026

      case ChartFilter.year:
        return history.fullDate;
    }
  }

  ///========================
  /// Subtitle
  ///========================

  String get _subtitle {
    switch (filter) {
      case ChartFilter.day:
        return "Ringkasan Penggunaan Harian";

      case ChartFilter.week:
        return "Ringkasan Penggunaan Mingguan";

      case ChartFilter.month:
        return "Ringkasan Penggunaan Bulanan";

      case ChartFilter.year:
        return "Ringkasan Penggunaan Tahunan";
    }
  }

  ///========================
  /// Status Icon
  ///========================

  IconData _statusIcon(String status) {
    switch (status) {
      case "HEMAT":
        return Icons.eco_outlined;

      case "BOROS":
        return Icons.warning_amber_rounded;

      default:
        return Icons.check_circle_outline;
    }
  }

  Widget _buildItem(
    IconData icon,
    String title,
    String value, {
    Color valueColor = AppColors.accent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.accent,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
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