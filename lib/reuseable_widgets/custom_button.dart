import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget? buttonName; //for showing indicator it is necessory
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;

  final double borderRadius;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.backgroundColor = Colors.deepPurpleAccent,
    this.textColor = Colors.white,
    this.borderRadius = 8.0,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 2,
      ),
      child: buttonName, //adding $ because text is already a Text widget
    );
  }
}
