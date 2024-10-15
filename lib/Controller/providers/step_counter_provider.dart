import 'package:flutter/material.dart';
import '../../utils/shared_preference_helper.dart';
import '../Sensor/senor_controller.dart';

class StepCounterProvider with ChangeNotifier {
  int _steps = 0;
  final int stepGoals = 10000; // Example step goal
  StepDetectionService? _stepDetectionService;

  StepCounterProvider() {
    _initializeSteps();
  }

  int get steps => _steps;

  // Initialize step count from shared preferences
  void _initializeSteps() async {
    _steps = await SharedPreferenceHelper().getTodaysSteps();
    notifyListeners();
  }

  // Start step detection
  void startStepDetection() {
    _stepDetectionService = StepDetectionService(onStepDetected: _onStepDetected);
    _stepDetectionService!.startListening();
  }

  // Stop step detection
  void stopStepDetection() {
    _stepDetectionService?.stopListening();
  }

  // Increment steps when a step is detected
  void _onStepDetected() {
    _steps++;
    SharedPreferenceHelper().saveTodaysSteps(_steps);
    notifyListeners();
  }
}
