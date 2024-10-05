import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/Services/notification_services.dart';
import 'package:healthhubcustomer/View/OnBoarding/onboarding_base.dart';
import 'package:healthhubcustomer/utils/app_constants.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';
import 'package:healthhubcustomer/utils/shared_preference_helper.dart';
import 'package:permission_handler/permission_handler.dart';

import 'View/Auth/login/login_page.dart';
import "dart:developer";

import 'View/Auth/signup/signup_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late   NotificationServices _notificationServices;


 requestPermissions() async {
    await [
      Permission.camera,
      Permission.location,
      Permission.photos,
      Permission.notification,
    ].request();
  }




  SharedPreferenceHelper _sharedPreferenceHelper = SharedPreferenceHelper();

  @override
  void initState() {
    super.initState();

    _notificationServices = NotificationServices(context);

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    initializeFIrebase();
    requestPermissions();


     navigateFromSplashScreen();

  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }


  void initializeFIrebase()async{

    log("Firebase Init");

    await _notificationServices.getDeviceToken();

  }

  navigateFromSplashScreen() async
  {
    var hasSeen = await _sharedPreferenceHelper.getUserHasSeenOnboarding();
    var hasLogin = await _sharedPreferenceHelper.getUserLoggedIn();

     if (!mounted) return;  

    if (hasSeen) {
      log("Seen");
      if (hasLogin) {
        log("MainHome");
        context.pushNamed('mainhome');
      } else {

        log("Signup");

        context.pushNamed('signup');

        // Get.offAll(() => SignUpMainPage());
      }
    } else {
      log("Onboarding");
      // Get.offAll(() => OnboardingBase());
      context.pushNamed('onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // Text(appName, style: interBold(color: Colors.black, fontSize: 25 ),)
            SlideTransition(
  position: Tween<Offset>(
    begin: const Offset(0, 1),  // Start from bottom
    end: Offset.zero,  // Move to center
  ).animate(_animation),
  child: Image.asset(logo, height: 100, width: 100, fit: BoxFit.contain),
)

          
          ],
        ),
      ),
    );
  }
}
