class SixMinuteWalkingData {
  final bool enabled;
  final int counter;

  SixMinuteWalkingData({
    required this.enabled,
    required this.counter,
  });

  // Convert the data to JSON
  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'counter': counter,
    };
  }

  // Create an instance from JSON
  factory SixMinuteWalkingData.fromJson(Map<String, dynamic> json) {
    return SixMinuteWalkingData(
      enabled: json['enabled'],
      counter: json['counter'],
    );
  }
}
