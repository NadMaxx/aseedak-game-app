import 'package:aseedak/widgets/thick_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SlantedButtonStack extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  final double topHeight;
  final double topCut;
  final double fontSize;
  final double svgWidth;
  final double svgHeight;
  final bool leanLeft;

  const SlantedButtonStack({
    super.key,
    required this.text,
    required this.onPressed, this.fontSize = 22,
    this.topHeight = 60,
    this.topCut = 13,
    this.svgWidth = 35,
    this.svgHeight = 35,
    this.leanLeft = true,
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
        final double cutRatio = topCut / 320;
        final double topCutActual = cutRatio * topWidth;

        // Bottom layer (border) dimensions - needs to accommodate the slant
        final double bottomWidth = availableWidth;
        final double bottomHeight = topHeight + (borderThickness * 2);
        final double bottomCutActual = cutRatio * bottomWidth;

        return SizedBox(
          width: availableWidth,
          height: bottomHeight,
          child: Stack(
            children: [
              // --- Bottom Gradient Layer (Border) ---
              Positioned.fill(
                child: ClipPath(
                  clipper: _ParallelogramClipperByCut(
                    cut: bottomCutActual,
                    leanLeft: leanLeft,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Color(0xffCB1122),
                          Color(0xffCB1122),
                          Color(0xffCB1122),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
                      height: topHeight,
                      width: topWidth,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFbf1020),
                            Color(0xFFbf1020),
                            Color(0xFF840B16),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
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

              // --- SVG Overlay (only if wide enough) ---
              if (topWidth >= 280)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: SvgPicture.asset(
                      "assets/svgs/cut.svg",
                      height: svgHeight,
                      width: (svgWidth / 320) * topWidth,
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

// ---- Helpers ----
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