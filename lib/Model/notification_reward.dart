class RewardNotification {
  String body;
  String reward;
  int points;
  DateTime expiryDate;

  RewardNotification({
    required this.body,
    required this.reward,
    required this.points,
    required this.expiryDate,
  });

  // Factory method to create an instance from JSON
  factory RewardNotification.fromJson(Map<String, dynamic> json) {
    return RewardNotification(
      body: json['body'] as String,
      reward: json['reward'] as String,
      points: json['points'] as int,
      expiryDate: DateTime.parse(json['expiryDate'] as String),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'reward': reward,
      'points': points,
      'expiryDate': expiryDate.toIso8601String(),
    };
  }
}
