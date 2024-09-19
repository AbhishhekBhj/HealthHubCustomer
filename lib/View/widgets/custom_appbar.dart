import 'package:flutter/material.dart';

import '../../colors/colors.dart';

dynamic customAppBar({
  required String title,
  List<Widget>? actions,
  Color backgroundColor = Colors.blue,
  List<Color>? gradientColors,
  double elevation = 4.0,
  double borderRadius = 0.0,
  TextStyle? titleStyle,
  bool showBackButton = true,
  required BuildContext context,
}) {
  return PreferredSize(
    
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: AppBar(
      
      elevation: elevation,
      backgroundColor: gradientColors == null ? backgroundColor : null,
      flexibleSpace: gradientColors != null
          ? Container(
            
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(borderRadius),
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  title,
                  style: titleStyle ?? TextStyle(color: appWhiteColor, fontSize: 20),
                ),
                leading: showBackButton
                    ? IconButton(
                        icon: Icon(Icons.arrow_back, color: appWhiteColor),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    : null,
                actions: actions,
              ),
            )
          : AppBar(
              title: Text(
                title,
                style: titleStyle ?? TextStyle(color: appWhiteColor, fontSize: 20),
              ),
              leading: showBackButton
                  ? IconButton(
                      icon: Icon(Icons.arrow_back, color: appWhiteColor),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null,
              actions: actions,
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(borderRadius),
        ),
      ),
    ),
  );
}
