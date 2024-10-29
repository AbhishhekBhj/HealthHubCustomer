import 'dart:convert';
import 'dart:developer';

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
    try {
      return ApiResponse(
        id: json['\$id'],
        statusCode: json['statusCode'],
        message: json['message'],
        data: Data.fromJson(json['data']),
      );
    } catch (e, s) {
      print(e);
      log(s.toString() + "Error in ApiResponse Model");
      rethrow;
    }
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

  factory User.fromJson(dynamic json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      passwordHash: json['passwordHash'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      age: json['age'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
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
      // Parse to specific type if needed
      lastLogin:
          json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      numberOfLogins: json['numberOfLogins'],
      tdee: json['tdee']?.toDouble(),
      activityLevelId: json['activityLevelId'],
      activityLevel: json['activityLevel'], // Parse to specific type if needed
      bmi: json['bmi']?.toDouble(),
      bmr: json['bmr']?.toDouble(),
      refreshTokenId: json['refreshTokenId'],
      fcmToken: json['fcmToken'], // Parse to specific type if needed
      beforePictures:
          json['beforePictures'], // Parse to specific type if needed
    );
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'id': id,
        'user_name': userName, // matches JsonPropertyName("user_name")
        'email': email,
        'password': passwordHash, // matches JsonPropertyName("password_hash")
        'date_of_birth': dateOfBirth
            ?.toIso8601String(), // matches JsonPropertyName("date_of_birth")
        'age': age,
        'created_at': createdAt
            ?.toIso8601String(), // matches JsonPropertyName("created_at")
        'updated_at': updatedAt
            ?.toIso8601String(), // matches JsonPropertyName("updated_at")
        'fitness_level_id':
            fitnessLevelId, // matches JsonPropertyName("fitness_level_id")
        'fitness_level': fitnessLevel,
        'fitness_goal_id':
            fitnessGoalId, // matches JsonPropertyName("fitness_goal_id")
        'fitness_goal': fitnessGoal,
        'height': height,
        'weight': weight,
        'gender_id': genderId, // matches JsonPropertyName("gender_id")
        'gender': gender,
        'profile_picture_url':
            profilePictureUrl, // matches JsonPropertyName("profile_picture_url")
        'bio': bio,
        'is_google_signin':
            isGoogleSignin, // matches JsonPropertyName("is_google_signin")
        'salt': salt,
        'last_login': lastLogin
            ?.toIso8601String(), // matches JsonPropertyName("last_login")
        'number_of_logins':
            numberOfLogins, // matches JsonPropertyName("number_of_logins")
        'tdee': tdee,
        'activity_level_id':
            activityLevelId, // matches JsonPropertyName("activity_level_id")
        'activity_level': activityLevel,
        'bmi': bmi,
        'bmr': bmr,
        'refresh_token_id':
            refreshTokenId, // matches JsonPropertyName("refresh_token_id")
        'fcm_token': fcmToken, // matches JsonPropertyName("fcm_token")
        'before_pictures':
            beforePictures, // matches JsonPropertyName("before_pictures")
      };
    } catch (e, s) {
      print(e);

      log(s.toString() + "Error in User Model");

      rethrow;
    }
  }
}


