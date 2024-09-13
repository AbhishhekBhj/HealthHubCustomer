import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthhubcustomer/Controller/Sensor/senor_controller.dart';
import 'package:healthhubcustomer/splash_screen.dart';
import 'View/Auth/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
// import "firebase_options.dart";
// 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(

//     options: DefaultFirebaseOptions.currentPlatform,

// );


  
  
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  
  

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Theme Demo',
      
      home: SplashScreen(),
    );
  }
}
