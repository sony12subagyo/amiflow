// lib/features/notification/presentation/notification_page.dart
import 'package:amiflow/features/notification/presentation/widget/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/notification/data/notification_api.dart';
import 'package:amiflow/features/notification/domain/entities/notification_item.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
    setState(() {
      _loading = true;
      _error = null;
    });

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

  Future<void> _onTapItem(NotificationItem item) async {
    // Tandai sudah dibaca (tidak perlu ditunggu / tidak menghalangi UI)
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Notifikasi',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return ListView(
        // ListView (bukan Center) supaya pull-to-refresh tetap bisa dipakai
        children: [
          const SizedBox(height: 100),
          Center(
            child: Text(_error!, style: const TextStyle(color: Colors.white70)),
          ),
        ],
      );
    }

    if (_items.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 100),
          Center(
            child: Text(
              'Belum ada notifikasi',
              style: TextStyle(color: Colors.white38),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return NotificationCard(
          nodeName: item.nodeName,
          description: item.description,
          time: item.time,
          onTap: () => _onTapItem(item),
        );
      },
    );
  }
}
