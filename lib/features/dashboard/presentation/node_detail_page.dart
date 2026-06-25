// lib/features/dashboard/presentation/node_detail_page.dart
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/dashboard/domain/entities/node.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/usage_chart.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/config_tile.dart';

class NodeDetailPage extends StatefulWidget {
  final Node node;
  const NodeDetailPage({super.key, required this.node});

  @override
  State<NodeDetailPage> createState() => _NodeDetailPageState();
}

class _NodeDetailPageState extends State<NodeDetailPage> {
  bool _valveOpen = false;
  double _flowRate = 12.8;

  // Data sensor sementara — nanti dari backend per-node.
  final List<double> _chartData = [40, 65, 50, 85, 95, 70, 45, 30, 55, 75, 60];

  void _toggleValve() {
    setState(() {
      _valveOpen = !_valveOpen;
      _flowRate = _valveOpen ? 38.4 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildFlowCard(),
              const SizedBox(height: 15),
              _buildUsageHistory(),
              const SizedBox(height: 15),
              _buildValveSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final node = widget.node;
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.accentSoft),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('IOT NETWORK', style: TextStyle(color: Colors.white54, fontSize: 11)),
              const SizedBox(height: 4),
              Text(
                '${node.id} Control',
                style: const TextStyle(
                  color: AppColors.accentSoft,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Owner : ${node.owner}',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              Text(
                'ID : ${node.code}',
                style: const TextStyle(color: AppColors.accent, fontSize: 12),
              ),
            ],
          ),
        ),
        _buildStatusPill(node.online),
      ],
    );
  }

  Widget _buildStatusPill(bool online) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: online ? AppColors.online : AppColors.offline),
          const SizedBox(width: 5),
          Text(online ? 'ONLINE' : 'OFFLINE', style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildFlowCard() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('CURRENT FLOW RATE', style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 10),
            Text(
              _flowRate.toStringAsFixed(1),
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 56,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('L/min', style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 15),
            const Text('Stable Flow', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageHistory() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Usage History',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          UsageChart(data: _chartData),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(child: StatCard(title: 'TOTAL TODAY', value: '1,240 L')),
              SizedBox(width: 10),
              Expanded(child: StatCard(title: 'PEAK FLOW', value: '24.5 L/min')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValveSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleValve,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: _valveOpen ? AppColors.accent : Colors.grey,
                  child: Icon(
                    Icons.settings,
                    size: 45,
                    color: _valveOpen ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  _valveOpen ? 'STATUS : OPEN' : 'STATUS : CLOSED',
                  style: TextStyle(
                    color: _valveOpen ? AppColors.accent : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Tap To Toggle', style: TextStyle(color: Colors.white54)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        const ConfigTile(icon: Icons.schedule, title: 'Scheduled Flush', subtitle: 'Every 24 Hours'),
        const SizedBox(height: 10),
        const ConfigTile(icon: Icons.warning, title: 'Leak Threshold', subtitle: 'Auto-cutoff at 50L/m'),
        const SizedBox(height: 10),
        const ConfigTile(icon: Icons.info, title: 'Firmware', subtitle: 'v4.2.1 Stable'),
      ],
    );
  }
}