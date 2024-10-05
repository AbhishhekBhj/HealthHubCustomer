
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationServices(BuildContext context) {
    _initializeLocalNotifications(context);
    _setupFirebaseMessagingListeners();
  }

  void _initializeLocalNotifications(BuildContext context) async {
    var androidInitSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitSettings = const DarwinInitializationSettings();

    var initSettings = InitializationSettings(android: androidInitSettings, iOS: iosInitSettings);

    await _flutterLocalNotificationsPlugin.initialize(

      //when app is in background or terminated
      
      onDidReceiveBackgroundNotificationResponse: 
      (message) async {
        dev.log('onDidReceiveBackgroundNotificationResponse: ${message.payload}');
      },
      initSettings,
      
      //when app is in foreground
       onDidReceiveNotificationResponse: (response) {
      _handleNotificationTap(context, response);
    });
  }

  void firebaseInit(BuildContext context) {
    dev.log('Firebase Init message');

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      if (kDebugMode) {
        dev.log("Notification title: ${notification?.title}");
        dev.log("Notification body: ${notification?.body}");
        dev.log('Data: ${message.data}');
      }

      if (Platform.isIOS) {
        _setForegroundPresentationOptions();
      }

      if (Platform.isAndroid) {
        _showNotification(message);
      }

      // Show Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notification?.title ?? "New Notification"),
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              _handleMessageTap(context, message); // Handle notification tap
            },
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      dev.log("A new notification arrived");
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      enableVibration: true,
    );

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'your_channel_desc',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(100),
      message.notification!.title,
      message.notification!.body,
      platformDetails,
    );
  }

 

static Future<void>  _handleNotificationTap(BuildContext context, NotificationResponse response) async {
  // Log the payload of the tapped notification
  dev.log('Notification tapped with payload: ${response.payload.toString()}');

  // Extract the payload data from the notification response
  if (response.payload != null) {
    // Assuming the payload is in JSON format
    final Map<String, dynamic> data = jsonDecode(response.payload!);
    dev.log('Payload data: $data');

    // Extract the reward points and expiry date from the payload
    String rewardPoints = data['points'].toString(); // Adjust according to your payload structure
    String expiryDate = data['expiryDate'].toString(); // Adjust according to your payload structure

    // Navigate to the RewardNotificationScratcher screen
    context.goNamed(
      "rewardScratcher",
      pathParameters: {
        "point": rewardPoints,
        "expiryDate": expiryDate,
      },
    );
  } else {
    dev.log('No payload found in the notification');
  }
}



  void _handleMessageTap(BuildContext context, RemoteMessage message) {
    dev.log('Notification message tapped: ${message.notification?.title}');
    // Handle tap on notification here (e.g., navigate to a specific screen)
  }

  Future<void> _setForegroundPresentationOptions() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      dev.log('User granted notification permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      dev.log('User granted provisional permission');
    } else {
      dev.log('User denied notification permission');
    }
  }

  Future<String> getDeviceToken() async {
    dev.log('Fetching device token');
    await FirebaseMessaging.instance.subscribeToTopic('all');

    String? token = Platform.isIOS
        ? await messaging.getAPNSToken()
        : await messaging.getToken();

    dev.log('Device token: $token');
    return token!;
  }

  void _setupFirebaseMessagingListeners() async {
    // Handle notification when app is in background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      dev.log('onMessageOpenedApp: ${message.notification?.title}');
      // Handle when user taps on notification while the app is in background
    });

    // Handle initial message when the app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      dev.log('App opened from terminated state by notification: ${initialMessage.notification?.title}');
      // Handle when app is launched by tapping on a notification
    }
  }

  Future<void> scheduleNotification(String title, String body, DateTime scheduledDate) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    NotificationDetails platformDetails = const NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelScheduledNotification(String noteContent) async {
    int notificationId = noteContent.hashCode;
    dev.log('Canceling scheduled notification with ID: $notificationId');
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}

// import 'dart:io';
// import 'dart:math';
// import 'dart:developer' as dev;

// import 'package:audioplayers/audioplayers.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:healthhubcustomer/View/widgets/alerts/custom_snackbar.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;

// class NotificationServices {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   // initializing firebase message plugin
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Move the initialization outside the method
//   NotificationServices() {
//     _initializeLocalNotifications();
//   }

//   void _initializeLocalNotifications() async {
//     var androidInitializationSettings = const AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     var iosInitializationSettings = const DarwinInitializationSettings();

//     var initializationSetting = InitializationSettings(

//         android: androidInitializationSettings, iOS: iosInitializationSettings);

//     await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
//         onDidReceiveNotificationResponse: (payload) {
//           dev.log("this is the payload: $payload");
//       // handle interaction when the app is active for android
//       // This callback is only called on Android when the app is in the foreground.
//     });
//   }

