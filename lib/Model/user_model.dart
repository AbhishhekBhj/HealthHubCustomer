import 'dart:convert';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';



@HiveType(typeId: 0)
class ApiResponse {
  @HiveField(0)
  int? statusCode;
  @HiveField(1)
  String? message;
  @HiveField(2)
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


@HiveType(typeId: 1)
class Data {
  @HiveField(0)
  User? user;
  @HiveField(1)
  String? refreshToken;
  @HiveField(2)
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

@HiveType(typeId: 2)
class User {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? userName;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? passwordHash;
  @HiveField(4)
  DateTime? dateOfBirth;
  @HiveField(5)
  int? age;
  @HiveField(6)
  DateTime? createdAt;
  @HiveField(7)
  DateTime? updatedAt;
  @HiveField(8)
  int? fitnessLevelId;
  @HiveField(9)
  dynamic fitnessLevel;
  @HiveField(10)
  int? fitnessGoalId;
  @HiveField(11)
  dynamic fitnessGoal;
  @HiveField(12)
  int? height;
  @HiveField(13)
  int? weight;
  @HiveField(14)
  int? genderId;
  @HiveField(15)
  dynamic gender;
  @HiveField(16)
  String? profilePictureUrl;
  @HiveField(17)
  String? bio;
  @HiveField(18)
  bool? isGoogleSignin;
  @HiveField(19)
  String? salt;
  @HiveField(20)
  DateTime? lastLogin;
  @HiveField(21)
  int? numberOfLogins;
  @HiveField(22)
  double? tdee;
  @HiveField(23)
  int? activityLevelId;
  @HiveField(24)
  dynamic activityLevel;
  @HiveField(25)
  double? bmi;
  @HiveField(26)
  double? bmr;
  @HiveField(27)
  int? refreshTokenId;
  @HiveField(28)
  String? fcmToken;
  @HiveField(29)
  List<String>? beforePictures;
  @HiveField(30)
  List<String>? currentPictures;
  @HiveField(31)
  dynamic assignedTrainer;
  @HiveField(32)
  int? assignedTrainerId;
  @HiveField(33)
  dynamic dailyProteinGoal;
  @HiveField(34)
  dynamic dailyCarbohydratesGoal;
  @HiveField(35)
  dynamic dailyFatGoal;
  @HiveField(36)
  dynamic dailySugarGoal;
  @HiveField(37)
  dynamic dailyCholesterolGoal;

  @HiveField(38)
  Wallet? wallet;

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
    this.dailyProteinGoal,
    this.dailyCarbohydratesGoal,
    this.dailyFatGoal,
    this.dailySugarGoal,
    this.dailyCholesterolGoal,
    this.wallet,

  });

  factory User.fromJson(Map<String, dynamic> json) {
   try{
     return User(

      wallet: json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null,
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
      dailyProteinGoal: json['daily_protein_goal'],
      dailyCarbohydratesGoal: json['daily_carbohydrates_goal'],
      dailyFatGoal: json['daily_fat_goal'],
      dailySugarGoal: json['daily_sugar_goal'],
      dailyCholesterolGoal: json['daily_cholestrol_goal_'],
      

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


@HiveType(typeId: 3)
class Wallet{
  @HiveField(0)
  dynamic id;
  @HiveField(1)
  dynamic userId;
  @HiveField(2)
  dynamic balance;
  @HiveField(3)
  dynamic createdAt;
  @HiveField(4)
  dynamic updatedAt;
  
  //todo: banisaeke paxi wallet payments lai add garne


  Wallet({
    this.id,
    this.userId,
    this.balance,
    this.createdAt,
    this.updatedAt,
  });


  factory Wallet.fromJson(Map<String, dynamic> json) {
    try{
      return Wallet(
        id: json['id'],
        userId: json['user_id'],
        balance: json['balance'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
      );
    }
    catch(e, s){
      log("Error in Wallet Model: $e\nStack trace: $s");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'balance': balance,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
