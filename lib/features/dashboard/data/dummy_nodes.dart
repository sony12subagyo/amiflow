import 'package:amiflow/features/dashboard/domain/entities/node.dart';

const List<Node> dummyNodes = [

  Node(
    id: "Node 01",
    code: "LORA-7724",
    online: true,
    owner: "Pak Budi",
    totalUsers: 4,
    waterUsageM3: 0.32,
    peakFlow: 24.5,
    valveOpen: false,
  ),

  Node(
    id: "Node 02",
    code: "LORA-1102",
    online: false,
    owner: "Bu Rina",
    totalUsers: 3,
    waterUsageM3: 0.20,
    peakFlow: 18.2,
    valveOpen: false,
  ),

  Node(
    id: "Node 03",
    code: "LORA-8839",
    online: true,
    owner: "Pak Agus",
    totalUsers: 5,
    waterUsageM3: 0.41,
    peakFlow: 24.5,
    valveOpen: true,
  ),

  Node(
    id: "Node 04",
    code: "LORA-4412",
    online: true,
    owner: "Pak Dedi",
    totalUsers: 2,
    waterUsageM3: 0.11,
    peakFlow: 15.3,
    valveOpen: false,
  ),

  Node(
    id: "Node 05",
    code: "LORA-9021",
    online: true,
    owner: "Pak Joko",
    totalUsers: 6,
    waterUsageM3: 0.52,
    peakFlow: 31.8,
    valveOpen: true,
  ),
];