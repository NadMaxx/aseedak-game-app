import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'splash_vm.dart';

class SplashView extends StatelessWidget {
  static const String route = '/splash';
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashVm>(builder: (context,  vm, child) {
      return Scaffold(
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(), // empty space at top
            Image.asset(
              "logo".toPngPath,
              width: 250.w,
              height: 120.h,
            ),
            SafeArea(
                bottom: true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: const CustomLoader(),
                )),
          ],
        )

      );
    });
  }
}
