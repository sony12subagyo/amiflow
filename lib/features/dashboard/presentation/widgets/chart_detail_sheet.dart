import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';

class ChartBottomSheet extends StatelessWidget {
  final String title;
  final double usage;
  final double totalUsage;

  const ChartBottomSheet({
    super.key,
    required this.title,
    required this.usage,
    required this.totalUsage,
  });

  @override
  Widget build(BuildContext context) {
    final percentage =
        totalUsage == 0 ? 0 : (usage / totalUsage) * 100;

    final isWaste = percentage >= 25;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),

      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 28),

            _buildItem(
              Icons.water_drop_outlined,
              "Penggunaan Air",
              "${usage.toStringAsFixed(2)} m³",
            ),

            const SizedBox(height: 16),

            _buildItem(
              Icons.pie_chart_outline,
              "Kontribusi",
              "${percentage.toStringAsFixed(1)} %",
            ),

            const SizedBox(height: 16),

            _buildItem(
              Icons.analytics_outlined,
              "Total Periode",
              "${totalUsage.toStringAsFixed(2)} m³",
            ),

            const SizedBox(height: 16),

            _buildItem(
              isWaste
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle_outline,
              "Status",
              isWaste ? "BOROS" : "NORMAL",
              valueColor:
                  isWaste ? Colors.redAccent : Colors.greenAccent,
            ),

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