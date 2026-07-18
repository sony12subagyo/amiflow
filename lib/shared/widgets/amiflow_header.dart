// lib/shared/widgets/amiflow_header.dart
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';

class AmiflowHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final int notificationCount;
  final bool showNotification;

  const AmiflowHeader({
    super.key,
    this.onNotificationTap,
    this.notificationCount = 5,
    this.showNotification = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.hub, color: AppColors.accent),
                    SizedBox(width: 8),
                    Text(
                      'AMIFLOW ADMIN',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 6),
                // Row(
                //   children: [
                //     CircleAvatar(radius: 4, backgroundColor: AppColors.online),
                //     SizedBox(width: 6),
                //     Text(
                //       'STM32 / LoRa Gateway Online',
                //       style: TextStyle(color: Colors.white70, fontSize: 11),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          if (showNotification)
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    splashRadius: 24,
                    onPressed: onNotificationTap,
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),

                if (notificationCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xffFF4D4F),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surface,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          notificationCount > 9 ? "9+" : "$notificationCount",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
