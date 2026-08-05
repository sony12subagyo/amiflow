class Telemetry {
  final double flow;
  final double volume;
  final bool valveOpen;
  final String? nodeTs;
  final String? ntpTs;

  const Telemetry({
    required this.flow,
    required this.volume,
    required this.valveOpen,
    this.nodeTs,
    this.ntpTs,
  });

  factory Telemetry.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Telemetry(
        flow: 0,
        volume: 0,
        valveOpen: false,
      );
    }

    return Telemetry(
      flow: double.tryParse(json['flow']?.toString() ?? '0') ?? 0,
      volume: double.tryParse(json['volume']?.toString() ?? '0') ?? 0,
      valveOpen: json['valve']?.toString() == '1',
      nodeTs: json['node_ts']?.toString(),
      ntpTs: json['ntp_ts']?.toString(),
    );
  }
}