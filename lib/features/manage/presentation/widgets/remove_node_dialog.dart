// lib/features/manage/presentation/widgets/remove_node_dialog.dart
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';

// Mengembalikan true jika user menekan "Remove", selain itu false.
Future<bool> showRemoveNodeDialog(BuildContext context, String nodeName) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm Removal', style: TextStyle(color: Colors.white)),
        content: Text(
          'Remove $nodeName from network?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      );
    },
  );
  return result ?? false; // dialog ditutup di luar tombol = dianggap batal
}