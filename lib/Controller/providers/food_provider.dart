import 'package:flutter/material.dart';
import 'package:healthhubcustomer/Controller/repositories/food_repo.dart';
import 'package:healthhubcustomer/Model/food_category.dart';

class FoodProvider extends ChangeNotifier {
  List<FoodCategoryData> _foodCategories = [];

  FoodRepo _foodRepo = FoodRepo();

  List<FoodCategoryData> get foodCategories => _foodCategories;
  List

  void setFoodCategories(List<FoodCategoryData> foodCategories) {
    _foodCategories = foodCategories;
    notifyListeners();
  }

  void getFoodCategories(){

    _foodRepo.getFoodItemsCategory().then((value) {
      if(value != null){
        setFoodCategories(value.data!);
      }
    });

  }
}