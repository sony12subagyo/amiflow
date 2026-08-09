import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/notification/data/notification_api.dart';
import 'package:amiflow/features/notification/domain/entities/notification_item.dart';
import 'package:amiflow/features/notification/presentation/widget/notification_card.dart';
import 'package:amiflow/features/notification/presentation/widget/remove_notification_dialog.dart';

import 'package:flutter/material.dart';

class NotificationBottomSheet extends StatefulWidget {
  const NotificationBottomSheet({super.key});

  @override
  State<NotificationBottomSheet> createState() =>
      _NotificationBottomSheetState();
}

class _NotificationBottomSheetState extends State<NotificationBottomSheet> {
  final _api = NotificationApi();

  List<NotificationItem> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.fetchNotifications();
      if (!mounted) return;
      setState(() {
        _items = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal memuat notifikasi';
        _loading = false;
      });
    }
  }

  void _onTapItem(NotificationItem item) {
    // Sementara: tandai sudah dibaca saja. Kalau nanti mau munculkan
    // dialog detail (mis. MlAlertDialog), sambungkan di sini.
    _api.markAsRead(item.id);
    setState(() {
      _items = _items.map((n) {
        if (n.id == item.id) {
          return NotificationItem(
            id: n.id,
            nodeName: n.nodeName,
            description: n.description,
            time: n.time,
            dibaca: true,
          );
        }
        return n;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .72,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          /// Handle
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_active_rounded,
                  color: AppColors.accent,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  "Notifikasi Terbaru",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Divider(color: Colors.white.withOpacity(.08), height: 1),

          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.white70)),
      );
    }

    if (_items.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada notifikasi',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }
    // ganti bagian itemBuilder di ListView.builder:
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Dismissible(
          key: ValueKey(item.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => showRemoveNotificationDialog(context),
          onDismissed: (_) async {
            try {
              await _api.delete(item.id);
            } catch (e) {
              // Item sudah terlanjur hilang dari UI (dismissed). Kalau
              // hapus di server gagal, cukup log -- reload berikutnya
              // akan sinkron ulang otomatis.
              debugPrint('Gagal menghapus notifikasi di server: $e');
            }
            setState(() {
              _items.removeWhere((n) => n.id == item.id);
            });
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.delete, color: AppColors.danger),
          ),
          child: NotificationCard(
            nodeName: item.nodeName,
            description: item.description,
            time: item.time,
            onTap: () => _onTapItem(item),
          ),
        );
      },
    );
  }
}
