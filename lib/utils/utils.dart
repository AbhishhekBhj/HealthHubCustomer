import 'package:flutter/material.dart';

class HealthHubPadding {
  // Method to calculate responsive padding based on screen size
  static EdgeInsets allPagesPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      vertical: MediaQuery.of(context).size.height * 0.02, // 2% of screen height
      horizontal: MediaQuery.of(context).size.width * 0.05, // 5% of screen width
    );
  }

  // Alternatively, if you need a uniform padding
  static EdgeInsets uniformPadding(BuildContext context, double percentage) {
    return EdgeInsets.all(MediaQuery.of(context).size.width * percentage);
  }
}
