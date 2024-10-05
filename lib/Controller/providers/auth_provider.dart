import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthhubcustomer/Controller/repositories/auth_repo.dart';

import '../../Model/user_model.dart';

class AuthProvider extends ChangeNotifier{
  User _user = User();

  bool hasError = false;

  bool isLoading = false;

  User get user => _user;

  void setUser(User user){
    _user = user;
    notifyListeners();
  }

  void setLoading(bool loading){
    isLoading = loading;
    notifyListeners();
  }

  void clearUser(){
    _user = User();
    notifyListeners();
  }


 Future<User> signUpUserProfile(User user) async {
  try {
    
    var userResponse = await AuthRepo().userSignupProfile(user);
    if (userResponse != null) {
      setUser(userResponse); // Assuming you have a setUser method to store user info.
      return userResponse;
    } else {
      throw Exception("Failed to sign up user profile");
    }
  } catch (e) {
    hasError = true;
    log('Error signing up: ${e.toString()}');
    Fluttertoast.showToast(msg: 'Error signing up: ${e.toString()}');
    rethrow; // Rethrow the error if you want to catch it higher up in the call chain.
  }
}


}