import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthhubcustomer/View/Auth/signup/signup_page.dart';
import 'package:healthhubcustomer/View/widgets/buttons/healthhub_custom_button.dart';
import 'package:healthhubcustomer/View/widgets/textfields/custom_textfield.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';

import '../../../Controller/functions/google_auth_func.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool isObscure = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleObscure() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: interBold(color: appMainColor, fontSize: 30),
                  ),
                  Text(
                    "Access your Account",
                    style: interBold(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Animate the text fields
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0), // Slide from bottom
                end: Offset.zero, // End at center
              ).animate(_animation),
              child: CustomTextfield(
                prefixIcon: const Icon(Icons.email),
                isEmail: true,
                hintText: "Enter your email address",
                isBorder: true,
                controller: _emailController,
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0), // Slide from bottom
                end: Offset.zero, // End at center
              ).animate(_animation),
              child: CustomTextfield(
                isObscure: isObscure,
                prefixIcon: const Icon(Icons.lock),
                hintText: "Enter your password",
                isBorder: true,
                controller: _passwordController,
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _animation,
              child: HealthhubCustomButton(
                textColor: Colors.white,
                height: Get.height * 0.05,
                onPressed: () {},
                backgroundColor: appMainColor,
                borderRadius: 10,
                text: "Sign in",
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 3,
                    color: appMainColor,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "OR",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: appMainColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 3,
                    color: appMainColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Google button
            FadeTransition(
              opacity: _animation,
              child: HealthhubCustomButton(
                onPressed: signIn,
                backgroundColor: Colors.grey.shade200,
                height: Get.height * 0.07,
                text: "Continue with Google",
                textColor: Colors.black,
                borderRadius: 12,
              ),
            ),

             Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(" Don't  have an account?",style: interRegular(
                    color: Colors.black,
                    fontSize: 16,
                    letterSpacing: 0.0,
                    wordSpacing: 0.0,
                    decoration: TextDecoration.none,
                   ),),
                  TextButton(
                    onPressed: () {

                      Get.offAll(const SignUpMainPage());

                    },
                    child: const Text('Sign Up', style: TextStyle(
                      color: appMainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }



  Future<void> signIn() async{
   UserCredential? credential =  await signInWithGoogle();

  }
}
