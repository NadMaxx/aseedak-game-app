import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class CustomCircle extends StatelessWidget {
 final String image;
  const CustomCircle({super.key,required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset("circle".toSvgPath),
        SvgPicture.asset(image.toSvgPath),
      ],
    );
  }
}
