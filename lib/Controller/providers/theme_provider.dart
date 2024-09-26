import 'package:flutter/material.dart';
import 'package:healthhubcustomer/utils/shared_preference_helper.dart';
import 'package:healthhubcustomer/utils/themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  bool get isLightTheme => _themeData == lightTheme;

  // Load the saved theme from shared preferences on initialization
  ThemeProvider() {
    _loadSavedTheme();
  }

  // Method to load the saved theme
  Future<void> _loadSavedTheme() async {
    bool isLight = await SharedPreferenceHelper().getisLightTheme();
    _themeData = isLight ? lightTheme : darkTheme;
    notifyListeners();
  }

  // Set the theme and save the preference
  Future<void> setThemeData(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
     SharedPreferenceHelper().saveisLightTheme(isLightTheme);
  }
}
