// lib/core/navigation/bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';
import 'nav_item.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NavItem(
              icon: Icons.grid_view,
              isActive: currentIndex == 0,
              activeColor: AppColors.accent,
              inactiveColor: Colors.white70,
              onTap: () => onTap(0),
            ),
            NavItem(
              icon: Icons.account_circle,
              isActive: currentIndex == 1,
              activeColor: AppColors.accent,
              inactiveColor: Colors.white70,
              onTap: () => onTap(1),
            ),
          ],
        ),
      ),
    );
  }
}
