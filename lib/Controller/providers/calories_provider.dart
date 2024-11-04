import 'package:flutter/cupertino.dart';
import 'package:healthhubcustomer/Controller/repositories/calories_repo.dart';

import '../../Model/data/caloric_intake.dart';

class CaloriesProvider extends ChangeNotifier{

  CaloriesRepo caloriesRepo = CaloriesRepo();

  int totalCalories = 0;
  int? totalCaloriesForTheDay;
  int? remainingCalories;
  int? selectedMealTime = 1;

  CaloricIntakeData? caloricIntakeData;



  void getTodaysCaloricIntake() async{
    var data = await caloriesRepo.getTodaysCaloricIntake();
    if(data != null){
      caloricIntakeData = data;
      totalCalories = data.totalCalories;
      totalCaloriesForTheDay = data.totalCaloriesForTheDay;
      remainingCalories = data.remainingCalories;
      notifyListeners();
    }
  }

  void setTotalCalories(int calories){
    totalCalories = calories;
    notifyListeners();
  }

  void setTotalCaloriesForTheDay(int calories){
    totalCaloriesForTheDay = calories;
    notifyListeners();
  }

  void setRemainingCalories(int calories){
    remainingCalories = calories;
    notifyListeners();
  }

  void resetCalories(){
    totalCalories = 0;
    totalCaloriesForTheDay = 0;
    remainingCalories = 0;
    notifyListeners();
  }


}