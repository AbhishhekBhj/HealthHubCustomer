import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Model/data/caloric_intake.dart';
import '../api_service.dart'; // Make sure to import this for jsonDecode

class CaloriesRepo {
  final ApiService _apiService = ApiService();

  Future<bool> editCaloricIntake(
      {dynamic mealTimeId,
      dynamic id,
      dynamic servingSizeConsumed,
      dynamic foodItemId}) async {
    try {
      Map<String, dynamic> body = {
        "mealTimeId": mealTimeId,
        "id": id,
        "servingSizeConsumed": servingSizeConsumed,
        "foodItemId": foodItemId
      };

      var response =
          await _apiService.put("/Calories/editCaloricIntake", body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decoded = jsonDecode(response.toString());
        var statusCode = decoded['statusCode'];
        var message = decoded['message'];
        if (statusCode == 200 || statusCode == 201) {
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return true;
        } else {
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return false;
        }
      } else {
        var decoded = jsonDecode(response.toString());
        var message = decoded['message'];
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred. ${e.toString()}.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }

  Future<bool> makeCaloricIntakeWithoutMeal({
    dynamic servingSizeConsumed,
    dynamic isFromMeal,
    dynamic mealTimeId,
    dynamic foodItemId,
  }) async {
    try {
      // Prepare the request body
      var body = {
        "servingSizeConsumed": servingSizeConsumed,
        "isFromMeal": isFromMeal,
        "mealTimeId": mealTimeId,
        "foodItemId": foodItemId
      };

      log('Post Caloric Intake Request: $body');

      // Make the API call
      final response =
          await _apiService.post("/Calories/postCaloricIntakes", body: body);

      // Check the response status
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.toString());
        log('Post Caloric Intake Response: $decoded');
        Fluttertoast.showToast(
          msg: decoded['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return true;
      } else {
        // Handle error responses
        final decoded = jsonDecode(response.toString());
        Fluttertoast.showToast(
          msg: decoded['message'] ?? 'Something went wrong.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return false;
      }
    } catch (e) {
      // Catch any exceptions
      print('Exception: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }

  Future<CaloricIntakeData?> getTodaysCaloricIntake() async {
    try {
      final response =
          await _apiService.get("/Calories/getUsersTodaysCaloricIntake");

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response
            .toString()); // Use response.body instead of response.toString()
        final data = CaloricIntakeData.fromJson(decoded['data']);
        return data;
      } else {
        Fluttertoast.showToast(
          msg: 'Error: ${response.statusCode} ${response.statusMessage}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Handle error responses
        return null; // Return null or handle it as needed
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      return null; // Return null or handle it as needed
    }
  }
}
