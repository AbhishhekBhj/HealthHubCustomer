class FoodItemResponse {
  dynamic? id;
  dynamic? statusCode;
  dynamic? message;
  FoodItemData? data;

  FoodItemResponse({this.id, this.statusCode, this.message, this.data});

  FoodItemResponse.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? FoodItemData.fromJson(json['data']) : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['id'] = id;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class FoodItemData {
  dynamic? id;
  dynamic? totalRecords;
  dynamic? pageSize;
  dynamic? currentPage;
  dynamic? totalPages;
  List<FoodItems>? items;

  FoodItemData({
    this.id,
    this.totalRecords,
    this.pageSize,
    this.currentPage,
    this.totalPages,
    this.items,
  });

  FoodItemData.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    totalRecords = json['totalRecords'];
    pageSize = json['pageSize'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    if (json['items'] != null) {
      items = (json['items'] as List).map((item) => FoodItems.fromJson(item)).toList();
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['id'] = id;
    data['totalRecords'] = totalRecords;
    data['pageSize'] = pageSize;
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    if (items != null) {
      data['items'] = items!.map((item) => item.toJson()).toList();
    }
    return data;
  }
}


class FoodItems {
  dynamic? id;
  dynamic? foodName;
  dynamic? calories;
  dynamic? protein;
  dynamic? carbohydrates;
  dynamic? fats;
  dynamic? description;
  dynamic? imageUrl;
  dynamic? sugarContent;
  dynamic? cholesterol;
  dynamic? recommendedServingSize;
  dynamic? createdAt;
  dynamic? updatedAt;

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

  FoodItems.fromJson(Map<dynamic, dynamic> json) {
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

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['id'] = id;
    data['food_name'] = foodName;
    data['calories'] = calories;
    data['protein'] = protein;
    data['carbohydrates'] = carbohydrates;
    data['fats'] = fats;
    data['description'] = description;
    data['image_url'] = imageUrl;
    data['sugar_content'] = sugarContent;
    data['cholesterol'] = cholesterol;
    data['recommended_serving_size'] = recommendedServingSize;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class FoodItemCategoryResponseModel {
  dynamic id;
  dynamic statusCode;
  dynamic message;
  List<FoodItemCategoryData>? data;

  FoodItemCategoryResponseModel({
    this.id,
    this.statusCode,
    this.message,
    this.data,
  });

  FoodItemCategoryResponseModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((item) => FoodItemCategoryData.fromJson(item))
          .toList();
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['id'] = id;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((item) => item.toJson()).toList();
    }
    return data;
  }
}

class FoodItemCategoryData {
  final dynamic categoryId;
  final dynamic categoryName;

  FoodItemCategoryData({
    this.categoryId,
    this.categoryName,
  });

  FoodItemCategoryData.fromJson(Map<dynamic, dynamic> json)
      : categoryId = json['categoryId'],
        categoryName = json['categoryName'];

  Map<dynamic, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }
}


