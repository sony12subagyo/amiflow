// lib/features/dashboard/presentation/dashboard_page.dart
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/dashboard/data/node_api.dart'; // <-- BARU (ganti dummy_nodes)
import 'package:amiflow/features/dashboard/domain/entities/node.dart';
import 'package:amiflow/features/dashboard/presentation/add_node_dialog.dart';
import 'package:amiflow/features/dashboard/presentation/node_detail_page.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/add_node_card.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/node_card.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/notification_bottom_sheet.dart';
import 'package:amiflow/features/gateway/domain/entities/gateway.dart';
import 'package:amiflow/shared/widgets/amiflow_header.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  final Gateway gateway;

  const DashboardPage({super.key, required this.gateway});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _searchController = TextEditingController();
  final NodeApi _api = NodeApi(); // <-- BARU
  List<Node> _nodes = [];
  List<Node> _filtered = [];
  String _query = '';

  bool _loading = true; // <-- BARU
  String? _error; // <-- BARU

  @override
  void initState() {
    super.initState();
    _loadNodes(); // <-- ganti: dulu dari dummy, sekarang dari API
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNodes() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _api.fetchNodes(
        widget.gateway.id,
      ); // <-- ganti: dulu dari dummy, sekarang dari API
      setState(() {
        _nodes = data;
        _filtered = data;
        _loading = false;
      });
      _applyFilter(); // terapkan pencarian jika ada teks tersisa
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat data node. Cek koneksi / ngrok.';
        _loading = false;
      });
    }
  }

  void _applyFilter() {
    final q = _query.toLowerCase();
    setState(() {
      _filtered = _nodes.where((n) {
        return n.id.toLowerCase().contains(q) ||
            n.code.toLowerCase().contains(q) ||
            n.owner.toLowerCase().contains(q);
      }).toList();
    });
  }

  void _onSearch(String value) {
    _query = value;
    _applyFilter();
  }

  void _removeNode(Node node) {
    _nodes.remove(node);
    _applyFilter();
  }

  Future<void> _openDetail(Node node) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NodeDetailPage(node: node)),
    );

    if (result == true) {
      // Delete
      try {
        await _api.deleteNode(node.id);
        _removeNode(node);

        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Node dihapus')));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal menghapus node')));
      }
    } else if (result is Node) {
      // Edit
      setState(() {
        final index = _nodes.indexWhere((n) => n.id == result.id);
        if (index != -1) {
          _nodes[index] = result;
        }

        final filteredIndex = _filtered.indexWhere((n) => n.id == result.id);
        if (filteredIndex != -1) {
          _filtered[filteredIndex] = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              AmiflowHeader(
                notificationCount: 2,

                onNotificationTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => const NotificationBottomSheet(),
                  );
                },
              ),
              _buildBanner(context),
              const SizedBox(height: 15),
              _buildSearchField(),
              const SizedBox(height: 15),
              Expanded(child: _buildBody()), // <-- dipisah agar rapi
            ],
          ),
        ),
      ),
    );
  }

  // Menentukan tampilan: loading / error / kosong / grid data
  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadNodes,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    // Tampilkan "tidak ditemukan" HANYA saat sedang mencari & hasil kosong
    if (_filtered.isEmpty && _query.isNotEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 90),
        physics: const BouncingScrollPhysics(),
        itemCount: _filtered.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          if (index == _filtered.length) {
            return AddNodeCard(
              onTap: () async {
                final hasil = await showDialog<Map<String, String>>(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => const AddNodeDialog(),
                );

                if (hasil == null) return; // user cancel

                try {
                  final baru = await _api.addNode(
                    gatewayId: widget.gateway.id, // OTOMATIS dari gateway aktif
                    kodeNode: hasil['kode']!,
                    namaPemilik: hasil['owner']!,
                    jumlahPenghuni: int.parse(hasil['jumlah']!),
                    password: hasil['kode']!, // password default sementara
                  );
                  setState(() {
                    _nodes.add(baru);
                    _applyFilter();
                  });
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Node ditambahkan')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menambah node')),
                  );
                }
              },
            );
          }
          return NodeCard(
            node: _filtered[index],
            onTap: () => _openDetail(_filtered[index]),
          );
        },
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gateway Aktif',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.gateway.name,
                    style: const TextStyle(
                      color: AppColors.accentSoft,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.gateway.gatewayCode,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Klik untuk mengganti gateway',
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.router, size: 50, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearch,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surface,
          hintText: 'Cari node berdasarkan nama atau ID',
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: const Icon(Icons.search, color: Colors.white54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, color: Colors.grey, size: 70),
          SizedBox(height: 10),
          Text(
            'Tidak ada node yang ditemukan',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
