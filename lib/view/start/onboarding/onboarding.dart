import 'dart:developer';

import 'package:aseedak/data/utils/string_helpers.dart';
import 'dart:ui' as ui;
import 'package:aseedak/main.dart';
import 'package:aseedak/view/start/auth/login/login_view.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/simple_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../data/utils/sharedKeys.dart';
import '../../../widgets/colored_text.dart';
import '../../../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  List<Map<String, String>> pages = [];

  void _navigateToNextPage() {
    log("Navigate to next page called. Current page: $_currentPage");
    if (_currentPage < pages.length - 1) {
      setState(() {
        _currentPage++;
      });
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      prefsGlobal.setBool(key: SharedPrefsKeys.isFirstTime, value: false);
      log("Navigating to login screen");
      Navigator.pushReplacementNamed(context, LoginView.routeName);
    }
  }

  void _skipToEnd() {
    prefsGlobal.setBool(key: SharedPrefsKeys.isFirstTime, value: false);
    log("Skip to end called");
    Navigator.pushReplacementNamed(context, LoginView.routeName);
  }

  @override
  Widget build(BuildContext context) {
    pages = [
      {"svg": "1", "title": "title1".tr(), "desc": "desc1".tr()},
      {"svg": "2", "title": "title2".tr(), "desc": "desc2".tr()},
      {"svg": "3", "title": "title3".tr(), "desc": "desc3".tr()},
    ];

    return Scaffold(
      body: Directionality(
        textDirection: context.locale.languageCode == 'ar'
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: PageView.builder(
          controller: _controller,
          itemCount: pages.length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
              log("Current Page Changed: $_currentPage");
            });
          },
          itemBuilder: (context, index) {
            final page = pages[index];
            return Column(
              children: [
                /// Top Section (SVG)
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFF19344B),
                    child: Center(
                      child: SvgPicture.asset(
                        page["svg"]!.toSvgPath,
                        height: 300.h,
                      ),
                    ),
                  ),
                ),

                /// Middle Section (Text + Desc)
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFF0C2431),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ColoredText(
                          textSpans: _buildColoredSpans(page['title'] ?? ""),
                          defaultStyle: TextStyle(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Teko',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        CustomText(
                          text: page["desc"] ?? "",
                          textAlign: TextAlign.center,
                          fontSize: 18.sp,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w300,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ),

                /// Bottom Section (Dots + Buttons)
                Container(
                  width: double.infinity,
                  color: const Color(0xFF0C2431),
                  child: Column(
                    children: [
                      SmoothPageIndicator(
                        controller: _controller,
                        count: pages.length,
                        effect: const ExpandingDotsEffect(
                          expansionFactor: 3,
                          dotHeight: 4,
                          dotWidth: 8,
                          activeDotColor: Colors.red,
                          dotColor: Color(0xffE6E6E6),
                          radius: 8,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Divider(
                        color: Colors.white.withOpacity(0.3),
                        thickness: 1,
                        height: 1,
                      ),
                      SafeArea(
                        top: false,
                        minimum: EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                          bottom: 45.0.h,
                          top: 10.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentPage != pages.length - 1)
                              Expanded(
                                child: SimpleSlantedButton(
                                  text: "skip".tr(),
                                  onPressed: _skipToEnd,
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: SlantedButtonStack(
                                text:
                                    _currentPage == pages.length - 1
                                        ? "LET'S GET STARTED".tr()
                                        : "next".tr(),
                                onPressed:
                                    _currentPage == pages.length - 1
                                        ? _skipToEnd
                                        : _navigateToNextPage,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 🔑 Safe ColoredText builder
  List<TextSpan> _buildColoredSpans(String title) {
    final words = title.split(" ");

    if (words.isEmpty) {
      return [ColoredTextSpan.create("", Colors.white)];
    }

    return [
      // First 2 words → white
      ColoredTextSpan.create(
        words.take(2).join(" ") + (words.length > 2 ? " " : ""),
        Colors.white,
      ),

      // Third word → red
      if (words.length > 2)
        ColoredTextSpan.create("${words[2]} ", const Color(0xFFbf1020)),

      // Remaining → white
      if (words.length > 3)
        ColoredTextSpan.create(words.sublist(3).join(" "), Colors.white),
    ];
  }
}
