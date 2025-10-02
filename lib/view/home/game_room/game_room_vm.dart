import 'dart:developer';
import 'dart:ui' as ui;

import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/data/repo/auth_repo.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/home/dashboard/dashboard_screen.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/custom_loader.dart';
import 'package:aseedak/widgets/custom_sheet.dart';
import 'package:aseedak/widgets/thick_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../../../data/models/responses/RoomComplete.dart';
import '../../../data/models/responses/my_api_response.dart';
import '../../../data/repo/user_repo.dart';
import '../../../main.dart';
import '../../../services/pusherService.dart';
import '../../../widgets/custom_snack.dart';

class GameRoomVm extends BaseVm {
  String roomCode;
  GameRoomVm({required this.roomCode}){
    getRoomDetails(true);
    connectSocket();
  }

  final pusher = RealtimeService(
    pusherKey: "d440ce92ce74e8791deb", // NEXT_PUBLIC_PUSHER_KEY
    pusherCluster: "mt1", // NEXT_PUBLIC_PUSHER_CLUSTER
  );


  leaveRoom() async {
    pusher.unsubEvent("room-$roomCode");
    pusher.unsubUser("user-${ authRepo.getUserObject()!.user!.id.toString()}");
    ApiResponse apiResponse = await userRepo.leaveGameRoom(roomCode: roomCode);
    if(apiResponse.response != null && apiResponse.response?.statusCode == 200){
    }else{
      customSnack(context: navigatorKey.currentContext!, text: "Something went wrong",isSuccess: false);
    }
  }

  Future<void> connectSocket() async {


    await pusher.connect();
    await pusher.subscribeUserChannel(authRepo.getUserObject()!.user!.id.toString(),
        killRequest: (payload){
      // log("Kill request received in user channel");
      //   showKillRequestDialog(payload);
    });
    await pusher.subscribeEvent(
      "room-$roomCode",
      killRequest: (payload) {
        showKillRequestDialog(payload);
      },
      onUserJoin: (payload) {
        getRoomDetails(false);
      },
      playerLeft: (payload) {
        getRoomDetails(false);
      },
      eliminationConfirmed: (payload) {
        getRoomDetails(false);
      },
    );
  }


  Players myPlayer = Players();
  Players myTarget = Players();

  RoomComplete roomDetail = RoomComplete();
  UserRepo userRepo = GetIt.I.get<UserRepo>();
  AuthRepo authRepo = GetIt.I.get<AuthRepo>();
  bool isLoading = false;
  getRoomDetails(showLoading) async {
    isLoading = showLoading;
    notifyListeners();
    ApiResponse apiResponse = await userRepo.getRoomDetails(roomCode: roomCode);
    if(apiResponse.response != null && apiResponse.response?.statusCode == 200){
      roomDetail = RoomComplete.fromJson(apiResponse.response?.data);
      roomDetail.room?.players?.forEach((element) {
        if(element.user!.id! == authRepo.getUserObject()!.user!.id!){
          myPlayer = element;
        }
      });
      String targetId = myPlayer.target!.user!.id ?? "";

      roomDetail.room?.players?.forEach((element) {
        if(element.user!.id! == targetId){
          myTarget = element;
        }
      });
      if(roomDetail.room!.status == "FINISHED") {
        Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, DashboardScreen.routeName, (r)=> false);
        customSnack(context: navigatorKey.currentContext!,
            text: "game_ended".tr(),
            isSuccess: true);
      }

      isLoading = false;
      notifyListeners();
    }else{
      isLoading = false;
      notifyListeners();
      customSnack(context: navigatorKey.currentContext!, text: "Something went wrong",isSuccess: false);
    }
  }
  List<String> claimedWords = [];
  claimTheWord(String word) async {
   claimedWords.add(word);
   notifyListeners();
  }
  bool requestingKill = false;
  requestKill() async {
    requestingKill = true;
    notifyListeners();
    ApiResponse apiResponse = await userRepo.requestKill(roomCode: roomCode, targetId: myTarget.id!);
    if(apiResponse.response != null && apiResponse.response?.statusCode == 200){
      getRoomDetails(false);
      requestingKill = false;
      notifyListeners();
      customSnack(context: navigatorKey.currentContext!, text: "Kill request sent",isSuccess: true);
    }else{
      requestingKill = false;
      notifyListeners();
      customSnack(context: navigatorKey.currentContext!, text: apiResponse.error.toString(),isSuccess: false);
    }
  }
  confirmKill(String killId) async {
    ApiResponse apiResponse = await userRepo.confirmKill(roomCode: roomCode, killId: killId);
    if(apiResponse.response != null && apiResponse.response?.statusCode == 200){
     await getRoomDetails(false);
    }else{
      customSnack(context: navigatorKey.currentContext!, text: apiResponse.error.toString(),isSuccess: false);
    }
  }


  void showKillRequestDialog(Map<String, dynamic> payload) {
    showCustomSheetWithContent(children: Directionality(
      textDirection: navigatorKey.currentContext!.locale.languageCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Column(
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset("circle".toSvgPath),
                  SvgPicture.asset("ishara".toSvgPath),
                ],
              ),
              SizedBox(height: 20.h,),


              ThickShadowText(text: "eliminated_title".tr()),
              SizedBox(height: 20.h,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomText(text: "eliminated_message".tr()),
              ),
            ],
          ),

          Divider(),
        ],
      ),
    ), confirmText: "confirm".tr(),

        onConfirmPressed: () async {
          showDialog(
              barrierDismissible: false,
              context: navigatorKey.currentState!.context, builder: (ctx){
            return CustomLoader();
          });
          await confirmKill(payload["elimination"]['id'].toString());
          navigatorKey.currentState!.pop();
          navigatorKey.currentState!.pop();
    });
  }
}