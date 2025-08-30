import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomLoader extends StatefulWidget {
  const CustomLoader({super.key});

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Rotation speed
    )..repeat(); // keep rotating infinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.w,
      height: 48.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset("sq".toSvgPath),
          SizedBox(
            width: 30.w,
            height: 30.w,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 6.28319, // 2 * pi radians
                  child: child,
                );
              },
              child: Image.asset("loadder".toPngPath),
            ),
          ),
        ],
      ),
    );
  }
}
