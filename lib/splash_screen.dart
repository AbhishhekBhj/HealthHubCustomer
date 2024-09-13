import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthhubcustomer/View/OnBoarding/onboarding_base.dart';
import 'package:healthhubcustomer/utils/app_constants.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';
import 'package:healthhubcustomer/utils/shared_preference_helper.dart';

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


  SharedPreferenceHelper _sharedPreferenceHelper = SharedPreferenceHelper();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

     navigateFromSplashScreen();
  }

  @override
  void dispose() {
    _controller.dispose();

navigateFromSplashScreen();
    super.dispose();
  }

  navigateFromSplashScreen() async
  {
    var hasSeen = await _sharedPreferenceHelper.getUserHasSeenOnboarding();
    var hasLogin = await _sharedPreferenceHelper.getUserLoggedIn();

    if (hasSeen) {
      if (hasLogin) {
        Get.offAll(() => LoginPage());
      } else {
        Get.offAll(() => SignUpMainPage());
      }
    } else {
      Get.offAll(() => OnboardingBase());
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
  child: Text(appName, style: interBold(color: Colors.black, fontSize: 25)),
)

          
          ],
        ),
      ),
    );
  }
}
