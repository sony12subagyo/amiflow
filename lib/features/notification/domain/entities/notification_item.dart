// lib/features/notification/domain/entities/notification_item.dart
class NotificationItem {
  final int id;
  final String nodeName;
  final String description;
  final String time;
  final bool dibaca;

  const NotificationItem({
    required this.id,
    required this.nodeName,
    required this.description,
    required this.time,
    required this.dibaca,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as int,
      nodeName: json['node_name']?.toString() ?? '-',
      description: json['description']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      // Terima integer (0/1) MAUPUN boolean asli -- backend Laravel kadang
      // mengirim salah satu tergantung ada/tidaknya $casts di model,
      // jangan sampai kena bug yang sama seperti kasus `online` dulu.
      dibaca: json['dibaca'] == true || json['dibaca'] == 1,
    );
  }
}