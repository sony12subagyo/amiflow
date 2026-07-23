// import 'package:flutter/material.dart';
// import 'package:amiflow/core/theme/app_colors.dart';
// import 'package:amiflow/features/dashboard/domain/entities/usage_history.dart';

// class HistoryCard extends StatelessWidget {
//   final UsageHistory history;
//   final int totalUsers;
//   final double totalPeriode;

//   const HistoryCard({
//     super.key,
//     required this.history,
//     required this.totalUsers,
//     required this.totalPeriode,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final status = history.status(totalUsers);

//     Color statusColor;

//     switch (status) {
//       case "HEMAT":
//         statusColor = Colors.greenAccent;
//         break;

//       case "BOROS":
//         statusColor = Colors.redAccent;
//         break;

//       default:
//         statusColor = Colors.orangeAccent;
//     }

//     return Container(
//       padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
//       decoration: const BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(28),
//         ),
//       ),
//       child: SafeArea(
//         top: false,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             /// Handle
//             Container(
//               width: 70,
//               height: 6,
//               decoration: BoxDecoration(
//                 color: Colors.white30,
//                 borderRadius: BorderRadius.circular(100),
//               ),
//             ),

//             const SizedBox(height: 24),

//             /// Judul
//             Text(
//               history.fullDate,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 6),

//             const Text(
//               "Ringkasan Penggunaan Harian",
//               style: TextStyle(
//                 color: Colors.white54,
//                 fontSize: 14,
//               ),
//             ),

//             const SizedBox(height: 24),

//             _buildItem(
//               Icons.pie_chart_outline,
//               "Kontribusi",
//               "${history.contribution(totalPeriode).toStringAsFixed(1)} %",
//             ),

//             const SizedBox(height: 16),

//             _buildItem(
//               Icons.water_drop_outlined,
//               "Penggunaan Air",
//               "${history.usageLiter.toStringAsFixed(0)} L",
//             ),

//             const SizedBox(height: 16),

//             _buildItem(
//               Icons.check_circle_outline,
//               "Status Harian",
//               status,
//               valueColor: statusColor,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildItem(
//     IconData icon,
//     String title,
//     String value, {
//     Color valueColor = AppColors.accent,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 16,
//         vertical: 14,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.background,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: AppColors.accent,
//           ),

//           const SizedBox(width: 14),

//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 15,
//               ),
//             ),
//           ),

//           Text(
//             value,
//             style: TextStyle(
//               color: valueColor,
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }