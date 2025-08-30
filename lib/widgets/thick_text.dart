import 'package:flutter/material.dart';

class ThickShadowText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color shadowColor;
  final double shadowThickness;
  final double shadowBlur;
  final double letterSpacing;
  final String fontFamily;

  const ThickShadowText({
    super.key,
    required this.text,
    this.fontSize = 22,
    this.fontWeight = FontWeight.w900,
    this.textColor = Colors.white,
    this.shadowColor = Colors.black,
    this.shadowThickness = 2.0,
    this.shadowBlur = 0.0,
    this.letterSpacing = 1.5,
    this.fontFamily = 'Teko',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Shadow layers for all 8 directions
        // Top-left
        Transform.translate(
          offset: Offset(-shadowThickness, -shadowThickness),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
              color: shadowColor,
              letterSpacing: letterSpacing,
            ),
          ),
        ),
        // Top
        Transform.translate(
          offset: Offset(0, -shadowThickness),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
              color: shadowColor,
              letterSpacing: letterSpacing,
            ),
          ),
        ),
        // Top-right
        Transform.translate(
          offset: Offset(shadowThickness, -shadowThickness),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
              color: shadowColor,
              letterSpacing: letterSpacing,
            ),
          ),
        ),
        // Right
        Transform.translate(
          offset: Offset(shadowThickness, 0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: shadowColor,
              letterSpacing: letterSpacing,
            ),
          ),
        ),
        // Bottom-right (extra thick)
        Transform.translate(
          offset: Offset(shadowThickness, shadowThickness * 1.5),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: shadowColor,
              letterSpacing: letterSpacing,
            ),
          ),
        ),
        // Bottom (extra thick)
        Transform.translate(
          offset: Offset(0, shadowThickness * 1.5),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: shadowColor,
              letterSpacing: letterSpacing,
            ),
          ),
        ),
        // Bottom-left (extra thick)
        Transform.translate(
          offset: Offset(-shadowThickness, shadowThickness * 1.5),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: shadowColor,
              letterSpacing: letterSpacing,
            ),
          ),
        ),
        // Left
        Transform.translate(
          offset: Offset(-shadowThickness, 0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: shadowColor,
              letterSpacing: letterSpacing,
            ),
          ),
        ),

        // Main text on top
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
            color: textColor,
            letterSpacing: letterSpacing,
            shadows: shadowBlur > 0 ? [
              Shadow(
                offset: Offset(0, 0),
                blurRadius: shadowBlur,
                color: shadowColor,
              ),
            ] : null,
          ),
        ),
      ],
    );
  }
}

// Alternative version with customizable shadow directions
class CustomShadowText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color shadowColor;
  final double shadowOffset;
  final List<Offset> shadowDirections;
  final double letterSpacing;
  final String fontFamily;

  const CustomShadowText({
    super.key,
    required this.text,
    this.fontSize = 22,
    this.fontWeight = FontWeight.w900,
    this.textColor = Colors.white,
    this.shadowColor = Colors.black,
    this.shadowOffset = 2.0,
    this.letterSpacing = 1.5,
    this.fontFamily = 'Teko',
    this.shadowDirections = const [
      Offset(-1, -1), // Top-left
      Offset(0, -1),  // Top
      Offset(1, -1),  // Top-right
      Offset(1, 0),   // Right
      Offset(1, 1.5), // Bottom-right (extra)
      Offset(0, 1.5), // Bottom (extra)
      Offset(-1, 1.5),// Bottom-left (extra)
      Offset(-1, 0),  // Left
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Create shadow for each direction
        ...shadowDirections.map((direction) => Transform.translate(
          offset: Offset(
            direction.dx * shadowOffset,
            direction.dy * shadowOffset,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: shadowColor,
              letterSpacing: letterSpacing,
            ),
          ),
        )),

        // Main text on top
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
            color: textColor,
            letterSpacing: letterSpacing,
          ),
        ),
      ],
    );
  }
}