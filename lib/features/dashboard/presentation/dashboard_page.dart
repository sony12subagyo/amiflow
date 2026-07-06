// lib/features/dashboard/presentation/dashboard_page.dart
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/dashboard/data/dummy_nodes.dart';
import 'package:amiflow/features/dashboard/presentation/add_node_dialog.dart';
import 'package:amiflow/features/dashboard/presentation/node_detail_page.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/add_node_card.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/node_card.dart';
import 'package:amiflow/features/gateway/domain/entities/gateway.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final Gateway gateway;
  final VoidCallback onChangeGateway;

  const DashboardPage({
    super.key,
    required this.gateway,
    required this.onChangeGateway,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildBanner(context),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: GridView.builder(
                  itemCount: dummyNodes.length + 1, // +1 untuk kartu "Add Node"
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    if (index == dummyNodes.length) {
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
                    // di DashboardPage, bagian itemBuilder, ganti baris return NodeCard:
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              NodeDetailPage(node: dummyNodes[index]),
                        ),
                      ),
                      child: NodeCard(node: dummyNodes[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.hub, color: AppColors.accent),
                    SizedBox(width: 8),
                    Text(
                      'AMIFLOW ADMIN',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    CircleAvatar(radius: 4, backgroundColor: AppColors.online),
                    SizedBox(width: 6),
                    Text(
                      'STM32 / LoRa Gateway Online',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.sensors, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
  return InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: onChangeGateway,
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
                  'ACTIVE GATEWAY',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  gateway.name,
                  style: const TextStyle(
                    color: AppColors.accentSoft,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  gateway.gatewayCode,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Tap to change gateway",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.router,
            size: 50,
            color: Colors.white24,
          ),
        ],
      ),
    ),
  );
}
}
