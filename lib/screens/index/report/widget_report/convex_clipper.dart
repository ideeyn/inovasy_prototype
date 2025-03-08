import 'package:flutter/material.dart';

class BottomConvexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveHeight = size.height * 0.15; // Controls the convex depth

    path.moveTo(0, 0);
    path.lineTo(0, size.height - curveHeight);

    // Draw a slight convex curve at the bottom
    path.quadraticBezierTo(
      size.width / 2,
      size.height +
          curveHeight / 2, // Control point (higher makes it more convex)
      size.width, size.height - curveHeight, // End point
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
