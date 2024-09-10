import 'package:flutter/material.dart';

class HealthhubCustomButton extends StatelessWidget {
  const HealthhubCustomButton({super.key, this.text, this.onPressed, this.isEnable, this.backgroundColor, this.textColor, this.width, this.height, this.borderRadius, this.fontSize, this.fontWeight});

  final String? text;
  final Function()? onPressed;
  final bool? isEnable;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnable ?? true ? onPressed : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
        ),
        alignment: Alignment.center,
        child: Text(
          text ?? '',
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}