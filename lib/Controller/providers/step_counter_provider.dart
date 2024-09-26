import 'package:flutter/material.dart';

class StepCounterProvider extends ChangeNotifier {
  int stepGoals = 10000;
  int steps = 0;

  void setStepGoals(int goals) {
    stepGoals = goals;
    notifyListeners();
  }

  void setSteps(int steps) {
    this.steps = steps;
    notifyListeners();
  }

  
}