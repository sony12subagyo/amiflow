import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';

Future<bool> showRemoveNodeDialog(BuildContext context, String nodeName) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Penghapus', style: TextStyle(color: Colors.white)),
        content: Text(
          'Hapus node $nodeName dari gateway?',
          style: const TextStyle(color: Colors.white70),
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