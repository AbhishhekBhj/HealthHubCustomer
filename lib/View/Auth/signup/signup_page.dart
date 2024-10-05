import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/View/Auth/login/login_page.dart';
import 'package:healthhubcustomer/View/widgets/buttons/healthhub_custom_button.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';

import '../../../Controller/functions/google_auth_func.dart';
import 'signup_2.dart';

class SignUpMainPage extends StatefulWidget {
   SignUpMainPage({super.key,});


  String userName = '';
  String imageUrl = '';

  @override
  State<SignUpMainPage> createState() => _SignUpMainPageState();
}

class _SignUpMainPageState extends State<SignUpMainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  UserCredential? userCredential;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Sign Up with Google Button
                  HealthhubCustomButton(
                    height: height * 0.05,
                    text: 'Sign Up with Google',
                    onPressed: () {
                      signin().then((value) {
                        if (value != null) {
                          userCredential = value;
                          log("User Signed In Successfully ${value}");
                          // context.pushNamed('signup2');
                          context.pushNamed(
  'signup2',
  pathParameters: {
    'imageUrl': '${userCredential?.user?.photoURL}',  // Pass the imageUrl
    'username': '${userCredential?.user?.displayName}',  // Pass the username
  },
);

                        }
                      });
                    },
                    backgroundColor: appMainColor,
                    textColor: appWhiteColor,
                    borderRadius: 12,
                     // Google Icon
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  

                  // Sign Up Button with animation
                  
                  const SizedBox(height: 16),

                  // Already have an account section with animations
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: interRegular(
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 0.0,
                            wordSpacing: 0.0,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.pushNamed('login');
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: appMainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential?> signin() async {
    var credential = await signInWithGoogle(context: context);
    log(credential.toString());
    if (credential != null) {
      return credential;
    } else {
      return null;
    }
  }
}
