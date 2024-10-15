import 'package:shared_preferences/shared_preferences.dart';

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
}
