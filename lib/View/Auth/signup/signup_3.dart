import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:healthhubcustomer/utils/shared_preference_helper.dart';
import 'package:healthhubcustomer/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Controller/functions/image_custom_picker.dart';
import '../../../Model/fitness_goals.dart';
import '../../../Model/fitness_levels.dart';
import '../../../utils/custom_textStyles.dart';
import '../../widgets/buttons/healthhub_custom_button.dart';

class Signup3 extends StatefulWidget {
  const Signup3({super.key});

  @override
  State<Signup3> createState() => _Signup3State();
}

class _Signup3State extends State<Signup3> with SingleTickerProviderStateMixin {
  List<File> beforePhotos = [];
  FitnessGoal selectedGoal =
      FitnessGoal(id: 0, goalName: 'Select Fitness Goal');
  FitnessLevel selectedLevel =
      FitnessLevel(id: 0, levelName: 'Select Fitness Level');

  AnimationController? _buttonController;
 
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<FitnessGoal> fitnessGoals = [
    FitnessGoal(id: 3, goalName: 'Weight Loss'),
    FitnessGoal(id: 5, goalName: 'Muscle Gain'),
    FitnessGoal(id: 4, goalName: 'Maintain Weight'),
  ];

  List<FitnessLevel> fitnessLevels = [
    FitnessLevel(id: 2, levelName: 'Beginner'),
    FitnessLevel(id: 2, levelName: 'Intermediate'),
    FitnessLevel(id: 3, levelName: 'Advanced'),

  ];

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController!, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _buttonController!, curve: Curves.easeInOut),
    );

    _buttonController?.forward();
  }

  @override
  void dispose() {
    _buttonController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: HealthHubPadding.allPagesPadding(context),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Final Step",
                          style: interBold(
                            fontSize: 24,
                            color: appMainColor,
                          )
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Complete your profile by adding your goals, fitness level, and uploading your before photos.",
                          style: interMedium(
                            fontSize: 16,
                            color: appMainColor,
                          )
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
            
                // Fitness Goal Dropdown
                const Text(
                  "Select Fitness Goal",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<FitnessGoal>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    
                  ),
                  value: selectedGoal.id == 0 ? null : selectedGoal,
                  items: fitnessGoals.map((FitnessGoal goal) {
                    return DropdownMenuItem(
                      value: goal,
                      child: Text(goal.goalName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGoal = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
            
                // Fitness Level Dropdown
                const Text(
                  "Select Fitness Level",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<FitnessLevel>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                   
                  ),
                  value: selectedLevel.id == 0 ? null : selectedLevel,
                  items: fitnessLevels.map((FitnessLevel level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level.levelName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLevel = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
            
                // Motivation Text Field
                const Text(
                  "Motivation",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "What motivates you to workout?",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                   
                  ),
                  enabled: selectedGoal.id != 0 && selectedLevel.id != 0,
                ),
                const SizedBox(height: 24),
            
                // Before Photos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Before Photos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        List<File>? photos = await pickMultipleImages(context);
                        if (photos != null) {
                          setState(() {
                            beforePhotos = photos;
                          });
                        }
                      },
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Upload Photos"),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                beforePhotos.isNotEmpty
                    ? SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: beforePhotos.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(beforePhotos[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        beforePhotos.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : const Text(
                        "No photos uploaded yet.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                const SizedBox(height: 24),
            
                // Finish Button
                ScaleTransition(
                  scale: Tween(begin: 1.0, end: 1.1).animate(
                    CurvedAnimation(
                      parent: _buttonController!,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: HealthhubCustomButton(
                    height: 40,
                    textColor: Colors.white,
                    backgroundColor: appMainColor,
                    width: double.infinity,
                    text: "Finish",
                    onPressed: () {
                      _buttonController?.forward().then((value) {
                       SharedPreferenceHelper(). saveUserLoggedIn(true);
                        context.pushNamed("mainhome");
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
