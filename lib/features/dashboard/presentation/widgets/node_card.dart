// lib/features/dashboard/presentation/widgets/node_card.dart

import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/dashboard/domain/entities/node.dart';
import 'package:flutter/material.dart';

class NodeCard extends StatelessWidget {
  final Node node;
  final VoidCallback? onTap;

  const NodeCard({super.key, required this.node, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: node.online
                ? AppColors.accent.withValues(alpha: 0.3)
                : Colors.white12,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: node.online
                        ? AppColors.accent.withValues(alpha: 0.1)
                        : Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.sensors,
                    color: node.online ? AppColors.accent : Colors.white54,
                  ),
                ),
              ],
            ),

            const Spacer(),

            Text(
              node.owner,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              node.code,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                // Icon(
                //   node.battery > 50
                //       ? Icons.battery_full
                //       : Icons.battery_alert,
                //   size: 18,
                //   color: node.online
                //       ? AppColors.accent
                //       : AppColors.offline,
                // ),
                const SizedBox(width: 4),

                Text(
                  node.online ? 'ONLINE' : 'OFFLINE',
                  style: TextStyle(
                    color: node.online ? Colors.white70 : AppColors.offline,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
