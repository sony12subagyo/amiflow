import 'package:amiflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GatewayBanner extends StatelessWidget {
  const GatewayBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  "Pilih Gateway Untuk Memantau Node IoT",
                  style: TextStyle(
                    color: AppColors.accentSoft,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "Select one gateway to monitor\nconnected IoT nodes.",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.settings_input_antenna,
              size: 34,
              color: Colors.white24,
            ),
          ),
        ],
      ),
    );
  }
}