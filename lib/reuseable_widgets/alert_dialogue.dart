import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions; // Buttons list (e.g., [Cancel, Confirm])
  final bool barrierDismissible; // Outside tap se close?

  const MyAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.barrierDismissible = true, // Default: Yes, close on outside tap
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Styling: Aapki app theme se match
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        title,
        style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
      ),
      content: content,
      actions: actions, // Custom buttons pass karo
      // Optional: Outside tap se close
      insetPadding: EdgeInsets.all(20),
    );
  }
}
