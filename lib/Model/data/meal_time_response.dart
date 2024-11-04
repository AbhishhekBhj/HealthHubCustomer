class MealTimesResponse {
  final dynamic statusCode;
  final dynamic message;
  final List<MealTimeData> data;

  MealTimesResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory MealTimesResponse.fromJson(Map<String, dynamic> json) {
    return MealTimesResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => MealTimeData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class MealTimeData {
  final dynamic id;
  final dynamic mealTimeName;
  final dynamic createdAt;
  final dynamic updatedAt;

  MealTimeData({
    required this.id,
    required this.mealTimeName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MealTimeData.fromJson(Map<String, dynamic> json) {
    return MealTimeData(
      id: json['id'],
      mealTimeName: json['mealTimeName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealTimeName': mealTimeName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
