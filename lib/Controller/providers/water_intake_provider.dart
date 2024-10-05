import 'package:flutter/material.dart'; // Import Flutter material package


class WaterIntakeProvider with ChangeNotifier {
  double _currentIntake = 0.0;
  double _targetIntake = 2500.0;

  // Update current intake and notify listeners
  void updateCurrentIntake(double intake) {
    _currentIntake = intake;
    notifyListeners(); // Notify listeners of changes
  }

  // Update target intake and notify listeners
  void updateTargetIntake(double intake) {
    _targetIntake = intake;
    notifyListeners(); // Notify listeners of changes
  }

  double get currentIntake => _currentIntake;
  double get targetIntake => _targetIntake;

  double get remainingIntake => _targetIntake - _currentIntake;

  double get percentage => (_currentIntake / _targetIntake) * 100;
}
