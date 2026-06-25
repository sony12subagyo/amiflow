// lib/features/dashboard/data/dummy_nodes.dart
import 'package:amiflow/features/dashboard/domain/entities/node.dart';

// Data sementara. Ganti dengan hasil repository saat backend Laravel siap.
const List<Node> dummyNodes = [
  Node(id: 'Node 01', code: 'LORA-7724', online: true,  battery: 100),
  Node(id: 'Node 02', code: 'LORA-1102', online: false, battery: 12),
  Node(id: 'Node 03', code: 'LORA-8839', online: true,  battery: 80),
  Node(id: 'Node 04', code: 'LORA-4412', online: true,  battery: 65),
  Node(id: 'Node 05', code: 'LORA-9021', online: true,  battery: 95),
];