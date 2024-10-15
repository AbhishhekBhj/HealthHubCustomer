import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:healthhubcustomer/utils/shared_preference_helper.dart';
import 'package:provider/provider.dart';

import '../Controller/providers/step_counter_provider.dart';



// Initializes the background service for step counting
Future<void> initializeBackGroundService() async {
  // var stepCounterProviderInstance = Provider.of<StepCounterProvider>(context);
  final service = FlutterBackgroundService();

  // Configure background service for iOS and Android
  await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart, // Run in foreground
        onBackground: onBackgroundIos, // Handle background mode
      ),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: true));
}

// Callback when the service starts (both foreground and background)


@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Initialize step counting service
  int currentSteps = await SharedPreferenceHelper().getTodaysSteps();

  try {
    DartPluginRegistrant.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.on("setAsForeground").listen((event) {
        log("Start Steps Tracking");
        service.setAsForegroundService();
      });

      service.on("setAsBackground").listen((event) {
        log("Stop Steps Tracking");
        service.stopSelf();
      });

      // Timer to periodically update the notification with step count
      Timer.periodic(const Duration(seconds: 10), (timer) async {
        if (await service.isForegroundService()) {
          int steps = await SharedPreferenceHelper().getTodaysSteps();
          
          // Update the step count in the provider directly


          service.setForegroundNotificationInfo(
            title: "HealthHub",
            content: "You have taken $steps steps",
          );
          log("Service running with $steps steps");
        }
      });

      service.invoke("update");
    }
  } catch (e) {
    log(e.toString()); // Log any errors
  }
}






// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   // Initialize the step count from SharedPreferences
//   int steps = await SharedPreferenceHelper().getTodaysSteps();
  
//   try {
//     DartPluginRegistrant.ensureInitialized();
//     WidgetsFlutterBinding.ensureInitialized();

//     // Android-specific logic for handling foreground and background services
//     if (service is AndroidServiceInstance) {
//       // Listen for "setAsForeground" event to start the service in the foreground
//       service.on("setAsForeground").listen((event) {
//         log("Start Steps Tracking");
//         service.setAsForegroundService();
//       });

//       // Listen for "setAsBackground" event to stop the foreground service
//       service.on("setAsBackground").listen((event) {
//         log("Stop Steps Tracking");
//         service.stopSelf();
//       });

//       // Listen for "stopService" event to stop the service
//       service.on("stopService").listen((event) {
//         log("Start Steps Tracking");
//         service.setAsBackgroundService(); // Move to background mode
//       });

//       // Timer to update step count in notification every 3 seconds
//       Timer.periodic(const Duration(seconds: 3), (timer) async {
//         if (await service.isForegroundService()) {
//           // Fetch the latest step count from SharedPreferences
//           steps = await SharedPreferenceHelper().getTodaysSteps();



          

//           // Set foreground notification with updated step count
//           service.setForegroundNotificationInfo(


//             title: "Health Hub",
//             content: "You have taken $steps steps",
//           );
          
//           log("Service running with $steps steps");
//         }
//       });

//       // Trigger the service to update
//       service.invoke("update");
//     }
//   } catch (e) {
//     log(e.toString()); // Log any errors
//   }
// }

// void onStart(ServiceInstance service) async {

//   int steps =  await SharedPreferenceHelper().getTodaysSteps();
  
//   try {
//     DartPluginRegistrant.ensureInitialized();
//     WidgetsFlutterBinding.ensureInitialized();

//     // Android-specific logic for handling foreground and background services
//     if (service is AndroidServiceInstance) {
//       // Listen for "setAsForeground" event to start the service in the foreground
//       service.on("setAsForeground").listen((event) {
//         log("Start Steps Tracking");
//         service.setAsForegroundService();
//       });

//       // Listen for "setAsBackground" event to stop the foreground service
//       service.on("setAsBackground").listen((event) {
//         log("Stop Steps Tracking");
//         service.stopSelf();
//       });

//       // Listen for "stopService" event to stop the service
//       service.on("stopService").listen((event) {
//         log("Start Steps Tracking");
//         service.setAsBackgroundService(); // Move to background mode
//       });

//       // Periodic timer to keep the service running
//       Timer.periodic(const Duration(seconds: 1), (timer) async {
//         if (await service.isForegroundService()) {
//           // Set foreground notification
//           service.setForegroundNotificationInfo(

//             title: "Step Counter",
//             content: "Step Counter is running at $steps steps",
//           );
//           log("Service is running");
//         }
//         log("Service is running");
//       });

//       // Trigger the service to update
//       service.invoke("update");
//     }
//   } catch (e) {
//     print(e); // Log any errors
//   }
// }

// Background service logic for iOS
@pragma('vm:entry-point')
Future<bool> onBackgroundIos(ServiceInstance service) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  } catch (e) {
    log(e.toString());
    return false;
  }
}
