// lib/core/navigation/bottom_nav.dart
import 'package:flutter/material.dart';
import 'nav_item.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  static const _barColor = Color(0xFF1C1C1E);          // pill gelap
  static const _activeColor = Color.fromARGB(255, 0, 128, 255); // biru app
  static const _inactiveColor = Color(0xFF8E8E93);     // abu-abu

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        // jarak pill dari tepi layar — ini yang bikin "mengambang"
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: _barColor,
            borderRadius: BorderRadius.circular(30), // setengah tinggi = pill penuh
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 6)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                icon: Icons.home,
                isActive: currentIndex == 0,
                activeColor: _activeColor,
                inactiveColor: _inactiveColor,
                onTap: () => onTap(0),
              ),
              NavItem(
                icon: Icons.search,
                isActive: currentIndex == 1,
                activeColor: _activeColor,
                inactiveColor: _inactiveColor,
                onTap: () => onTap(1),
              ),
              NavItem(
                icon: Icons.person,
                isActive: currentIndex == 2,
                activeColor: _activeColor,
                inactiveColor: _inactiveColor,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}