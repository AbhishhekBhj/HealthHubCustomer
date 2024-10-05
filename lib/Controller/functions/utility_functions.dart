import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/Controller/functions/google_auth_func.dart';
import 'package:shared_preferences/shared_preferences.dart';

String returnCurrentPhaseOfDay(){
  DateTime now = DateTime.now();
  int hour = now.hour;

  if (hour < 12) {
    return 'morning';
  }
  if (hour < 17) {
    return 'afternoon';
  }
  return 'evening';
}

IconData returnIconDataBasedonPhaseofday(){

  DateTime now = DateTime.now();
  int hour = now.hour;

  if (hour < 12) {
    return Icons.wb_sunny;
  }
  if (hour < 17) {
    return Icons.wb_cloudy;
  }
  return Icons.nightlight_round;
}

Color returnIconColorBasedonPhaseofday(){

  DateTime now = DateTime.now();
  int hour = now.hour;

  if (hour < 12) {
    return Colors.yellow;
  }
  if (hour < 17) {
    return Colors.blue;
  }
  return Colors.black;
}


void logOut(BuildContext context) async {

  bool signedout = await signOutFromGoogle();
  signedout?SharedPreferences.getInstance().then((prefs) {
    prefs.clear();
    context.goNamed('signup');
  }):print('Error signing out');
  
  
}