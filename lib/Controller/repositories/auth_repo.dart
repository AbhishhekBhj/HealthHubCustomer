// ignore_for_file: dead_code

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthhubcustomer/Model/user_model.dart';
import 'package:healthhubcustomer/utils/shared_preference_helper.dart';
import '../api_const.dart';
import '../api_service.dart';

class AuthRepo {
  ApiService _apiService = ApiService();

  SharedPreferenceHelper _sharedPreferenceHelper = SharedPreferenceHelper();



Future<User?> getUserProfile() async{

  try{

    var response = await _apiService.get(ApiConstants.getUserProfile);

    if(response.statusCode == 200 || response.statusCode == 201){
      var data = response.data;
      if(data['statusCode'] == 200 || data['statusCode'] == 201){
        return User.fromJson(data['data']);
      }
    }
    else{
      Fluttertoast.showToast(msg: 'Failed to get user profile');
      return null;
    }


  }
  catch(e,s){
    log('Error getting user profile: $e', stackTrace: s);
    Fluttertoast.showToast(msg: 'Error: $e');
    rethrow;
  }

}


Future<User?> loginUser({required String email}) async {
  try {
    final body = {'email': email, 'password': 'password'};
    
    SmartDialog.showLoading(msg: 'Logging in...');
    final response = await _apiService.post(ApiConstants.userLogin, body: body);
    
    // Log the raw response for debugging
    log('Raw Response: ${response.toString()}');
    
    // Safely extract the response data
    final Map<String, dynamic> decodedBody;
    if (response.data is String) {
      decodedBody = jsonDecode(response.data);
    } else if (response.data is Map) {
      decodedBody = Map<String, dynamic>.from(response.data);
    } else {
      throw FormatException('Unexpected response format: ${response.data.runtimeType}');
    }
    
    // Log the decoded response
    log('Decoded Response: $decodedBody');
    
    // Safely extract status code and message with type checking
    final statusCode = decodedBody['statusCode'];
    final message = decodedBody['message']?.toString() ?? 'No message provided';
    
    // Validate status code
    if (statusCode is! int) {
      throw FormatException('Invalid status code format: $statusCode');
    }
    
    if (statusCode == 200 || statusCode == 201) {
      // Safely navigate the response structure
      final data = decodedBody['data'];
      if (data == null) {
        throw FormatException('Response data is null');
      }
      
      final userData = data['data'];
      if (userData == null) {
        throw FormatException('User data is null');
      }
      
      // Create user object
      final user = User.fromJson(userData as Map<String, dynamic>);
      
      // Save refresh token
      final refreshToken = data['refreshToken']?.toString();
      if (refreshToken != null) {
         _sharedPreferenceHelper.saveRefreshToken(refreshToken);
      } else {
        log('Warning: No refresh token found in response');
      }
      
      return user;
    } else {
      Fluttertoast.showToast(msg: message);
      return null;
    }
  } on DioException catch (e) {
    log('Dio Error: ${e.message}', error: e, stackTrace: e.stackTrace);
    Fluttertoast.showToast(msg: 'Network error: ${e.message}');
    return null;
  } on FormatException catch (e) {
    log('Format Error: ${e.message}', error: e);
    Fluttertoast.showToast(msg: 'Data format error: ${e.message}');
    return null;
  } catch (e, s) {
    log('Unexpected Error: $e', error: e, stackTrace: s);
    Fluttertoast.showToast(msg: 'Unexpected error occurred');
    return null;
  } finally {
    SmartDialog.dismiss();
  }
}

  Future<User?> userSignUpGoals({
    required int userid,
    required int fitnessLevelId,
    required int fitnessGoalId,
    // required List<File> beforePhotos,
    Function? callBack,
  }) async {
    try {
      SmartDialog.showLoading(msg: 'Registering user goals...');
      // Prepare the data for the request
      var body = {
        'user_id': userid.toString(),
        'fitness_level_id': fitnessLevelId.toString(),
        'fitness_goal_id': fitnessGoalId.toString(),
      };

      // Add multiple files under the same key (before_photos)

      var response = await ApiService().post(
        ApiConstants.userSignupGoals,
        body: body,
      );

      // Handle the response
      if (response.statusCode == 201 || response.statusCode == 200) {
        SmartDialog.dismiss();

        if (response.data['statusCode'] == 200 ||
            response.data['statusCode'] == 201) {
          callBack!();
          // Assuming your API returns user data
          User user = User.fromJson(response.data);

          // Adjust according to your User model
          Fluttertoast.showToast(msg: 'User goals registered successfully!');
          return user;
        }
      } else {
        SmartDialog.dismiss();
        Fluttertoast.showToast(msg: 'Failed to register user goals');
        return null;
      }
    } catch (e, s) {
      SmartDialog.dismiss();
      log('Error signing up: $e', stackTrace: s);
      Fluttertoast.showToast(msg: 'Error: $e');
      rethrow;
    }
  }

  Future<User?> userSignupProfile(User user, String imagePath) async {
    try {
      // Prepare the profile data as a map (excluding the image)
      Map<String, dynamic> profileData = user.toJson();

      // Call the method to upload the image along with profile data
      var response = await _apiService.postWithImage(
          ApiConstants.userSignupProfile, // The API endpoint URL
          imagePath, // Path to the profile image
          'profile_picture_url', // The key for the image file in the form
          profileData // Additional profile data
          );

      // Decode the response body
      var decodedBody = response.data;
      var message = decodedBody['message'];
      var statusCode = decodedBody['statusCode'];

      if (statusCode == 200 || statusCode == 201) {
        return User.fromJson(decodedBody['data']['user']);
      } else {
        // Show a toast message for any error returned from the API
        Fluttertoast.showToast(msg: message ?? 'An error occurred');
        return null;
      }
    } catch (e, s) {
      log('Error signing up: $e', stackTrace: s);
      // Show a toast message for any exception
      Fluttertoast.showToast(msg: 'Error: $e');
      rethrow; // Re-throw the error for further handling if needed
    }
  }
}
