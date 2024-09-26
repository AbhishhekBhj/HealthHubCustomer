import 'package:flutter/material.dart';

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