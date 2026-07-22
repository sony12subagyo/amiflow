import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/dashboard/domain/entities/usage_history.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final UsageHistory history;
  final int totalUsers;
  final double totalPeriode;

  const HistoryCard({
    super.key,
    required this.history,
    required this.totalUsers,
    required this.totalPeriode,
  });

  @override
  Widget build(BuildContext context) {
    final status = history.status(totalUsers);

    Color statusColor;

    switch (status) {
      case "HEMAT":
        statusColor = Colors.greenAccent;
        break;
      case "BOROS":
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = Colors.orangeAccent;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            history.fullDate,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          _buildRow(
            "Kontribusi",
            "${history.contribution(totalPeriode).toStringAsFixed(1)} %",
          ),

          const SizedBox(height: 10),

          _buildRow(
            "Penggunaan Air",
            "${history.usageLiter.toStringAsFixed(0)} L",
          ),

          const SizedBox(height: 10),

          _buildRow(
            "Status Harian",
            status,
            valueColor: statusColor,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String title,
    String value, {
    Color valueColor = Colors.white,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white60),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}