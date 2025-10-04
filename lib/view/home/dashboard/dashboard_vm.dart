import 'dart:developer';
import 'dart:ui' as ui;

import 'package:app_links/app_links.dart';
import 'package:aseedak/data/models/body/CreateRoomBody.dart';
import 'package:aseedak/data/models/responses/ProgressRooms.dart';
import 'package:aseedak/data/models/responses/UserModel.dart';
import 'package:aseedak/data/models/responses/my_api_response.dart';
import 'package:aseedak/data/repo/auth_repo.dart';
import 'package:aseedak/data/repo/user_repo.dart';
import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/app_constants.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/main.dart';
import 'package:aseedak/view/home/game_room/game_room.dart';
import 'package:aseedak/view/home/profile/profile_settings/profile_settings.dart';
import 'package:aseedak/view/home/wait_room/wait_room.dart';
import 'package:aseedak/widgets/customCirle.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/custom_loader.dart';
import 'package:aseedak/widgets/custom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/base_vm.dart';
import '../../../data/models/responses/RoomCreatedResponse.dart';
import '../../../services/deeplink_manager.dart';
import '../../../widgets/customTextField.dart';
import '../../../widgets/custom_snack.dart';

class DashboardVm extends BaseVm {
  UserRepo userRepo = GetIt.I.get<UserRepo>();
  AuthRepo authRepo = GetIt.I.get<AuthRepo>();

  DashboardVm() {
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    // 1. Call your APIs first
    await getInProgressRooms();

    // 2. Set the deep link callback
    DeepLinkManager.instance.setJoinRoomCallback((gameCode) async {
      await joinRoom(gameCode);
    });

    // 3. Start listening for new deep links
    DeepLinkManager.instance.startListening();

    // 4. Handle any pending deep link from cold start
    await DeepLinkManager.instance.handlePendingLink();
  }

  @override
  void dispose() {
    DeepLinkManager.instance.clearCallback();
    super.dispose();
  }

