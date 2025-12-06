import 'package:flutter/material.dart';

class AppFormField extends StatelessWidget {
  final String? hintText;
  final Text labelText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final bool? obscureText;
  final void Function(String)? onFieldSubmitted;
  final Icon? prefixIcon;
  final Color? decorationColor;
  final TextStyle? style;
  final Color? cursorColor;
  final AutovalidateMode? autovalidateMode;

  const AppFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.prefixIcon,
    this.validator,
    this.obscureText,
    this.onFieldSubmitted,
    this.decorationColor,
    this.style,
    this.cursorColor,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);
    final baseBorderColor = decorationColor ?? Colors.blue;

    return TextFormField(
      key: key, // <-- Only fix needed (NO color changes!)
      controller: controller,
      validator: validator,
      obscureText: obscureText ?? false,
      onFieldSubmitted: onFieldSubmitted,
      cursorColor: cursorColor ?? baseBorderColor,
      style: style ?? const TextStyle(color: Colors.black),
      autovalidateMode: autovalidateMode,

      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        label: labelText,
        labelStyle: TextStyle(color: baseBorderColor),

        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: baseBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: baseBorderColor), // NO color change
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: baseBorderColor, width: 2),
        ),

        // Your original error colors (untouched)
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),

        errorStyle: const TextStyle(
          color: Colors.red, // EXACT same color you used
          fontSize: 10,
        ),
      ),
    );
  }
}
