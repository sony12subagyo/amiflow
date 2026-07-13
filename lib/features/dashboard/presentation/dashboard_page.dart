// lib/features/dashboard/presentation/dashboard_page.dart
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/dashboard/data/dummy_nodes.dart';
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
  late List<Node> _nodes;
  late List<Node> _filtered;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _nodes = List.of(dummyNodes);
    _filtered = _nodes;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    // NodeDetailPage mengembalikan true kalau node dihapus
    final deleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => NodeDetailPage(node: node)),
    );

    if (deleted == true) {
      _removeNode(node);
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
              Expanded(
                child: _filtered.isEmpty
                    ? _buildEmptyState()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: GridView.builder(
                          padding: const EdgeInsets.only(bottom: 90),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _filtered.length + 1,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1,
                              ),
                          itemBuilder: (context, index) {
                            if (index == _filtered.length) {
                              return AddNodeCard(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (_) => const AddNodeDialog(),
                                  );
                                },
                              );
                            }
                            return NodeCard(
                              node: _filtered[index],
                              onTap: () => _openDetail(_filtered[index]),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
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
