import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({super.key, this.hintText, this.labelText, this.isObscure, this.controller, this.keyboardType, this.isPassword, this.isEmail, this.isPhone, this.isNumber, this.isMultiline, this.maxLines, this.maxLength, this.isReadOnly, this.isRequired, this.isAutoFocus, this.isEnable, this.isFocus, this.isBorder, this.isUnderline, this.isFilled, this.onChanged, this.onSubmitted, this.onTap, this.onEditingComplete, this.onFieldSubmitted, this.onSaved, this.onValidate, this.onReset, this.validator, this.prefixIcon, this.suffixIcon});

  final String? hintText;
  final String? labelText;
  final bool? isObscure;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? isPassword;
  final bool? isEmail;
  final bool? isPhone;
  final bool? isNumber;
  final bool? isMultiline;
  final int? maxLines;
  final int? maxLength;
  final bool? isReadOnly;
  final bool? isRequired;
  final bool? isAutoFocus;
  final bool? isEnable;
  final bool? isFocus;
  final bool? isBorder;
  final bool? isUnderline;
  final bool? isFilled;

  final Widget? prefixIcon;
  final Widget? suffixIcon;



  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Function()? onFieldSubmitted;
  final Function()? onSaved;
  final Function()? onValidate;
  final Function()? onReset;

  // Validation
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isObscure ?? false,
      maxLines: isMultiline ?? false ? maxLines : 1,
      maxLength: maxLength,
      readOnly: isReadOnly ?? false,
      autofocus: isAutoFocus ?? false,
      enabled: isEnable ?? true,
      focusNode: isFocus ?? false ? FocusNode() : null,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        labelText: labelText,
        border: isBorder ?? false ? const OutlineInputBorder() : null,
        enabledBorder: isUnderline ?? false ? const UnderlineInputBorder() : null,
        filled: isFilled ?? false,
      ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      
      validator: validator,
    );
  }
}