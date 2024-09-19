import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';

Widget buildListTile({
  required String title,
  required IconData icon,
  required Function() onTap,
  required Color backgroundColor,
  double elevation = 6.0, // Slightly higher card elevation for better shadow
  double borderRadius = 16.0, // More rounded corners
  Color iconColor = Colors.blueAccent, // Default icon color
  Color textColor = Colors.black, // Default text color
  List<Color>? gradientColors, // Optional gradient colors for background
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(borderRadius),
    splashColor: Colors.blueAccent.withOpacity(0.1), // Gentle splash color effect
    child: Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias, // Clip the content inside card borders
      child: Container(
        decoration: BoxDecoration(
          gradient: gradientColors != null
              ? LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  shape: BoxShape.circle, // Circular background for icon
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 28.0, // Slightly bigger icon
                ),
              ),
              const SizedBox(width: 20), // Increase space between icon and text
              Expanded(
                child: Text(
                  title,
                  style: interBold(fontSize: 18, color: textColor),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black, // Subtle forward icon
                size: 20.0, // Slightly smaller icon for better balance
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
