// lib/features/notification/presentation/widget/remove_notification_dialog.dart
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';

Future<bool> showRemoveNotificationDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Notifikasi', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Notifikasi ini akan dihapus permanen.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      );
    },
  );
  return result ?? false;
}