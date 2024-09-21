import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackBar({
  required BuildContext context,
  required String message,
  required Color snackBarColor,
  required Color textColor,
   VoidCallback? onTap, // Tap callback function
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: GestureDetector(
        onTap: onTap, // Triggering the tap action
        child: Text(
          message,
          style: TextStyle(
            color: textColor, // Using the textColor parameter
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: snackBarColor, // Using the snackBarColor parameter
      duration: const Duration(seconds: 2),
    ),
  );
}
