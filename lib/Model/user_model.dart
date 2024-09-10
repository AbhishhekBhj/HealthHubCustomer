class User {
  int userId;
  String username;
  String password;
  String email;
  dynamic age; // int?
  dynamic gender; // String?
  dynamic height; // double?
  dynamic weight; // double?
  dynamic createdAt; // DateTime?
  dynamic updatedAt; // DateTime?
  dynamic fitnessGoalId; // int?
  dynamic fitnessLevelId; // int?
  dynamic trainerId; // int?
  dynamic phone; // String?
  dynamic fullName; // String?

  User({
    required this.userId,
    required this.username,
    required this.password,
    required this.email,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.createdAt,
    this.updatedAt,
    this.fitnessGoalId,
    this.fitnessLevelId,
    this.trainerId,
    this.phone,
    this.fullName,
  });

  // Method to create a User from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      age: json['age'],
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      fitnessGoalId: json['fitness_goal_id'],
      fitnessLevelId: json['fitness_level_id'],
      trainerId: json['trainer_id'],
      phone: json['phone'],
      fullName: json['full_name'],
    );
  }

  // Method to convert a User object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'password': password,
      'email': email,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'fitness_goal_id': fitnessGoalId,
      'fitness_level_id': fitnessLevelId,
      'trainer_id': trainerId,
      'phone': phone,
      'full_name': fullName,
    };
  }
}
