import 'dart:ui' as ui;

import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PoliciesPage extends StatelessWidget {
  static const String routeName = '/policiesPage';

  const PoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: RotatedBox(
              quarterTurns: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset("back".toSvgPath),
              ),
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
                text: "Privacy Policy".tr(),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              subtitle: CustomText(
                text: "privacy_policy_description".tr(),
                fontSize: 12,
                fontWeight: FontWeight.normal,
                fontFamily: "Kanit",
              ),
              trailing: RotatedBox(quarterTurns: 2,
              child: SvgPicture.asset("forward".toSvgPath)),
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
                text: "Terms of Service".tr(),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              subtitle: CustomText(
                text: "terms_of_service_description".tr(),
                fontSize: 12,
                fontWeight: FontWeight.normal,
                fontFamily: "Kanit",
              ),
              trailing: RotatedBox(
                  quarterTurns: 2,
                  child: SvgPicture.asset("forward".toSvgPath)),
            ),
          ],
        ),
      ),
    );
  }
}
