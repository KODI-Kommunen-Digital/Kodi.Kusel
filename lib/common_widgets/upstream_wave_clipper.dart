import 'package:flutter/cupertino.dart';

class UpstreamWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Starting from bottom-left corner
    path.moveTo(0, size.height-40);

    // First wave - pointing outwards
    path.quadraticBezierTo(
      size.width / 4 -40, // Control point X
      size.height + 25, // Control point Y (moved upwards)
      size.width / 2 - 60, // End point X
      size.height-36, // End point Y
    );


    // First wave - pointing outwards
    path.quadraticBezierTo(
      size.width / 2, // Control point X
      size.height -80, // Control point Y (moved upwards)
      size.width *0.6+10, // End point X
      size.height-62, // End point Y
    );

    // Second wave - pointing inwards (default)
    path.quadraticBezierTo(
      size.width*0.75+40, // Control point X
      size.height - 28, // Control point Y
      size.width, // End point X
      size.height-90, // End point Y
    );

    // Line to bottom-right corner
    path.lineTo(size.width, 0);

    // Line back to top-left corner
    path.lineTo(0, 0);

    // Closing the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
