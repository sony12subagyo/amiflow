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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surface,                    // senada kartu dashboard
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                icon: Icons.grid_view,                   // Dashboard
                isActive: currentIndex == 0,
                activeColor: AppColors.accent,
                inactiveColor: Colors.white70,
                onTap: () => onTap(0),
              ),
              NavItem(
                icon: Icons.delete_sweep,                // Manage
                isActive: currentIndex == 1,
                activeColor: AppColors.accent,
                inactiveColor: Colors.white70,
                onTap: () => onTap(1),
              ),
              NavItem(
                icon: Icons.account_circle,              // Profile
                isActive: currentIndex == 2,
                activeColor: AppColors.accent,
                inactiveColor: Colors.white70,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}