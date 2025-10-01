import 'dart:ui' as ui;
import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/app_constants.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/home/game_room/game_room_vm.dart';
import 'package:aseedak/widgets/custom_button.dart';
import 'package:aseedak/widgets/custom_loader.dart';
import 'package:aseedak/widgets/custom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:provider/provider.dart';
import '../../../widgets/customText.dart';
import '../../../widgets/thick_text.dart';

class GameRoom extends StatefulWidget {
  static const String routeName = '/gameRoom';

  const GameRoom({super.key});

  @override
  State<GameRoom> createState() => _GameRoomState();
}

class _GameRoomState extends State<GameRoom> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> _titles = ["Target", "Word", "My Character"];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameRoomVm>(
      builder: (context, vm, _) {
        return Directionality(
          textDirection: context.locale.languageCode == 'ar'
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
          child: PopScope(
            canPop: false,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: CustomText(
                  text: _titles[_currentIndex], // <-- Dynamic title
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                ),
                leading: InkWell(
                  onTap: () {
                    showCustomSheetWithContent(
                      children: Column(
                        children: [
                          CustomText(
                            text: "quit_game".tr(),
                            fontFamily: "Kanit",
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                          ),
                          SizedBox(height: 10.h),
                          Divider(),
                        ],
                      ),
                      confirmText: "yes_quit".tr(),
                      onConfirmPressed: () {
                        // Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: SvgPicture.asset("back".toSvgPath),
                    ),
                  ),
                ),
              ),
              body: vm.isLoading
                  ? const Center(child: CustomLoader())
                  : Column(
                children: [
                  SizedBox(
                    height: AppConstants.getScreenHeight(context) * 0.65,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 3,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildTargetCard(context, vm);
                        } else if (index == 1) {
                          return _buildWordCard(context, vm);
                        } else {
                          return _buildCharacterCard(context, vm);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.white.withOpacity(0.6)),
                      ),
                      child: Row(
                        children: [
                          CustomText(
                            text: "Players",
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          const Spacer(),
                          CustomText(
                            text:
                            "${vm.roomDetail.room!.players!.length}/${vm.roomDetail.room!.maxPlayers}",
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:

                    vm.requestingKill ?
                    Center(child: CustomLoader(),):
                    SlantedButtonStack(
                      text: "Target Assassinated".tr(),
                      onPressed: () {
                        vm.requestKill();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------- Helper widgets for cards ----------------

  Widget _buildTargetCard(BuildContext context, GameRoomVm vm) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      height: AppConstants.getScreenHeight(context) * 0.65,
      width: AppConstants.getScreenWidth(context) * 0.9,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("card".toPngPath),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          vm.myTarget.character != null
              ? Image.network(
            vm.myTarget.character!.imageUrl!,
            height: 300.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error,
                  size: 50.h, color: AppColors.red);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const CustomLoader();
            },
          )
              : Image.asset("avatar".toPngPath),
          SizedBox(height: 10.h),
          const Spacer(),
          Container(
            height: 72.h,
            margin:
            EdgeInsets.only(bottom: 30.h, left: 20.w, right: 20.w),
            decoration: BoxDecoration(
              color: AppColors.container,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColors.white.withOpacity(0.6),
              ),
            ),
            child: Center(
              child: ThickShadowText(
                text: vm.myTarget.character?.name ?? "No Character",
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(BuildContext context, GameRoomVm vm) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      height: AppConstants.getScreenHeight(context) * 0.65,
      width: AppConstants.getScreenWidth(context) * 0.9,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("card".toPngPath),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 15.h),
          _buildWordBox(vm.myPlayer.words?.word1 ?? "", vm),
          _swordsRow(),
          _buildWordBox(vm.myPlayer.words?.word2 ?? "", vm),
          _swordsRow(),
          _buildWordBox(vm.myPlayer.words?.word3 ?? "", vm),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  Widget _buildWordBox(String word, GameRoomVm vm) {
    return InkWell(
      onTap: () => vm.claimTheWord(word),
      child: Container(
        height: 96.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColors.container,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: vm.claimedWords.contains(word)
                ? AppColors.red
                : AppColors.white.withOpacity(0.6),
            width: 4.sp,
          ),
        ),
        child: Center(
          child: ThickShadowText(text: word),
        ),
      ),
    );
  }

  Widget _swordsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        10,
            (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SvgPicture.asset("sword".toSvgPath),
        ),
      ),
    );
  }

  Widget _buildCharacterCard(BuildContext context, GameRoomVm vm) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      height: AppConstants.getScreenHeight(context) * 0.65,
      width: AppConstants.getScreenWidth(context) * 0.9,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("card".toPngPath),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          vm.myPlayer.character != null
              ? Image.network(
            vm.myPlayer.character!.imageUrl!,
            height: 300.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error,
                  size: 50.h, color: AppColors.red);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const CustomLoader();
            },
          )
              : Image.asset("avatar".toPngPath),
          SizedBox(height: 10.h),
          const Spacer(),
          Container(
            height: 72.h,
            margin:
            EdgeInsets.only(bottom: 30.h, left: 20.w, right: 20.w),
            decoration: BoxDecoration(
              color: AppColors.container,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColors.white.withOpacity(0.6),
              ),
            ),
            child: Center(
              child: ThickShadowText(
                text: vm.myPlayer.character?.name ?? "No Character",
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
