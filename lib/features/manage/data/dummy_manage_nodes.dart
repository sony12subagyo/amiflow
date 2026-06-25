// lib/features/manage/data/dummy_manage_nodes.dart
import 'package:amiflow/features/manage/domain/entities/node.dart';

// Data sementara. Ganti dengan repository saat backend Laravel siap.
const List<Node> dummyManageNodes = [
  Node(name: 'Node 01', code: 'LORA-7724', owner: 'Alex Rivers'),
  Node(name: 'Node 02', code: 'LORA-8812', owner: 'Sarah Chen'),
  Node(name: 'Node 03', code: 'LORA-9004', owner: 'Industrial Admin'),
  Node(name: 'Node 04', code: 'LORA-1102', owner: 'Root Admin'),
  Node(name: 'Node 05', code: 'LORA-4422', owner: 'Field Technician'),
];