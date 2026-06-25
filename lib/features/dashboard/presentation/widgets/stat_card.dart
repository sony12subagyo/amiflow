// lib/features/dashboard/presentation/widgets/stat_card.dart
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 11)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}