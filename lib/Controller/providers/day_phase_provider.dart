import 'package:flutter/material.dart';

import '../functions/utility_functions.dart';

class DayPhaseProvider with ChangeNotifier {
  String _phase = returnCurrentPhaseOfDay();
  IconData _icon = returnIconDataBasedonPhaseofday();
  Color _color = returnIconColorBasedonPhaseofday();

  String get phase => _phase;
  IconData get icon => _icon;
  Color get color => _color;

  // Optionally, create a method to refresh the state if needed
  void refresh() {
    _phase = returnCurrentPhaseOfDay();
    _icon = returnIconDataBasedonPhaseofday();
    _color = returnIconColorBasedonPhaseofday();
    notifyListeners(); // Notify listeners about the state change
  }
}
