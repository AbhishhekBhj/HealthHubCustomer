

import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthhubcustomer/View/widgets/alerts/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // initializing firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Move the initialization outside the method
  NotificationServices() {
    _initializeLocalNotifications();
  }

  void _initializeLocalNotifications() async {
    var androidInitializationSettings = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // handle interaction when the app is active for android
      // This callback is only called on Android when the app is in the foreground.
    });
  }

  void firebaseInit(BuildContext context) async {
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   // Handle the notification when the app is in the foreground and opened by tapping the notification
    //   handleMessage(context, message);
    // });
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android?.count ?? ''}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        showNotification(message);
      }

      if (message.data.isNotEmpty) {
        if (kDebugMode) {
          print('Message data payload: ${message.data}');
        }
        //also play sound
        final player = AudioPlayer();
        player.play(AssetSource('audio.wav'));


        // Get.snackbar(
        //   message.notification!.title.toString(),
        //   message.notification!.body.toString(),
        //   backgroundColor: Colors.grey[200],
        //   colorText: blackColor,
        //   snackPosition: SnackPosition.TOP,
        //   duration: const Duration(
        //     seconds: 3,
        //   ),
        //   onTap: (value) {
        //     Get.back();
        //     handleMessage(context, message);
        //   },
        // );
      }
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your_channel_desc',
      importance: Importance.low,
      priority: Priority.low,
      playSound: true,
      ticker: 'ticker',
      sound: channel.sound,
      enableVibration: true,
      enableLights: true,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    //show notification without pop up
    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(100),
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
    );

    // Future.delayed(Duration.zero, () {
    //   _flutterLocalNotificationsPlugin.show(
    //     0,
    //     message.notification!.title.toString(),
    //     message.notification!.body.toString(),
    //     notificationDetails,
    //   );
    // });
  }

  // function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    await FirebaseMessaging.instance.subscribeToTopic('all');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseMessaging.instance
        .subscribeToTopic('${prefs.getString("userId")}');

    String? token = Platform.isIOS
        ? await messaging.getAPNSToken()
        : await messaging.getToken();
    print('token:$token');
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });

    // when app is in foreground
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    //Todo: handle the message
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> scheduleNotification(
      String title, String body, DateTime scheduledDate) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // The device's timezone.
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));

    final st = tz.TZDateTime.from(scheduledDate, tz.local);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      // tz.TZDateTime.from(scheduledDate, tz.local),
      st,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelScheduledReminder(String deletedNote) async {
    // Use the note content as a unique identifier for the scheduled notification
    int notificationId = deletedNote.hashCode;
    print(notificationId);

    // Cancel the scheduled notification associated with the note
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
