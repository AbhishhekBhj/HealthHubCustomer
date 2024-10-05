import 'dart:convert';

class ApiResponse {
  String id;
  int statusCode;
  String message;
  Data data;

  ApiResponse({
    required this.id,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      id: json['\$id'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$id': id,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class Data {
  String id;
  User user;
  String refreshToken;

  Data({
    required this.id,
    required this.user,
    required this.refreshToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['\$id'],
      user: User.fromJson(json['user']),
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$id': id,
      'user': user.toJson(),
      'refreshToken': refreshToken,
    };
  }
}

class User {
  int? id;
  String? userName;
  String? email;
  String? passwordHash;
  DateTime? dateOfBirth;
  int? age;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? fitnessLevelId;
  dynamic fitnessLevel; // Can be replaced with a specific type if defined
  int? fitnessGoalId;
  dynamic fitnessGoal; // Can be replaced with a specific type if defined
  int? height;
  int? weight;
  int? genderId;
  dynamic gender; // Can be replaced with a specific type if defined
  String? profilePictureUrl;
  String? bio;
  bool? isGoogleSignin;
  String? salt;
  List<dynamic>? roles; // Can be replaced with a specific type if defined
  DateTime? lastLogin;
  int? numberOfLogins;
  double? tdee;
  int? activityLevelId;
  dynamic activityLevel; // Can be replaced with a specific type if defined
  double? bmi;
  double? bmr;
  int? refreshTokenId;
  dynamic fcmToken; // Can be replaced with a specific type if defined
  dynamic beforePictures; // Can be replaced with a specific type if defined

  User({
    this.id,
    this.userName,
    this.email,
    this.passwordHash,
    this.dateOfBirth,
    this.age,
    this.createdAt,
    this.updatedAt,
    this.fitnessLevelId,
    this.fitnessLevel,
    this.fitnessGoalId,
    this.fitnessGoal,
    this.height,
    this.weight,
    this.genderId,
    this.gender,
    this.profilePictureUrl,
    this.bio,
    this.isGoogleSignin,
    this.salt,
    this.roles,
    this.lastLogin,
    this.numberOfLogins,
    this.tdee,
    this.activityLevelId,
    this.activityLevel,
    this.bmi,
    this.bmr,
    this.refreshTokenId,
    this.fcmToken,
    this.beforePictures,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      passwordHash: json['passwordHash'],
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
      age: json['age'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      fitnessLevelId: json['fitnessLevelId'],
      fitnessLevel: json['fitnessLevel'], // Parse to specific type if needed
      fitnessGoalId: json['fitnessGoalId'],
      fitnessGoal: json['fitnessGoal'], // Parse to specific type if needed
      height: json['height'],
      weight: json['weight'],
      genderId: json['genderId'],
      gender: json['gender'], // Parse to specific type if needed
      profilePictureUrl: json['profilePictureUrl'],
      bio: json['bio'],
      isGoogleSignin: json['isGoogleSignin'],
      salt: json['salt'],
      roles: json['roles'] != null ? List<dynamic>.from(json['roles']['\$values'] ?? []) : null, // Parse to specific type if needed
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      numberOfLogins: json['numberOfLogins'],
      tdee: json['tdee']?.toDouble(),
      activityLevelId: json['activityLevelId'],
      activityLevel: json['activityLevel'], // Parse to specific type if needed
      bmi: json['bmi']?.toDouble(),
      bmr: json['bmr']?.toDouble(),
      refreshTokenId: json['refreshTokenId'],
      fcmToken: json['fcmToken'], // Parse to specific type if needed
      beforePictures: json['beforePictures'], // Parse to specific type if needed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'passwordHash': passwordHash,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'age': age,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'fitnessLevelId': fitnessLevelId,
      'fitnessLevel': fitnessLevel, // Convert to JSON format if needed
      'fitnessGoalId': fitnessGoalId,
      'fitnessGoal': fitnessGoal, // Convert to JSON format if needed
      'height': height,
      'weight': weight,
      'genderId': genderId,
      'gender': gender, // Convert to JSON format if needed
      'profilePictureUrl': profilePictureUrl,
      'bio': bio,
      'isGoogleSignin': isGoogleSignin,
      'salt': salt,
      'roles': roles != null ? { '\$values': roles } : null,
      'lastLogin': lastLogin?.toIso8601String(),
      'numberOfLogins': numberOfLogins,
      'tdee': tdee,
      'activityLevelId': activityLevelId,
      'activityLevel': activityLevel, // Convert to JSON format if needed
      'bmi': bmi,
      'bmr': bmr,
      'refreshTokenId': refreshTokenId,
      'fcmToken': fcmToken, // Convert to JSON format if needed
      'beforePictures': beforePictures, // Convert to JSON format if needed
    };
  }
}
