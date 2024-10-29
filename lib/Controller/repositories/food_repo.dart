import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthhubcustomer/Controller/api_service.dart';
import 'package:healthhubcustomer/Model/data/food_item.dart';
import 'package:healthhubcustomer/Model/food_category.dart';
import 'package:healthhubcustomer/View/widgets/alerts/custom_snackbar.dart';

class FoodRepo {


Future<FoodCategoryResponse?> getFoodItemsCategory() async {
  try {
    final response = await ApiService().get("Food/categories");
    final decodedResponse = response.data;

    

    // Safely extract status code and message
    final statusCode = decodedResponse['statusCode'] as int?;
    final message = decodedResponse['message']?.toString();

    if (statusCode == 200) {
      final data = decodedResponse['data']?['data'];
      if (data != null) {
        
        return FoodCategoryResponse.fromJson(data as Map<String, dynamic>);
      } else {
        log("Error: No data found in the response");
      }
    } else {
      log("Error: $message (Status Code: $statusCode)");
    }
  } catch (e, stackTrace) {
    Fluttertoast.showToast(msg: "Failed to load data: ${e.toString()}");
    log("Error: $e", stackTrace: stackTrace);
    rethrow;
  }
  return null;
}

  

  Future<FoodItemResponse?> getFoodItems({required int pageNumber, required int pageSize}) async {
    try {
      var response = await ApiService().get("/Food/fooditems/$pageSize/$pageNumber");

      var decodedResponse = jsonDecode(response.toString());
      var statusCode = decodedResponse["statusCode"];
      var message = decodedResponse["message"];

      if (statusCode == 200) {
        var data = FoodItemResponse.fromJson(decodedResponse);
        return data;
      } else {
        // Show a toast or snackbar if status code isn't 200
        Fluttertoast.showToast(msg: message ?? "Something went wrong.");
        log("Error: $message (Status Code: $statusCode)");
      }
        } catch (e, stackTrace) {
      // Log the error and show a toast/snackbar
      Fluttertoast.showToast(msg: "Failed to load data: ${e.toString()}");
      log("Error: ${e.toString()}", stackTrace: stackTrace);
      rethrow; // Re-throw the error for further handling if necessary
    }
    return null; // Return null in case of any failure
  }
}
