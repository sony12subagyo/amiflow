// lib/features/dashboard/presentation/widgets/add_node_card.dart
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddNodeCard extends StatelessWidget {
  final VoidCallback? onTap;
  const AddNodeCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(backgroundColor: AppColors.surfaceLight, child: Icon(Icons.add)),
            SizedBox(height: 10),
            Text(
              'ADD NODE',
              style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}