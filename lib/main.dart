import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:healthhubcustomer/Controller/providers/auth_provider.dart';
import 'package:healthhubcustomer/Services/notification_services.dart';
import 'package:provider/provider.dart';
import 'Controller/providers/day_phase_provider.dart';
import 'Controller/providers/step_counter_provider.dart';
import 'Controller/providers/theme_provider.dart';
import 'Controller/providers/wallet_skin_provider.dart';
import 'Controller/routes/custom_routes.dart';
import 'package:firebase_core/firebase_core.dart';

import 'utils/themes.dart';

// import "firebase_options.dart";
//

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
Future<void> main() async {

  // debugRepaintRainbowEnabled  = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);




//   await Firebase.initializeApp(

//     options: DefaultFirebaseOptions.currentPlatform,

// );

  // runApp(MyApp());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => WalletSkinProvider()),
      ChangeNotifierProvider(create: (context) => DayPhaseProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(
      create: (context) => AuthProvider(),),
      ChangeNotifierProvider(
      create: (context) => StepCounterProvider(),
      
      child: MyApp(),
    ),
  



    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

@override
  void initState() {
    super.initState();
    
  NotificationServices notificationServices = NotificationServices(context);
  notificationServices.requestNotificationPermission();
   
  NotificationServices(context).firebaseInit(context);

  }




  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(

      

      // theme: 
      theme: themeProvider.themeData,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      title: 'Flutter Theme Demo',
    );
  }
}
