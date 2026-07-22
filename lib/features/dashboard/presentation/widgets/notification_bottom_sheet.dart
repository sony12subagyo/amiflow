import 'package:amiflow/core/theme/app_colors.dart';
//import 'package:amiflow/features/dashboard/data/dummy_nodes.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/ml_alert_dialog.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:amiflow/features/dashboard/domain/entities/node.dart';

class NotificationBottomSheet extends StatelessWidget {
  const NotificationBottomSheet({super.key});

  /// Dummy Notification
  // static final List<Map<String, dynamic>> dummyNotifications = [
  //   {
  //     "node": dummyNodes[0],
  //     "description": "Pemborosan selama 3 bulan berturut-turut.",
  //     "time": "5 menit lalu",
  //   },

  //   {
  //     "node": dummyNodes[3],
  //     "description": "Pemborosan selama 3 bulan berturut-turut.",
  //     "time": "2 jam lalu",
  //   },

  //   {
  //     "node": dummyNodes[4],
  //     "description": "Pemborosan selama 3 bulan berturut-turut.",
  //     "time": "Kemarin",
  //   },
  // ];

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
                  "Notifikasi Machine Learning",
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

          //Expanded(
            // child: ListView.builder(
            //   padding: const EdgeInsets.symmetric(vertical: 10),
            //   itemCount: dummyNotifications.length,
            //   itemBuilder: (context, index) {
            //     final item = dummyNotifications[index];
            //     final node = item["node"] as Node;

            //     return NotificationCard(
            //       nodeName: node.id,
            //       description: item["description"]!,
            //       time: item["time"]!,
            //       onTap: () {
            //         showDialog(
            //           context: context,
            //           builder: (_) => MlAlertDialog(
            //             node: node,
            //             status: item["description"] as String,
            //             recommendations: const [
            //               "Periksa kondisi valve",
            //               "Verifikasi jumlah pengguna",
            //               "Perbarui jumlah pengguna bila diperlukan",
            //             ],
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
          //),
        ],
      ),
    );
  }
}
