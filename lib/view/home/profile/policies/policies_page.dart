import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PoliciesPage extends StatelessWidget {
  static const String routeName = '/policiesPage';

  const PoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset("back".toSvgPath),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          ListTile(
            leading: SizedBox(
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset("circle".toSvgPath),
                  Image.asset("kaghaz".toPngPath),
                ],
              ),
            ),
            title: CustomText(
              text: "Privacy Policy",
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            subtitle: CustomText(
              text: "Information we get & how it’s used.",
              fontSize: 12,
              fontWeight: FontWeight.normal,
              fontFamily: "Kanit",
            ),
            trailing: SvgPicture.asset("forward".toSvgPath),
          ),
          ListTile(
            leading: SizedBox(
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset("circle".toSvgPath),
                  Image.asset("kaghaz".toPngPath),
                ],
              ),
            ),
            title: CustomText(
              text: "Terms Of Services",
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            subtitle: CustomText(
              text: "Terms you agree, when you use app.",
              fontSize: 12,
              fontWeight: FontWeight.normal,
              fontFamily: "Kanit",
            ),
            trailing: SvgPicture.asset("forward".toSvgPath),
          ),
        ],
      ),
    );
  }
}
