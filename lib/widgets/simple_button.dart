import 'package:aseedak/widgets/thick_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SimpleSlantedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double cut;
  final bool leanLeft;
  final double fontSize;
  final Color? color;
  const SimpleSlantedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 60,
    this.cut = 13,
    this.leanLeft = true,
    this.fontSize = 22,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;

        // Define border thickness
        final double borderThickness = 4;

        // Top button dimensions
        final double topWidth = availableWidth - (borderThickness * 2);
        final double cutRatio = cut / 320;
        final double topCutActual = cutRatio * topWidth;

        // Bottom layer (border) dimensions
        final double bottomWidth = availableWidth;
        final double bottomHeight = height + (borderThickness * 2);
        final double bottomCutActual = cutRatio * bottomWidth;

        return SizedBox(
          width: availableWidth,
          height: bottomHeight,
          child: Stack(
            children: [
              // --- Bottom Layer (Lighter shade border) ---
              Positioned.fill(
                child: ClipPath(
                  clipper: _ParallelogramClipperByCut(
                    cut: bottomCutActual,
                    leanLeft: leanLeft,
                  ),
                  child: Container(
                    decoration:  BoxDecoration(
                      color:  Color(0xFF7A9BC4), // Lighter shade of #537DAC
                    ),
                  ),
                ),
              ),

              // --- Top Main Button (Centered) ---
              Center(
                child: GestureDetector(
                  onTap: onPressed,
                  child: ClipPath(
                    clipper: _ParallelogramClipperByCut(
                      cut: topCutActual,
                      leanLeft: leanLeft,
                    ),
                    child: Container(
                      height: height,
                      width: topWidth,
                      decoration:  BoxDecoration(
                        color: color ??  Color(0xFF537DAC), // Main color
                      ),
                      child: Center(
                          child: ThickShadowText(
                            text: text,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w900,
                            textColor: Colors.white,
                            shadowColor: Colors.black,
                            shadowThickness: 2.0,  // How far the shadow extends
                            shadowBlur: 0.0,       // Additional blur (optional)
                            letterSpacing: 1.5,
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---- Helper Clipper ----
class _ParallelogramClipperByCut extends CustomClipper<Path> {
  final double cut;
  final bool leanLeft;

  const _ParallelogramClipperByCut({
    required this.cut,
    this.leanLeft = true,
  });

  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;

    if (leanLeft) {
      return Path()
        ..moveTo(cut, 0)
        ..lineTo(w, 0)
        ..lineTo(w - cut, h)
        ..lineTo(0, h)
        ..close();
    } else {
      return Path()
        ..moveTo(0, 0)
        ..lineTo(w - cut, 0)
        ..lineTo(w, h)
        ..lineTo(cut, h)
        ..close();
    }
  }

  @override
  bool shouldReclip(covariant _ParallelogramClipperByCut oldClipper) {
    return oldClipper.cut != cut || oldClipper.leanLeft != leanLeft;
  }
}