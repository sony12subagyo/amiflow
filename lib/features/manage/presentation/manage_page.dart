// lib/features/manage/presentation/manage_page.dart
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/manage/domain/entities/node.dart';
import 'package:amiflow/features/manage/data/dummy_manage_nodes.dart';
import 'package:amiflow/features/manage/presentation/widgets/node_tile.dart';
import 'package:amiflow/features/manage/presentation/widgets/remove_node_dialog.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  final _searchController = TextEditingController();

  late List<Node> _nodes;    // daftar master
  late List<Node> _filtered; // hasil pencarian
  String _query = '';

  @override
  void initState() {
    super.initState();
    _nodes = List.of(dummyManageNodes); // disalin agar bisa dimutasi (dummy const)
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
        return n.name.toLowerCase().contains(q) ||
            n.code.toLowerCase().contains(q) ||
            n.owner.toLowerCase().contains(q);
      }).toList();
    });
  }

  void _onSearch(String value) {
    _query = value;
    _applyFilter();
  }

  Future<void> _onDelete(Node node) async {
    final confirmed = await showRemoveNodeDialog(context, node.name);
    if (!confirmed) return;
    _nodes.remove(node);
    _applyFilter(); // satu daftar master, filter dihitung ulang
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildTitle(),
              const SizedBox(height: 20),
              _buildSearchField(),
              const SizedBox(height: 20),
              Expanded(
                child: _filtered.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100), // ruang untuk pill
                        itemCount: _filtered.length,
                        itemBuilder: (context, index) {
                          final node = _filtered[index];
                          return NodeTile(node: node, onDelete: () => _onDelete(node));
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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

  Widget _buildTitle() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage Nodes',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text('Select nodes to remove from network', style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: _onSearch,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        hintText: 'Find node by ID or Owner',
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: const Icon(Icons.search, color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
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
          Text('No nodes found', style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}