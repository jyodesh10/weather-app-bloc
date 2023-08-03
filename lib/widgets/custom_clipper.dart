import 'package:flutter/material.dart';

class ClipPathClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;

    final path = Path();
    //(0,0) 1.Point
    path.lineTo(0, height); //2.Point
    path.quadraticBezierTo(
      width * 0.5, //3.Point --> width * 0.5, height - 100,
      height - 100,
      width, //4.Point --> width, height
      height,
    );
    path.lineTo(width, 0); //5.Point
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
