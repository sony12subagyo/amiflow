// lib/features/dashboard/presentation/node_detail_page.dart
import 'package:amiflow/features/schedule/presentation/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/dashboard/domain/entities/node.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/usage_chart.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/config_tile.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/remove_node_dialog.dart';

class NodeDetailPage extends StatefulWidget {
  final Node node;
  const NodeDetailPage({super.key, required this.node});

  @override
  State<NodeDetailPage> createState() => _NodeDetailPageState();
}

class _NodeDetailPageState extends State<NodeDetailPage> {
  bool _valveOpen = false;

  final List<double> _chartData = [40, 65, 50, 85, 95, 70, 45, 30, 55, 75, 60];

  void _toggleValve() {
    setState(() {
      _valveOpen = !_valveOpen;
    });
  }

  Future<void> _deleteNode() async {
    final confirmed = await showRemoveNodeDialog(context, widget.node.id);
    if (!confirmed) return;
    if (!mounted) return;
    Navigator.pop(context, true);
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
              const SizedBox(height: 30),
              _buildDeleteButton(),
              const SizedBox(height: 20),
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
              const Text(
                'IOT NETWORK',
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
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
          CircleAvatar(
            radius: 4,
            backgroundColor: online ? AppColors.online : AppColors.offline,
          ),
          const SizedBox(width: 5),
          Text(
            online ? 'ONLINE' : 'OFFLINE',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowCard() {
    final node = widget.node;

    Color statusColor;

    switch (node.usageStatus) {
      case "HEMAT":
        statusColor = Colors.greenAccent;
        break;

      case "BOROS":
        statusColor = Colors.redAccent;
        break;

      default:
        statusColor = Colors.orangeAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            "TOTAL VOLUME AIR",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            node.waterUsageM3.toStringAsFixed(2),
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 54,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            "m³",
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),

          const SizedBox(height: 22),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.water_drop_outlined,
                  color: AppColors.accent,
                  size: 18,
                ),

                const SizedBox(width: 8),

                const Text(
                  "Penggunaan Normal",
                  style: TextStyle(color: Colors.white70),
                ),

                const Spacer(),

                Text(
                  "${node.normalUsageM3.toStringAsFixed(2)} m³",
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 12, color: statusColor),

                const SizedBox(width: 8),

                Text(
                  node.usageStatus,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          UsageChart(data: _chartData),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: "TOTAL TODAY",
                  value: "${widget.node.waterUsageM3.toStringAsFixed(2)} m³",
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: StatCard(
                  title: "PEAK FLOW",
                  value: "${widget.node.peakFlow.toStringAsFixed(1)} L/min",
                ),
              ),
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
                const Text(
                  'Tap To Toggle',
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        const SizedBox(height: 15),

        ConfigTile(
          icon: Icons.event_note,
          title: "Atur Jadwal Valve",
          subtitle: "Konfigurasi otomatis valve",
          onTap: () {
            /// masuk ke halaman schedule
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SchedulePage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withValues(alpha: 0.2),
          foregroundColor: AppColors.danger,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: _deleteNode,
        icon: const Icon(Icons.delete),
        label: const Text('Remove Node', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
