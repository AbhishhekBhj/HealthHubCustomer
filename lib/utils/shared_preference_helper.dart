import 'package:shared_preferences/shared_preferences.dart';

import 'app_constants.dart';

class SharedPreferenceHelper{
  void saveUserHasSeenOnboarding(bool hasSeen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('saveUserHasSeenOnboarding', hasSeen);
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

  
}