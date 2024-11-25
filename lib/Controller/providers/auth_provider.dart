import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthhubcustomer/Controller/repositories/auth_repo.dart';
import 'package:healthhubcustomer/utils/app_constants.dart';
import 'package:healthhubcustomer/utils/shared_preference_helper.dart';

import '../../Model/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User _user = User();

  bool hasError = false;

  bool isLoading = false;

  User get user => _user;

  void setUser(User user) {
    _user = user;

    log('User set: ${user.toString()}');
    
    notifyListeners();
  }

  void getUser() async {
    var user = _user;
    log('Getting user ${user.toJson().toString()}');

  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void clearUser() {
    _user = User();
    notifyListeners();
  }



  void getUserProfile() async{
    log('Getting user profile');
    try{
      var user = await AuthRepo().getUserProfile();
      if(user != null){
        setUser(user);
        SharedPreferenceHelper().saveUser(user);

         getUser();
      }
    }
    catch(e){
      log('Error getting user profile: $e');
      Fluttertoast.showToast(msg: 'Error getting user profile: $e');
    }
  }

  Future<User?> loginUser({required String email}) async {
    try {
      var userResponse = await AuthRepo().loginUser(email: email);

      if (userResponse != null) {
        setUser(userResponse);
        SharedPreferenceHelper().saveUserLoggedIn(true);
        SharedPreferenceHelper().saveUser(userResponse);

      }
      return userResponse;
    } catch (e) {
      hasError = true;
      log('Error logging in: ${e.toString()}');
      Fluttertoast.showToast(msg: 'Error logging in: ${e.toString()}');
      rethrow;
    }
  }

  Future<User?> signUpUserGoals(
      {required int userid,
      required int fitnessLevelId,
      required int fitnessGoalId,
      Function? callBack}) async {
    try {
      var userResponse = await AuthRepo().userSignUpGoals(
          userid: userid,
          fitnessLevelId: fitnessLevelId,
          fitnessGoalId: fitnessGoalId,
          callBack: callBack);

      log('User response: $userResponse');

      if (userResponse != null) {
        SmartDialog.dismiss();

        setUser(userResponse);
        SharedPreferenceHelper().saveUserLoggedIn(true);
        // Assuming you have a setUser method to store user info.
      }
      return userResponse;
    } catch (e) {
      hasError = true;
      log('Error signing up: ${e.toString()}');
      Fluttertoast.showToast(msg: 'Error signing up: ${e.toString()}');
      rethrow;
    }
  }

  Future<User?> signUpUserProfile(
      {required User user, Function? callBack}) async {
    try {
      SmartDialog.showLoading(msg: 'Signing up...');

      var userResponse =
          await AuthRepo().userSignupProfile(user, user.profilePictureUrl!);

      log('User response: $userResponse');

      if (userResponse != null) {
        SmartDialog.dismiss();

        callBack!();
        setUser(
            userResponse); // Assuming you have a setUser method to store user info.
      }
      SmartDialog.dismiss();
      return userResponse;
    } catch (e) {
      SmartDialog.dismiss();

      hasError = true;
      log('Error signing up: ${e.toString()}');
      Fluttertoast.showToast(msg: 'Error signing up: ${e.toString()}');
      rethrow; // Rethrow the error if you want to catch it higher up in the call chain.
    }
  }
}
