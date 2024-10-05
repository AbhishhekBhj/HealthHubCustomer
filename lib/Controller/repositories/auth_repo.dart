// ignore_for_file: dead_code

import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthhubcustomer/Model/user_model.dart';
import '../api_const.dart';
import '../api_service.dart';

class AuthRepo {
  Future<User?> userSignupProfile(User user) async {
    try {
      // Make a POST request to the signup endpoint with user data
      var response = await ApiService().post(
        ApiConstants.userSignupProfile,
        body: user.toJson(),
      );

      // Decode the response body
      var decodedBody = response.data;
      var message = decodedBody['message'];
      var statusCode = decodedBody['statusCode'];

      if (statusCode == 200) {
        // If the signup is successful, parse and return the User object
        return User.fromJson(decodedBody['data']['user']);
      } else {
        // Show a toast message for any error returned from the API
        Fluttertoast.showToast(msg: message ?? 'An error occurred');
        return null;
      }
    } catch (e) {
      // Show a toast message for any exception
      Fluttertoast.showToast(msg: 'Error: $e');

      rethrow; // Re-throw the error for further handling if needed
    }
  }


  
}
