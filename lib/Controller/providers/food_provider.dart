import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthhubcustomer/Controller/repositories/food_repo.dart';
import 'package:healthhubcustomer/Model/food_category.dart';
import '../../Model/data/food_item.dart';
import '../../Model/data/meal_time_response.dart';

class FoodProvider extends ChangeNotifier {
  List<FoodCategoryData> _foodCategories = [];
  List<FoodItems> _foodItems = [];
  List<MealTimeData> _mealTimes = [];
  bool _isFoodItemLoading = false;
  bool _isInitialLoading = false; // New state for initial load
  String? _error;
  
  final FoodRepo _foodRepo = FoodRepo();


  List<MealTimeData> get mealTimes => _mealTimes;
  
  List<FoodCategoryData> get foodCategories => _foodCategories;
  List<FoodItems> get foodItems => _foodItems;
  bool get isFoodItemLoading => _isFoodItemLoading;
  bool get isInitialLoading => _isInitialLoading;
  String? get error => _error;



  void setMealTimes(List<MealTimeData> mealTimes) {
    _mealTimes = mealTimes;
    notifyListeners();
  }

  

  void setFoodCategories(List<FoodCategoryData> foodCategories) {
    _foodCategories = foodCategories;
    notifyListeners();
  }

  void setFoodItem(List<FoodItems> foodItems, {bool isNewSearch = false}) {
    if (isNewSearch) {
      _foodItems = foodItems.toSet().toList();
    } else if (foodItems.isNotEmpty) {
      _foodItems.addAll(foodItems.toSet().toList());
    }
    notifyListeners();
  }



  void getMealTimes() async {
    final value = await _foodRepo.getMealTimes();
    
      setMealTimes(value);
      notifyListeners();
    }
  

 void sortBy(String sortingFactor, {bool ascending = true}) {
  // Define a mapping from sorting factors to the appropriate property accessors
  final Map<String, num Function(FoodItems)> factorMap = {
    "Name": (item) => item.foodName!.length.toDouble(),
    "Calories": (item) => item.calories ?? 0,
    "Protein": (item) => item.protein ?? 0,
    "Carbs": (item) => item.carbohydrates ?? 0,
    "Fat": (item) => item.fats ?? 0,
  };

  // Check if the sortingFactor exists in our map
  if (factorMap.containsKey(sortingFactor)) {
    _foodItems.sort((a, b) {
      final comparison = factorMap[sortingFactor]!(a).compareTo(factorMap[sortingFactor]!(b));
      return ascending ? comparison : -comparison; // Reverse the comparison for descending order
    });
    notifyListeners();
  }
}





  Future<void> getFoodCategories() async {
     getMealTimes();
    final value = await _foodRepo.getFoodItemsCategory();
    if (value != null) {
      setFoodCategories(value.data!);
      notifyListeners();
    }
  }

  void clearFoodItems() {
    _foodItems = [];
    notifyListeners();
  }

  Future<void> getFoodItemByName({
    required String foodName, 
    required int pageNumber, 
    required int pageSize,
    bool isNewSearch = false,
  }) async {
    try {
      log("Searching for food item: $foodName");
      // Set initial loading state for new searches
      if (isNewSearch) {
        _isInitialLoading = true;
        _foodItems = [];
      } else {
        _isFoodItemLoading = true;
      }
      _error = null;
      notifyListeners();

      final value = await _foodRepo.getFoodItemByTheName(
        foodName: foodName,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      if (value != null && value.data?.items != null) {
        setFoodItem(value.data!.items!, isNewSearch: isNewSearch);
      }
    } catch (e, stackTrace) {
      log("Error: $e", stackTrace: stackTrace);
      _error = e.toString();
    } finally {
      _isFoodItemLoading = false;
      _isInitialLoading = false;
      notifyListeners();
    }
  }
}