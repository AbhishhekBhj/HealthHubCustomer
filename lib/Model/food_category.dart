class FoodCategoryResponse {
  int? statusCode;
  String? message;
  List<FoodCategoryData>? data;

  FoodCategoryResponse({this.statusCode, this.message, this.data});

  FoodCategoryResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FoodCategoryData>[];
      json['data'].forEach((v) {
        data!.add(new FoodCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodCategoryData {
  int? id;
  String? categoryName;
  String? description;

  FoodCategoryData({
    this.id,
    this.categoryName,
    this.description,
  });

  FoodCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['description'] = this.description;

    return data;
  }
}
