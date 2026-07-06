import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/gateway/data/dummy_gateway.dart';
import 'package:amiflow/features/gateway/domain/entities/gateway.dart';
import 'package:amiflow/features/gateway/presentation/add_gateway_dialog.dart';
import 'package:amiflow/features/gateway/presentation/widgets/add_gateway.dart';
import 'package:amiflow/features/gateway/presentation/widgets/gateway_banner.dart';
import 'package:amiflow/features/gateway/presentation/widgets/gateway_card.dart';
import 'package:amiflow/features/gateway/presentation/widgets/gateway_header.dart';
import 'package:flutter/material.dart';

class GatewayPage extends StatelessWidget {
  final ValueChanged<Gateway> onGatewaySelected;

  const GatewayPage({super.key, required this.onGatewaySelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const GatewayHeader(),
            const GatewayBanner(),

            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: GridView.builder(
                  itemCount: dummyGateways.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: .95,
                  ),
                  itemBuilder: (context, index) {
                    if (index == dummyGateways.length) {
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

                    return GatewayCard(
                      gateway: dummyGateways[index],
                      onTap: () {
                        onGatewaySelected(dummyGateways[index]);
                      },
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
