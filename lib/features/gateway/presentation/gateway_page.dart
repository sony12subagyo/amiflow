// lib/features/gateway/presentation/gateway_page.dart
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/gateway/data/dummy_gateway.dart';
import 'package:amiflow/features/gateway/domain/entities/gateway.dart';
import 'package:amiflow/features/gateway/presentation/add_gateway_dialog.dart';
import 'package:amiflow/features/gateway/presentation/widgets/add_gateway.dart';
import 'package:amiflow/features/gateway/presentation/widgets/gateway_banner.dart';
import 'package:amiflow/features/gateway/presentation/widgets/gateway_card.dart';
import 'package:amiflow/features/gateway/presentation/widgets/remove_gateway_dialog.dart';
import 'package:amiflow/features/dashboard/presentation/dashboard_page.dart';
import 'package:amiflow/shared/widgets/amiflow_header.dart';
import 'package:flutter/material.dart';

class GatewayPage extends StatefulWidget {
  const GatewayPage({super.key});

  @override
  State<GatewayPage> createState() => _GatewayPageState();
}

class _GatewayPageState extends State<GatewayPage> {
  late List<Gateway> _gateways;

  @override
  void initState() {
    super.initState();
    _gateways = List.of(dummyGateways);
  }

  Future<void> _onDelete(Gateway gateway) async {
    final confirmed = await showRemoveGatewayDialog(context, gateway.name);
    if (!confirmed) return;
    setState(() {
      _gateways.remove(gateway);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AmiflowHeader(),
            const GatewayBanner(),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: GridView.builder(
                  itemCount: _gateways.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: .95,
                  ),
                  itemBuilder: (context, index) {
                    if (index == _gateways.length) {
                      return AddGatewayCard(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) => const AddGatewayDialog(),
                          );
                        },
                      );
                    }

                    final gateway = _gateways[index];
                    return GatewayCard(
                      gateway: gateway,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DashboardPage(gateway: gateway),
                          ),
                        );
                      },
                      onDelete: () => _onDelete(gateway),
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
}