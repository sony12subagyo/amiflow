// lib/features/gateway/presentation/widgets/gateway_card.dart
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/gateway/domain/entities/gateway.dart';
import 'package:flutter/material.dart';

class GatewayCard extends StatelessWidget {
  final Gateway gateway;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const GatewayCard({
    super.key,
    required this.gateway,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: gateway.isSelected
                ? AppColors.accent
                : Colors.white12,
            width: gateway.isSelected ? 1.6 : 1,
          ),
          boxShadow: gateway.isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: gateway.isSelected
                        ? AppColors.accent.withValues(alpha: 0.15)
                        : Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.router,
                    color: gateway.isSelected
                        ? AppColors.accent
                        : Colors.white70,
                    size: 20,
                  ),
                ),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.white38,
                    size: 20,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              gateway.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              gateway.gatewayCode,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}