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
  TotalData? totalData;


  CaloricIntakeData({
    required this.totalCalories,
    this.details,
    this.totalCaloriesForTheDay,
    this.remainingCalories,
    this.totalData,
  });

  factory CaloricIntakeData.fromJson(Map<String, dynamic> json) {

    var detailsFromJson = json['details'] as List<dynamic>?;
    List<CaloricIntakeDetail>? detailsList =
        detailsFromJson?.map((item) => CaloricIntakeDetail.fromJson(item)).toList();

    return CaloricIntakeData(
      totalData: json['totalData'] != null ? TotalData.fromJson(json['totalData']) : null,
      totalCalories: json['totalCalories'],
      details: detailsList,
      totalCaloriesForTheDay: json['totalCaloriesForTheDay'],
      remainingCalories: json['remainingCalories'],
    );
  }
}

class CaloricIntakeDetail {
  int id; // Removed final
  FoodItems? foodItem;

  int? servingSizeConsumed;
  
  
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
    this.isFromMeal,
    this.servingSizeConsumed,

  });

  factory CaloricIntakeDetail.fromJson(Map<String, dynamic> json) {
    return CaloricIntakeDetail(

      servingSizeConsumed: json['servingSizeConsumed'],


      isFromMeal: json['isFromMeal'],
      mealTimeId: json['mealTimeId'],
      id: json['id'],
      foodItem: json['foodItem'] != null ? FoodItems.fromJson(json['foodItem']) : null,
      totalCalories: json['totalCalories'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

class TotalData{
  dynamic totalCalories;
  dynamic totalProtein;
  dynamic totalCarbs;
  dynamic totalFat;
  dynamic totalSugar;
  dynamic totalCholesterol;

  TotalData({
    this.totalCalories,
    this.totalProtein,
    this.totalCarbs,
    this.totalFat,
    this.totalSugar,
    this.totalCholesterol
  });

  factory TotalData.fromJson(Map<String, dynamic> json) {
    return TotalData(
      totalCalories: json['totalCalories'],
      totalProtein: json['totalProtein'],
      totalCarbs: json['totalCarbohydrates'],
      totalFat: json['totalFats'],
      totalSugar: json['totalSugar'],
      totalCholesterol: json['totalCholesterol'],
    );
  }
}

