import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/Controller/functions/image_custom_picker.dart';
import 'package:healthhubcustomer/Model/activity_levels.dart';
import 'package:healthhubcustomer/Model/genders.dart';
import 'package:healthhubcustomer/Model/user_model.dart';
import 'package:healthhubcustomer/View/Auth/signup/signup_3.dart';
import 'package:healthhubcustomer/View/widgets/textfields/custom_textfield.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';
import 'package:provider/provider.dart';

import '../../../Controller/providers/auth_provider.dart';
import '../../widgets/buttons/healthhub_custom_button.dart';

class Signup2 extends StatefulWidget {
   Signup2({super.key, this.username, this.imageUrl} );

  
dynamic username;
dynamic imageUrl;

  @override
  State<Signup2> createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> with SingleTickerProviderStateMixin {
  final TextEditingController _bioController = TextEditingController();
  File? image;
  double initialWeight = 70;
  double initialHeight = 170;
  ActivityLevels? selectedActivityLevel;
  Genders? selectedGender;
  String dateofBirth="";
  String bio = "";
  double age = 14.0;


  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

   final TextEditingController _usernameController = TextEditingController();

  List<Genders> genders = [
    Genders(id: 2, genderName: "Male"),
    Genders(id: 3, genderName: "Female"),
  ];

  List<ActivityLevels> activityLevels = [
    ActivityLevels(id: 1, activityLevelName: "Little to No Exercise"),
    ActivityLevels(id: 2, activityLevelName: "Light Exercise (1-3 days per week)"),
    ActivityLevels(id: 3, activityLevelName: "Moderate Exercise (3-5 days per week)"),
    ActivityLevels(id: 4, activityLevelName: "Heavy Exercise (6-7 days per week)"),
    ActivityLevels(id: 5, activityLevelName: "Strenuous Exercise (twice per day, extra heavy workouts)"),
  ];

  @override
  void initState() {
    super.initState();
    selectedActivityLevel = activityLevels[0];
    selectedGender = genders[0];

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var authProvider = Provider.of<AuthProvider>(context);
    final height = MediaQuery.of(context).size.height;;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                     SizedBox(height: 20),
                    Text(
                      "Almost there!",
                      style: interBold(color: appMainColor, fontSize: 30),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Now we need some extra details to customize your experience",
                      style: interRegular(color: const Color(0xff7C7C7C), fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                     const SizedBox(height: 16),
                  CustomTextfield(
                    isBorder: true,
                    controller: _usernameController,
                    hintText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                  ),
                    Text(
                      "Select A Profile Picture",
                      style: interRegular(color: appMainColor, fontSize: 16),
                    ),
                    const SizedBox(height: 10),


                    widget.imageUrl != null
                        ? ClipOval(
                            child: Image.network(
                              widget.imageUrl,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        :


                    GestureDetector(
                      onTap: () async {
                        // Show bottom sheet for image selection
                        image = await imagePickAndCrop(context: context);
                        setState(() {});
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: appMainColor, width: 2),
                        ),
                        child: image == null
                            ? const Icon(Icons.add_a_photo, size: 40, color: appMainColor)
                            : ClipOval(child: Image.file(image!, fit: BoxFit.cover)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "How active are you?",
                      style: interRegular(color: appMainColor, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<ActivityLevels>(
                      items: [
                        for (ActivityLevels activityLevel in activityLevels)
                          DropdownMenuItem(
                            value: activityLevel,
                            child: Text(
                              activityLevel.activityLevelName,
                              style: interRegular(color: appMainColor, fontSize: 12),
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedActivityLevel = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Select Your Gender",
                      style: interRegular(color: appMainColor, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<Genders>(
                      items: [
                        for (Genders gender in genders)
                          DropdownMenuItem(
                            value: gender,
                            child: Text(
                              gender.genderName,
                              style: interRegular(color: appMainColor, fontSize: 14),
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Weight (kg): ${initialWeight.toInt()}",
                      style: interRegular(color: appMainColor, fontSize: 16),
                    ),
                    Slider(
                      value: initialWeight,
                      onChanged: (value) {
                        setState(() {
                          initialWeight = value;
                        });
                      },
                      min: 30,
                      max: 150,
                      divisions: 120,
                      label: initialWeight.toString(),
                      activeColor: appMainColor,
                      inactiveColor: Colors.grey[300],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Height (cm): ${initialHeight.toInt()}",
                      style: interRegular(color: appMainColor, fontSize: 16),
                    ),
                    Slider(
                      value: initialHeight,
                      onChanged: (value) {
                        setState(() {
                          initialHeight = value;
                        });
                      },
                      min: 100,
                      max: 250,
                      divisions: 100,
                      label: initialHeight.toString(),
                      activeColor: appMainColor,
                      inactiveColor: Colors.grey[300],
                    ),

                     Text(
                      "Age: ${age.toInt()}",
                      style: interRegular(color: appMainColor, fontSize: 16),
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
                    }),
                    const SizedBox(height: 20),
                    CustomTextfield(
                      maxLines: 5,
                      controller: _bioController,
                      hintText: "Write about yourself",
                      isBorder: true,
                    ),

                    const SizedBox(height: 20),

                    HealthhubCustomButton(
                    height: height * 0.05,
                    text: 'Continue',
                    onPressed: () async {
                      // Get.to(() => const Signup3());
                      // context.pushNamed('signup3');
                 await     authProvider.signUpUserProfile(User(
                        userName: _usernameController.text,
                        profilePictureUrl: widget.imageUrl,
                        bio: _bioController.text,
                        weight: initialWeight.toInt(),
                        height: initialHeight.toInt(),
                        age: age.toInt(),
                        activityLevelId: selectedActivityLevel!.id,

                      ));
                    },
                    backgroundColor: appMainColor,
                    textColor: appWhiteColor,
                    borderRadius: 12,
                  ),
                  ],

                  
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