//   void firebaseInit(BuildContext context) async {
//   dev.log('Firebase Init message');

// try{
//     FirebaseMessaging.onMessage.listen((message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (kDebugMode) {
//       dev.log("Notification title: ${notification?.title}");
//       dev.log("Notification body: ${notification?.body}");
//       dev.log('Data: ${message.data.toString()}');
//     }

//     if (Platform.isIOS) {
//       forgroundMessage();
//     }

//     if (Platform.isAndroid) {
//       showNotification(message);
//     }

  

//       // Also play sound
//       // final player = AudioPlayer();
//       // player.play(AssetSource('audio.wav'));

// // Show the snackbar using ScaffoldMessenger
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(notification?.title ?? "New Notification"),
//           action: SnackBarAction(
//             label: 'View',
//             onPressed: () {
//               handleMessage(context, message); // Handle the notification tap
//             },
//           ),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 3),
//         ),
//       );

      

//       dev.log("A new notification arrived");
    
//   });


// }
// catch(e){
//   dev.log('Firebase Init error: $e');}


// }


//   void requestNotificationPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print('user granted permission');
//       }
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print('user granted provisional permission');
//       }
//     } else {
//       if (kDebugMode) {
//         print('user denied permission');
//       }
//     }
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       message.notification!.android!.channelId.toString(),
//       message.notification!.android!.channelId.toString(),
//       importance: Importance.max,
//       showBadge: true,
//       playSound: true,
//       enableVibration: true,
//     );

//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       channel.id.toString(),
//       channel.name.toString(),
//       channelDescription: 'your_channel_desc',
//       importance: Importance.low,
//       priority: Priority.low,
//       playSound: true,
//       ticker: 'ticker',
//       sound: channel.sound,
//       enableVibration: true,
//       enableLights: true,
      
//     );

//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//             presentAlert: true, presentBadge: true, presentSound: true);

//     NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails);

//     //show notification without pop up
//     await _flutterLocalNotificationsPlugin.show(
//       Random().nextInt(100),
//       message.notification!.title.toString(),
//       message.notification!.body.toString(),
//       notificationDetails,
//     );

//     // Future.delayed(Duration.zero, () {
//     //   _flutterLocalNotificationsPlugin.show(
//     //     0,
//     //     message.notification!.title.toString(),
//     //     message.notification!.body.toString(),
//     //     notificationDetails,
//     //   );
//     // });
//   }

//   // function to get device token on which we will send the notifications
//   Future<String> getDeviceToken() async {

//     dev.log('Firebase Init');
//     await FirebaseMessaging.instance.subscribeToTopic('all');
//     await FirebaseMessaging.instance.subscribeToTopic('users');
//     await FirebaseMessaging.instance.subscribeToTopic('awards');
//     await FirebaseMessaging.instance.subscribeToTopic('themes');

//     dev.log('Firebase Init subscribeToTopic');






 

//     String? token = Platform.isIOS
//         ? await messaging.getAPNSToken()
//         : await messaging.getToken();
//     // print('token:$token');


//     dev.log('token:$token');
//     return token!;
//   }

//   void isTokenRefresh() async {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//       if (kDebugMode) {
//         print('refresh');
//       }
//     });
//   }

//   //handle tap on notification when app is in background or terminated
//   Future<void> setupInteractMessage(BuildContext context) async {
//     // when app is terminated
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

//     if (initialMessage != null) {
//       handleMessage(context, initialMessage);
//     }

//     //when app ins background
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       handleMessage(context, event);
//     });

//     // when app is in foreground
//   }

//   void handleMessage(BuildContext context, RemoteMessage message) {
   
//   }

//   Future forgroundMessage() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
        
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }

//   Future<void> scheduleNotification(
//       String title, String body, DateTime scheduledDate) async {
//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//       playSound: true,
//     );
//     const DarwinNotificationDetails iOSPlatformChannelSpecifics =
//         DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//       sound: 'default',
//     );
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics,
//     );

//     // The device's timezone.
//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));

//     final st = tz.TZDateTime.from(scheduledDate, tz.local);

//     await _flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       title,
//       body,
//       // tz.TZDateTime.from(scheduledDate, tz.local),
//       st,
//       platformChannelSpecifics,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

//   Future<void> cancelScheduledReminder(String deletedNote) async {
//     // Use the note content as a unique identifier for the scheduled notification
//     int notificationId = deletedNote.hashCode;
//     print(notificationId);

//     // Cancel the scheduled notification associated with the note
//     await _flutterLocalNotificationsPlugin.cancel(notificationId);
//   }
// }
