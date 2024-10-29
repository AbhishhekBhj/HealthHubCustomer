class FoodItemResponse {
  String? id;
  int? statusCode;
  String? message;
  FoodItemData? data;

  FoodItemResponse({this.id, this.statusCode, this.message, this.data});

  FoodItemResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? FoodItemData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class FoodItemData {
  String? id;
  int? totalRecords;
  int? pageSize;
  int? currentPage;
  int? totalPages;
  FoodItem? items;

  FoodItemData({
    this.id,
    this.totalRecords,
    this.pageSize,
    this.currentPage,
    this.totalPages,
    this.items,
  });

  FoodItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalRecords = json['totalRecords'];
    pageSize = json['pageSize'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    items = json['items'] != null ? FoodItem.fromJson(json['items']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['totalRecords'] = this.totalRecords;
    data['pageSize'] = this.pageSize;
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    if (this.items != null) {
      data['items'] = this.items!.toJson();
    }
    return data;
  }
}

class FoodItem {
  String? id;
  List<FoodItems>? values;

  FoodItem({this.id, this.values});

  FoodItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['values'] != null) {
      values = <FoodItems>[];
      json['values'].forEach((v) {
        values!.add(FoodItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    if (this.values != null) {
      data['values'] = this.values!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodItems {
  String? id;
  String? foodName;
  int? calories;
  double? protein;
  double? carbohydrates;
  double? fats;
  String? description;
  String? imageUrl;
  double? sugarContent;
  int? cholesterol;
  int? recommendedServingSize;
  String? createdAt;
  String? updatedAt;

  FoodItems({
    this.id,
    this.foodName,
    this.calories,
    this.protein,
    this.carbohydrates,
    this.fats,
    this.description,
    this.imageUrl,
    this.sugarContent,
    this.cholesterol,
    this.recommendedServingSize,
    this.createdAt,
    this.updatedAt,
  });

  FoodItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foodName = json['food_name'];
    calories = json['calories'];
    protein = json['protein'];
    carbohydrates = json['carbohydrates'];
    fats = json['fats'];
    description = json['description'];
    imageUrl = json['image_url'];
    sugarContent = json['sugar_content'];
    cholesterol = json['cholesterol'];
    recommendedServingSize = json['recommended_serving_size'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['food_name'] = this.foodName;
    data['calories'] = this.calories;
    data['protein'] = this.protein;
    data['carbohydrates'] = this.carbohydrates;
    data['fats'] = this.fats;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    data['sugar_content'] = this.sugarContent;
    data['cholesterol'] = this.cholesterol;
    data['recommended_serving_size'] = this.recommendedServingSize;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
