import 'dart:convert';
import 'dart:developer';

class ApiResponse {
  int? statusCode;
  String? message;
  Data? data;

  ApiResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    try {
      return ApiResponse(
        statusCode: json['statusCode'],
        message: json['message'],
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
      );
    } catch (e, s) {
      log("Error in ApiResponse Model: $e\nStack trace: $s");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class Data {
  User? user;
  String? refreshToken;
  String? accessToken;

  Data({
    this.user,
    this.refreshToken,
    this.accessToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      user: json['data'] != null ? User.fromJson(json['data']) : null,
      refreshToken: json['refreshToken'],
      accessToken: json['accessToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': user?.toJson(),
      'refreshToken': refreshToken,
      'accessToken': accessToken,
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
  dynamic fitnessLevel;
  int? fitnessGoalId;
  dynamic fitnessGoal;
  int? height;
  int? weight;
  int? genderId;
  dynamic gender;
  String? profilePictureUrl;
  String? bio;
  bool? isGoogleSignin;
  String? salt;
  DateTime? lastLogin;
  int? numberOfLogins;
  double? tdee;
  int? activityLevelId;
  dynamic activityLevel;
  double? bmi;
  double? bmr;
  int? refreshTokenId;
  String? fcmToken;
  List<String>? beforePictures;
  List<String>? currentPictures;
  dynamic assignedTrainer;
  int? assignedTrainerId;

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
    this.currentPictures,
    this.assignedTrainer,
    this.assignedTrainerId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
   try{
     return User(
      id: json['id'],
      userName: json['user_name'],
      email: json['email'],
      passwordHash: json['password_hash'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      age: json['age'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      fitnessLevelId: json['fitness_level_id'],
      fitnessLevel: json['fitness_level'],
      fitnessGoalId: json['fitness_goal_id'],
      fitnessGoal: json['fitness_goal'],
      height: json['height'],
      weight: json['weight'],
      genderId: json['gender_id'],
      gender: json['gender'],
      profilePictureUrl: json['profile_picture_url'],
      bio: json['bio'],
      isGoogleSignin: json['is_google_signin'],
      salt: json['salt'],
      lastLogin:
          json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
      numberOfLogins: json['number_of_logins'],
      tdee: (json['tdee'] as num?)?.toDouble(),
      activityLevelId: json['activity_level_id'],
      activityLevel: json['activity_level'],
      bmi: (json['bmi'] as num?)?.toDouble(),
      bmr: (json['bmr'] as num?)?.toDouble(),
      refreshTokenId: json['refresh_token_id'],
      fcmToken: json['fcm_token'],
      beforePictures: json['before_pictures'] != null
          ? List<String>.from(json['before_pictures'])
          : null,
      currentPictures: json['current_pictures'] != null
          ? List<String>.from(json['current_pictures'])
          : null,
      assignedTrainer: json['assigned_trainer'],
      assignedTrainerId: json['assigned_trainer_id'],
    );
   }
    catch(e, s){
      log("Error in User Model: $e\nStack trace: $s");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'email': email,
      'password_hash': passwordHash,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'age': age,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'fitness_level_id': fitnessLevelId,
      'fitness_level': fitnessLevel,
      'fitness_goal_id': fitnessGoalId,
      'fitness_goal': fitnessGoal,
      'height': height,
      'weight': weight,
      'gender_id': genderId,
      'gender': gender,
      'profile_picture_url': profilePictureUrl,
      'bio': bio,
      'is_google_signin': isGoogleSignin,
      'salt': salt,
      'last_login': lastLogin?.toIso8601String(),
      'number_of_logins': numberOfLogins,
      'tdee': tdee,
      'activity_level_id': activityLevelId,
      'activity_level': activityLevel,
      'bmi': bmi,
      'bmr': bmr,
      'refresh_token_id': refreshTokenId,
      'fcm_token': fcmToken,
      'before_pictures': beforePictures,
      'current_pictures': currentPictures,
      'assigned_trainer': assignedTrainer,
      'assigned_trainer_id': assignedTrainerId,
    };
  }
}
