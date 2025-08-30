import 'dart:developer';

import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/start/auth/login/login_view.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

  final List<Map<String, String>> pages = [
    {
      "svg": "1",
      "title": "The Ultimate In-Person Word Assassination Game",
      "desc":
          "We bring friends together in a fun, face-to-face challenge where words are your weapons. Gather 2–6 players, launch the app, and let the deception begin. Talk smart, play smarter!",
    },
    {
      "svg": "2",
      "title": "Create or Join a Room to Get Started",
      "desc":
          "Explore helpful videos and insightful PDFs, carefully designed to support your well-being, strengthen your mindset, and guide you through each day with calm and confidence.",
    },
    {
      "svg": "3",
      "title": "Expand Your Game Size (In-App Purchases)",
      "desc":
          "Planning a party or game night? Upgrade your app to unlock support for up to 12 players in a single game. Perfect for big gatherings and even more chaotic fun!",
    },
  ];

  // Method to handle navigation
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
      log("Navigating to login screen");
      Navigator.pushReplacementNamed(context, LoginView.routeName);
    }
  }

  // Method to handle skip
  void _skipToEnd() {
    log("Skip to end called");
    Navigator.pushReplacementNamed(context, LoginView.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
            log("Current Page Changed: $_currentPage");
            log("Total Pages: ${pages.length}");
          });
        },
        itemBuilder: (context, index) {
          final page = pages[index];
          return Column(
            children: [
              /// Part 1: Top section (different color + svg)
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFF19344B), // change per design
                  child: Center(
                    child: SvgPicture.asset(
                      page["svg"]!.toSvgPath,
                      height: 300.h,
                    ),
                  ),
                ),
              ),

              /// Part 2: Middle section (description)
              if (index == 0)
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
                          textSpans: [
                            ColoredTextSpan.create(
                              "${page['title']!.split(" ")[0]} ${page['title']!.split(" ")[1]} ",
                              Colors.white,
                            ),
                            ColoredTextSpan.create(
                              '${page['title']!.split(" ")[2]} ',
                              Color(0xFFbf1020),
                            ),
                            ColoredTextSpan.create(
                              "${page['title']!.split(" ")[3]} ${page['title']!.split(" ")[4]} ${page['title']!.split(" ")[5]}",
                              Colors.white,
                            ),
                          ],
                          defaultStyle: TextStyle(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Teko',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        CustomText(
                          text: page["desc"]!,
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
              if (index == 1)
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
                          textSpans: [
                            ColoredTextSpan.create(
                              '${page['title']!.split(" ")[0]} ',
                              Color(0xFFbf1020),
                            ),
                            ColoredTextSpan.create(
                              '${page['title']!.split(" ")[1]} ',
                              Colors.white,
                            ),
                            ColoredTextSpan.create(
                              '${page['title']!.split(" ")[2]} ',
                              Color(0xFFbf1020),
                            ),
                            ColoredTextSpan.create(
                              "${page['title']!.split(" ")[3]} ${page['title']!.split(" ")[4]} ${page['title']!.split(" ")[5]} ${page['title']!.split(" ")[6]} ${page['title']!.split(" ")[7]}",
                              Colors.white,
                            ),
                          ],
                          defaultStyle: TextStyle(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Teko',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        CustomText(
                          text: page["desc"]!,
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
              if (index == 2)
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
                          textSpans: [
                            ColoredTextSpan.create(
                              "${page['title']!.split(" ")[0]} ${page['title']!.split(" ")[1]} ",
                              Colors.white,
                            ),
                            ColoredTextSpan.create(
                              '${page['title']!.split(" ")[2]} ${page['title']!.split(" ")[3]}\n',
                              Color(0xFFbf1020),
                            ),
                            ColoredTextSpan.create(
                              "${page['title']!.split(" ")[4]} ${page['title']!.split(" ")[5]} ",
                              Colors.white,
                            ),
                          ],
                          defaultStyle: TextStyle(
                            fontSize: 50.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Teko',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        CustomText(
                          text: page["desc"]!,
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

              /// Part 3: Bottom section (dots + buttons)
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
                        // makes selected dot wider
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
                          // Skip button - only show if not on last page
                          if (_currentPage != pages.length - 1)
                            Expanded(
                              child: SimpleSlantedButton(
                                text: "Skip",
                                onPressed: _skipToEnd,
                              ),
                            )
                          else
                            const SizedBox.shrink(),

                          SizedBox(width: 5.w),

                          // Next/Get Started button
                          if (_currentPage == pages.length - 1)
                            Expanded(
                              child: SlantedButtonStack(
                                text: "LET'S GET STARTED",
                                onPressed: _skipToEnd,
                              ),
                            )
                          else
                            Expanded(
                              child: SlantedButtonStack(
                                text:
                                    _currentPage == pages.length - 1
                                        ? "LET'S GET STARTED"
                                        : 'Next',
                                onPressed: _navigateToNextPage,
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
    );
  }
}
