import 'package:flutter/material.dart';

TextStyle interRegular({
  Color color = Colors.black,
  double fontSize = 16.0,
  double letterSpacing = 0.0,
  double wordSpacing = 0.0,
  TextDecoration decoration = TextDecoration.none,
}) {
  return TextStyle(
    fontFamily: 'Inter',
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.normal,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    decoration: decoration,
  );
}

TextStyle interBold({
  Color color = Colors.black,
  double fontSize = 16.0,
  double letterSpacing = 0.0,
  double wordSpacing = 0.0,
  TextDecoration decoration = TextDecoration.none,
}) {
  return TextStyle(
    fontFamily: 'Inter',
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    decoration: decoration,
  );
}

TextStyle interItalic({
  Color color = Colors.black,
  double fontSize = 16.0,
  double letterSpacing = 0.0,
  double wordSpacing = 0.0,
  TextDecoration decoration = TextDecoration.none,
}) {
  return TextStyle(
    fontFamily: 'Inter',
    color: color,
    fontSize: fontSize,
    fontStyle: FontStyle.italic,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    decoration: decoration,
  );
}

TextStyle interLight({
  Color color = Colors.black,
  double fontSize = 16.0,
  double letterSpacing = 0.0,
  double wordSpacing = 0.0,
  TextDecoration decoration = TextDecoration.none,
}) {
  return TextStyle(
    fontFamily: 'Inter',
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w300,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    decoration: decoration,
  );
}

TextStyle interMedium({
  Color color = Colors.black,
  double fontSize = 16.0,
  double letterSpacing = 0.0,
  double wordSpacing = 0.0,
  TextDecoration decoration = TextDecoration.none,
}) {
  return TextStyle(
    fontFamily: 'Inter',
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    decoration: decoration,
  );
}
