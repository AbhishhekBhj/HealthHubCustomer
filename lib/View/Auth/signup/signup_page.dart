import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthhubcustomer/View/Auth/login/login_page.dart';
import 'package:healthhubcustomer/View/widgets/buttons/healthhub_custom_button.dart';
import 'package:healthhubcustomer/View/widgets/textfields/custom_textfield.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';

import 'signup_2.dart';

class SignUpMainPage extends StatefulWidget {
  const SignUpMainPage({super.key});

  @override
  State<SignUpMainPage> createState() => _SignUpMainPageState();
}

class _SignUpMainPageState extends State<SignUpMainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  double age = 14.0;

  @override
  void initState() {
    super.initState();
    // Initialize the Animation Controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Define a Fade Animation and Slide Animation
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

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text("Create an Account", style: interBold(fontSize: 30, color: appMainColor),),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    isBorder: true,
                    controller: _usernameController,
                    hintText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    isBorder: true,
                    controller: _emailController,
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    isBorder: true,
                    controller: _passwordController,
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    isObscure: true,
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    isBorder: true,
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock),
                    isObscure: true,
                  ),
                  const SizedBox(height: 16),
                  // Slider for age selection
                  Text(
                    'Select Your Age: ${age.toInt()} years',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Slider.adaptive(
                    activeColor: appMainColor,
                    value: age,
                    min: 14, // Minimum age
                    max: 90, // Maximum age
                    divisions: 76, // Optional: For more granular control
                    label: age.toInt().toString(),
                    onChanged: (value) {
                      setState(() {
                        age = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Sign Up Button with animation
                  ScaleTransition(
                    scale: _fadeAnimation,
                    child: HealthhubCustomButton(
                      height: Get.height * 0.05,
                      text: 'Sign Up',
                      onPressed: () {
                        Get.to(() => const Signup2());
                      },
                      backgroundColor: appMainColor,
                      textColor: Colors.white,
                      borderRadius: 12,
                    ),
                  ),
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
                            Get.offAll(const LoginPage());
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                color: appMainColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
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
}
