// lib/features/dashboard/presentation/widgets/usage_chart.dart
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';

class UsageChart extends StatelessWidget {
  final List<double> data;
  const UsageChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((value) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: value * 1.5,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(value / 100),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}