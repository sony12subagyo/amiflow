// lib/features/dashboard/domain/entities/node.dart
class Node {
  final String id;
  final String code;
  final bool online;
  final int battery;
  final String owner; // dipakai di halaman detail

  const Node({
    required this.id,
    required this.code,
    required this.online,
    required this.battery,
    this.owner = '—', // default biar data dummy lama nggak rusak
  });
}