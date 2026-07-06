import 'package:amiflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GatewayHeader extends StatelessWidget {
  const GatewayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [

                Row(
                  children: [
                    Icon(
                      Icons.hub,
                      color: AppColors.accent,
                    ),
                    SizedBox(width: 8),

                    Text(
                      "AMIFLOW ADMIN",
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 6),

                Row(
                  children: [

                    CircleAvatar(
                      radius: 4,
                      backgroundColor: AppColors.online,
                    ),

                    SizedBox(width: 6),

                    Text(
                      "STM32 / LoRa Gateway Online",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.settings_input_antenna,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}