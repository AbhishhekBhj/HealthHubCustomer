import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../Model/user_model.dart';
import 'app_constants.dart';

class SharedPreferenceHelper {
  void saveUserHasSeenOnboarding(bool hasSeen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('saveUserHasSeenOnboarding', hasSeen);
  }

  void saveTodaysSteps(int steps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('saveTodaysSteps', steps);
  }

  Future<int> getTodaysSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('saveTodaysSteps') ?? 0;
  }

  Future<bool> getUserHasSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(saveUserSeenOnboarding) ?? false;
  }

  void saveUserLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('saveUserLoggedIn', isLoggedIn);
  }

  Future<bool> getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('saveUserLoggedIn') ?? false;
  }

  void saveSelectedWalletSkinId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('saveSelectedWalletSkinId', id);
  }

  Future<int> getSelectedWalletSkinId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('saveSelectedWalletSkinId') ?? 1;
  }

  void saveisLightTheme(bool isLight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('saveisLightTheme', isLight);
  }

  Future<bool> getisLightTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('saveisLightTheme') ?? true;
  }

  void saveRefreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('saveRefreshToken', token);
  }

  Future<String> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log('Refresh token: ${prefs.getString('saveRefreshToken')}');

    return prefs.getString('saveRefreshToken') ?? '';
  }

    // Save User Object
   Future<void> saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString("user", userJson);
  }

  // Retrieve User Object
   Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("user");
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    }
    return null;
  }

  // Remove User Object (for logout or reset purposes)
   Future<void> removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user");
  }
}