  showCreateRoomSheet() {
    TextEditingController roomController = TextEditingController();
    TextEditingController playerController = TextEditingController(text: "2");

    if (kDebugMode) {
      roomController.text = "Test Room";
    }

    final formKey = GlobalKey<FormState>();

    showCustomSheetWithContent(
      children: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(
              navigatorKey.currentContext!,
            ).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "create_room_title".tr(),
                        fontFamily: "Kanit",
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                      CustomTextField(
                        controller: roomController,
                        prefix: "kamra",
                        hintText: "create_room_hint".tr(),
                        keyboardType: TextInputType.text,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "create_room_required".tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),

                      CustomText(
                        text: "create_room_select_players".tr(),
                        fontFamily: "Kanit",
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                      CustomTextField(
                        controller: playerController,
                        prefix: "bandy",
                        hintText: "create_room_players_hint".tr(),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "create_room_players_required".tr();
                          }
                          final num? players = int.tryParse(v);
                          if (players == null) {
                            return "create_room_players_invalid".tr();
                          }
                          if (players < 2) {
                            return "create_room_players_min".tr();
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Divider(),
              ],
            ),
          ),
        ),
      ),
      onConfirmPressed: () async {
        if (!formKey.currentState!.validate()) return;
        if(int.parse(playerController.text.trim()) > 4){
          showBuyPlayerSheet();
          return;
        }
        Navigator.pop(navigatorKey.currentContext!);
        showLoaderDialog();

        CreateRoomBody createRoomBody = CreateRoomBody(
          category: "all",
          name: roomController.text.trim(),
          maxPlayers: int.parse(playerController.text.trim()),
          difficulty: "medium",
          timeLimit: 300,
          invitedUsers: [
            "68d5780e7c37125af123beba"
          ],
        );
        await createRoom(createRoomBody);
      },
    );
  }

  showJoinRoomSheet() {
    TextEditingController roomCodeController = TextEditingController();
    if(kDebugMode){
      roomCodeController.text = "9F67D77C";
    }
    final formKey = GlobalKey<FormState>();

    showCustomSheetWithContent(
      children: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(
              navigatorKey.currentContext!,
            ).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "join_room_code_label".tr(),
                        fontFamily: "Kanit",
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                      CustomTextField(
                        controller: roomCodeController,
                        prefix: "kamra",
                        hintText: "join_room_code_hint".tr(),
                        keyboardType: TextInputType.text,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "join_room_code_required".tr();
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Divider(),
              ],
            ),
          ),
        ),
      ),
      onConfirmPressed: () async {
        if (!formKey.currentState!.validate()) return;

        Navigator.pop(navigatorKey.currentContext!);
        showLoaderDialog();

        await joinRoom(roomCodeController.text.trim());
      },
    );
  }

  showLoaderDialog() {
    return showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (ctx) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20.r),
            ),
            height: 200.h,
            width: AppConstants.getScreenWidth(ctx) * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset("circle".toSvgPath),
                    CupertinoActivityIndicator(color: Colors.white),
                  ],
                ),
                CustomText(text: "Creating Room ... (78%)"),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isLoading = false;

  createRoom(CreateRoomBody body) async {
    ApiResponse apiResponse = await userRepo.createGameRoom(body: body);
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      AppConstants.roomData =
          RoomCreatedResponse.fromJson(apiResponse.response?.data);
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pushNamed(navigatorKey.currentContext!, WaitingRoom.routeName, arguments: AppConstants.roomData.room!.code);
      _isLoading = false;
      notifyListeners();
    } else {
      Navigator.pop(navigatorKey.currentContext!);
      customSnack(
        text: apiResponse.error!.toString(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );

      _isLoading = false;
      notifyListeners();
    }
  }

  joinRoom(String roomCode) async {
    ApiResponse apiResponse = await userRepo.joinGameRoom(roomCode: roomCode);
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      AppConstants.roomData =
          RoomCreatedResponse.fromJson(apiResponse.response?.data);
      Navigator.pop(navigatorKey.currentContext!);
      if(AppConstants.roomData.room != null && AppConstants.roomData.room!.status == "IN_PROGRESS"){
        customSnack(
          text: "Room is already in progress".tr(),
          context: navigatorKey.currentContext!,
          isSuccess: false,
        );
        return;

      }
      Navigator.pushNamed(navigatorKey.currentContext!, WaitingRoom.routeName,arguments: AppConstants.roomData.room!.code);
      _isLoading = false;
      notifyListeners();
    } else {
      Navigator.pop(navigatorKey.currentContext!);
      customSnack(
        text: apiResponse.error!.toString(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );

      _isLoading = false;
      notifyListeners();
    }
  }

  void showBuyPlayerSheet() {
    showCustomSheetWithContent(
      children: Directionality(
        textDirection: navigatorKey.currentContext!.locale.languageCode == 'ar'
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "buy_more_players_title".tr(),
                    fontFamily: "Kanit",
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
                  SizedBox(height: 10.h),
                  CustomText(
                    text: "buy_more_players_subtitle".tr(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Kanit",
                  ),
                  SizedBox(height: 20.h),

                ],
              ),
            ),
            const Divider(),
            SizedBox(height: 10.h),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  SvgPicture.asset("person".toSvgPath),
                  SizedBox(width: 10.w),
                  CustomText(
                    text: "buy_more_players_4_players".tr(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Kanit",
                  ),
                  const Spacer(),
                  CustomText(
                    text:
                    "5\$",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Kanit",
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            const Divider(),
          ],
        ),
      ),
      onConfirmPressed: () {
        Navigator.pop(navigatorKey.currentContext!);

        customSnack(
          text: "purchase_success".tr(),
          context: navigatorKey.currentContext!,
          isSuccess: true,
        );
      },
      confirmText: "buy_now".tr(),
    );
  }

  getInProgressRooms() async {
    ApiResponse apiResponse = await userRepo.inProgressRooms();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      ProgressRooms progressRooms =
      ProgressRooms.fromJson(apiResponse.response?.data);
      if(progressRooms.rooms == null || progressRooms.rooms!.isEmpty){
        return;
      }
      Navigator.pushNamedAndRemoveUntil(navigatorKey.currentState!.context, GameRoom.routeName, arguments: progressRooms.rooms!.first.code!, (R)=>false );
      notifyListeners();
    } else {
      customSnack(
        text: apiResponse.error!.toString(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );

      _isLoading = false;
      notifyListeners();
    }
  }
}