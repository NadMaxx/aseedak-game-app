import 'package:aseedak/data/models/body/CreateRoomBody.dart';
import 'package:aseedak/data/models/responses/UserModel.dart';
import 'package:aseedak/data/models/responses/my_api_response.dart';
import 'package:aseedak/data/repo/auth_repo.dart';
import 'package:aseedak/data/repo/user_repo.dart';
import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/app_constants.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/main.dart';
import 'package:aseedak/view/home/wait_room/wait_room.dart';
import 'package:aseedak/widgets/customCirle.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/custom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../../../data/base_vm.dart';
import '../../../data/models/responses/RoomCreatedResponse.dart';
import '../../../widgets/customTextField.dart';
import '../../../widgets/custom_snack.dart';

class DashboardVm extends BaseVm {
  UserRepo userRepo = GetIt.I.get<UserRepo>();
  AuthRepo authRepo = GetIt.I.get<AuthRepo>();

  showCreateRoomSheet() {
    TextEditingController roomController = TextEditingController();
    TextEditingController playerController = TextEditingController(text: "2");
    if (kDebugMode) {
      roomController.text = "Test Room";
    }
    final formKey = GlobalKey<FormState>();

    showCustomSheetWithContent(
      children: SingleChildScrollView(
        // ✅ Makes sheet scrollable
        child: Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(
                  navigatorKey.currentContext!,
                ).viewInsets.bottom, // ✅ Adjust for keyboard
          ),
          child: Form(
            key: formKey, // ✅ For validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Room Name",
                        fontFamily: "Kanit",
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                      CustomTextField(
                        controller: roomController,
                        prefix: "kamra",
                        hintText: "Enter room name",
                        keyboardType: TextInputType.text,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Room name is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),

                      CustomText(
                        text: "Select Players",
                        fontFamily: "Kanit",
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                      CustomTextField(
                        controller: playerController,
                        prefix: "bandy",
                        hintText: "Enter number of players",
                        keyboardType: TextInputType.number,
                        // ✅ number instead of email
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Number of players is required";
                          }
                          final num? players = int.tryParse(v);
                          if (players == null) {
                            return "Enter a valid number";
                          }
                          if (players < 2) {
                            return "At least 2 players required";
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
        if (!formKey.currentState!.validate()) return; // ✅ Validation check

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
      Navigator.pushNamed(navigatorKey.currentContext!, WaitingRoom.routeName);
      _isLoading = false;
      notifyListeners();
    } else {
      // MyErrorResponse myErrorResponse = MyErrorResponse.fromJson(apiResponse.error!);
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
