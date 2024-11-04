import 'food_item.dart';

class CaloricIntakeResponse {
  int statusCode; // Removed final
  String? message;
  CaloricIntakeData? data;

  CaloricIntakeResponse({
    required this.statusCode,
    this.message,
    this.data,
  });

  factory CaloricIntakeResponse.fromJson(Map<String, dynamic> json) {
    return CaloricIntakeResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null
          ? CaloricIntakeData.fromJson(json['data'])
          : null,
    );
  }
}

class CaloricIntakeData {
  int totalCalories; // Removed final
  List<CaloricIntakeDetail>? details;
  int? totalCaloriesForTheDay;
  int? remainingCalories;

  CaloricIntakeData({
    required this.totalCalories,
    this.details,
    this.totalCaloriesForTheDay,
    this.remainingCalories,
  });

  factory CaloricIntakeData.fromJson(Map<String, dynamic> json) {
    var detailsFromJson = json['details'] as List<dynamic>?;
    List<CaloricIntakeDetail>? detailsList =
        detailsFromJson?.map((item) => CaloricIntakeDetail.fromJson(item)).toList();

    return CaloricIntakeData(
      totalCalories: json['totalCalories'],
      details: detailsList,
      totalCaloriesForTheDay: json['totalCaloriesForTheDay'],
      remainingCalories: json['remainingCalories'],
    );
  }
}

class CaloricIntakeDetail {
  int id; // Removed final
  FoodItems? foodItem; // Make sure the FoodItem class is properly defined
  int? totalCalories;
  DateTime? createdAt;
  int? mealTimeId;
  dynamic isFromMeal;
  int? mealId;

  CaloricIntakeDetail({
    required this.id,
    this.foodItem,
    this.totalCalories,
    this.createdAt,
    this.mealTimeId,
    this.isFromMeal

  });

  factory CaloricIntakeDetail.fromJson(Map<String, dynamic> json) {
    return CaloricIntakeDetail(
      isFromMeal: json['isFromMeal'],
      mealTimeId: json['mealTimeId'],
      id: json['id'],
      foodItem: json['foodItem'] != null ? FoodItems.fromJson(json['foodItem']) : null,
      totalCalories: json['totalCalories'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
