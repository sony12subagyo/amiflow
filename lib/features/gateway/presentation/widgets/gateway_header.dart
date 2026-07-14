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
              ],
            ),
          ),
        ],
      ),
    );
  }
}