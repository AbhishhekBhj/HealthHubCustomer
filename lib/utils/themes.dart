import 'package:flutter/material.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';

import '../colors/colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: appMainColor,
  primarySwatch: Colors.blue,
  
  scaffoldBackgroundColor: Colors.white,
  // Define text theme
 
  // App bar theme
  appBarTheme:  AppBarTheme(
    color: appMainColor,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: interBold(
      fontSize: 20,
      color: Colors.black,
    )

  ),
  // Button theme
  buttonTheme: const ButtonThemeData(
    buttonColor: appMainColor,
    textTheme: ButtonTextTheme.primary,
  ),
  // Card theme
  cardTheme: const CardTheme(
    color: Colors.white,
    shadowColor: Colors.black26,
    elevation: 4,
  ),
  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    labelStyle: const TextStyle(color: appMainColor),
  ),
  // Floating action button theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: appMainColor,
    foregroundColor: Colors.white,
  ),
  // Define other light theme properties here
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  primarySwatch: Colors.blue,
  
  scaffoldBackgroundColor: Colors.black,
  // Define text theme
  
  // App bar theme
  appBarTheme:  AppBarTheme(
    color: appMainColor,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: interBold(
      fontSize: 20,
      color: Colors.white,
    ),),
  // Button theme
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.black,
    textTheme: ButtonTextTheme.primary,
  ),
  // Card theme
  cardTheme: CardTheme(
    color: Colors.grey[850],
    shadowColor: Colors.black38,
    elevation: 4,
  ),
  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
   
  ),
  // Floating action button theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  // Define other dark theme properties here
);
