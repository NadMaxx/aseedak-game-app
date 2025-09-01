import 'dart:ui';
import 'package:flutter/material.dart';

class StretchedBlurredOval extends StatelessWidget {
  final double sigma;
  final Color color;

  const StretchedBlurredOval({
    Key? key,
    this.sigma = 40, // blur strength
    this.color = const Color(0xFF6EE7B7),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 1.6, // make it wider than screen
      height: screenWidth * 0.8, // control oval height
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(1),
            borderRadius: BorderRadius.circular(screenWidth), // oval shape
          ),
        ),
      ),
    );
  }
}
