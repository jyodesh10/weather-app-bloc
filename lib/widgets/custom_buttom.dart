import 'package:flutter/material.dart';

import '../constants.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;
  final String title;
  const CustomButton({super.key, required this.color, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      height: 45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      onPressed: onPressed,
      child: Text(title, style: titleStyle)
    );
  }
}