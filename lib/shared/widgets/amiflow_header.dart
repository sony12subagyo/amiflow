// lib/shared/widgets/amiflow_header.dart
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';

class AmiflowHeader extends StatelessWidget {
  const AmiflowHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Row(
          children: [
            Icon(Icons.hub, color: AppColors.accent),
            SizedBox(width: 10),
            Text(
              'AMIFLOW ADMIN',
              style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        Icon(Icons.sensors, color: Colors.white54),
      ],
    );
  }
}