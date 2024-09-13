import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthhubcustomer/Controller/functions/image_custom_picker.dart';

import '../../../Model/fitness_goals.dart';
import '../../../Model/fitness_levels.dart';

class Signup3 extends StatefulWidget {
  const Signup3({super.key});

  @override
  State<Signup3> createState() => _Signup3State();
}

class _Signup3State extends State<Signup3> {
  List<File> beforePhotos = [];

  FitnessGoal selectedGoal = FitnessGoal(id: 0, goalName: 'Select Fitness Goal');
  FitnessLevel selectedLevel = FitnessLevel(id: 0, levelName: 'Select Fitness Level');

  List<FitnessGoal> fitnessGoals = [
    FitnessGoal(id: 1, goalName: 'Weight Loss'),
    FitnessGoal(id: 2, goalName: 'Muscle Gain'),
    FitnessGoal(id: 3, goalName: 'Weight Gain'),
    FitnessGoal(id: 4, goalName: 'Improved Endurance'),
    FitnessGoal(id: 5, goalName: 'Increased Flexibility'),
    FitnessGoal(id: 6, goalName: 'Better Sleep Quality'),
    FitnessGoal(id: 7, goalName: 'Stress Reduction'),
    FitnessGoal(id: 8, goalName: 'Enhanced Mental Health'),
    FitnessGoal(id: 9, goalName: 'Overall Wellness'),
    FitnessGoal(id: 10, goalName: 'Increased Energy Levels'),
  ];

  List<FitnessLevel> fitnessLevels = [
    FitnessLevel(id: 1, levelName: 'Beginner'),
    FitnessLevel(id: 2, levelName: 'Intermediate'),
    FitnessLevel(id: 3, levelName: 'Advanced'),
    FitnessLevel(id: 4, levelName: 'Expert'),
    FitnessLevel(id: 5, levelName: 'Professional'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              const AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Text(
                  "Last Step",
                  key: ValueKey<int>(1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
      
              const SizedBox(height: 16),
      
              // Fitness Goal Dropdown
              const Text(
                "Select Fitness Goal",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<FitnessGoal>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                value: selectedGoal.id == 0 ? null : selectedGoal,
                items: [
                  for (FitnessGoal goal in fitnessGoals)
                    DropdownMenuItem(
                      value: goal,
                      child: Text(goal.goalName),
                    )
                ],
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<FitnessLevel>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                value: selectedLevel.id == 0 ? null : selectedLevel,
                items: [
                  for (FitnessLevel level in fitnessLevels)
                    DropdownMenuItem(
                      value: level,
                      child: Text(level.levelName),
                    )
                ],
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "What motivates you to workout?",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
      
              const SizedBox(height: 16),
      
              // Before Photos
              Row(
                children: [
                  const Text(
                    "Before Photos",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
      
                  const Spacer(),
      
                   ElevatedButton(
                onPressed: () async {
                  List<File>? photos = await pickMultipleImages(context);
                  if (photos != null) {
                    setState(() {
                      beforePhotos = photos;
                    });
                  }
                },
                child: const Text("Upload Photos"),
              ),
                  
                ],
              ),
              const SizedBox(height: 8),
              beforePhotos.isNotEmpty
                  ? Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: beforePhotos.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  beforePhotos[index],
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: IconButton(
                                  icon: const Icon(

                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      beforePhotos.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : const Text(
                      "No photos uploaded.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
      
              const SizedBox(height: 16),
      
             
            ],
          ),
        ),
      ),
    );
  }
}
