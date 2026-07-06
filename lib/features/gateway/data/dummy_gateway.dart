import 'package:amiflow/features/gateway/domain/entities/gateway.dart';

final List<Gateway> dummyGateways = [
  const Gateway(
    id: "1",
    name: "Gateway 01",
    gatewayCode: "GW-2024-001",
    isOnline: true,
    isSelected: true,
  ),

  const Gateway(
    id: "2",
    name: "Gateway 02",
    gatewayCode: "GW-2024-002",
    isOnline: false,
    isSelected: false,
  ),

  const Gateway(
    id: "3",
    name: "Gateway 03",
    gatewayCode: "GW-2024-003",
    isOnline: false,
    isSelected: false,
  ),
];