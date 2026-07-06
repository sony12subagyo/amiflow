class Gateway {
  final String id;
  final String name;
  final String gatewayCode;
  final bool isOnline;
  final bool isSelected;

  const Gateway({
    required this.id,
    required this.name,
    required this.gatewayCode,
    required this.isOnline,
    this.isSelected = false,
  });

  Gateway copyWith({
    String? id,
    String? name,
    String? gatewayCode,
    bool? isOnline,
    bool? isSelected,
  }) {
    return Gateway(
      id: id ?? this.id,
      name: name ?? this.name,
      gatewayCode: gatewayCode ?? this.gatewayCode,
      isOnline: isOnline ?? this.isOnline,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}