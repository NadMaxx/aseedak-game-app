import 'dart:async';
import 'dart:developer';

import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/data/models/responses/RoomComplete.dart';
import 'package:aseedak/data/models/responses/my_api_response.dart';
import 'package:aseedak/data/repo/auth_repo.dart';
import 'package:aseedak/data/repo/user_repo.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/home/game_room/game_room.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/custom_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../../../data/utils/app_colors.dart';
import '../../../data/utils/app_constants.dart';
import '../../../main.dart';
import '../../../services/pusherService.dart';

class WaitingRoomVm extends BaseVm{
  String roomCode;
  AuthRepo authRepo = GetIt.I.get<AuthRepo>();
  WaitingRoomVm({required this.roomCode}){
    getRoomDetails(true);
    connectSocket();

  }
  List<Map<String, String>> players = [
    {
      "name": "Jack Adams",
      "avatar": "https://thumbs.dreamstime.com/b/happy-young-man-holding-tablet-his-face-displayed-screen-binary-code-happy-man-holding-tablet-his-face-317521026.jpg",
    },
    {
      "name": "Ethan Hales",
      "avatar": "https://plus.unsplash.com/premium_photo-1671656349218-5218444643d8?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8YXZhdGFyfGVufDB8fDB8fHww",
    },
    {
      "name": "Wanda Siege",
      "avatar": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTAUPUG0r--EDZzf-f9Afj_Jp7N96yIGsWPgCYIkrAS1rCJHIcdm_RCq_me44bJc0dvvY&usqp=CAU",
    },
    {
      "name": "Wanda Siege",
      "avatar": "https://www.shutterstock.com/image-photo/adult-female-avatar-image-on-260nw-2420293027.jpg",
    },
  ];

   showGameStartDialog(BuildContext context) async {
     startGame();
    showLoaderDialog();
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
                borderRadius: BorderRadius.circular(20.r)
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
                    CupertinoActivityIndicator(color: Colors.white,),
                  ],
                ),
                CustomText(text: "Starting Game ... (78%)")
              ],
            ),
          ),
        );
      },
    );
  }
  RoomComplete roomDetail = RoomComplete();
  UserRepo userRepo = GetIt.I.get<UserRepo>();
  bool isLoading = false;
  getRoomDetails(showLoading) async {
    isLoading = showLoading;
    notifyListeners();
    ApiResponse apiResponse = await userRepo.getRoomDetails(roomCode: roomCode);
    if(apiResponse.response != null && apiResponse.response?.statusCode == 200){
      roomDetail = RoomComplete.fromJson(apiResponse.response?.data);
      // _startPolling();
      isLoading = false;
      notifyListeners();
    }else{
      isLoading = false;
      notifyListeners();
      customSnack(context: navigatorKey.currentContext!, text: "Something went wrong",isSuccess: false);
    }
  }

  unsubEvent() async {
    pusher.unsubEvent("room-$roomCode");
    pusher.unsubUser("user-${ authRepo.getUserObject()!.user!.id.toString()}");
    pusher.disconnect();
  }
  leaveRoom() async {
    unsubEvent();
    ApiResponse apiResponse = await userRepo.leaveGameRoom(roomCode: roomCode);
    if(apiResponse.response != null && apiResponse.response?.statusCode == 200){
    }else{
      customSnack(context: navigatorKey.currentContext!, text: "Something went wrong",isSuccess: false);
    }
  }

  bool isStartingGame = false,willPop = true;
  final pusher = RealtimeService(
    pusherKey: "d440ce92ce74e8791deb", // NEXT_PUBLIC_PUSHER_KEY
    pusherCluster: "mt1", // NEXT_PUBLIC_PUSHER_CLUSTER
  );
  startGame() async {
    if(roomDetail.room!.players!.length < 2){
      customSnack(context: navigatorKey.currentContext!, text: "At least 2 players are required to start the game",isSuccess: false);
      return;
    }
    isStartingGame = true;
    notifyListeners();
    ApiResponse apiResponse = await userRepo.startGameRoom(roomCode: roomCode);
    if(apiResponse.response != null && apiResponse.response?.statusCode == 200){
      await unsubEvent();
      willPop = false;
      isStartingGame = true;
      notifyListeners();
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pushReplacementNamed(navigatorKey.currentContext!, GameRoom.routeName,arguments: roomCode);

    }else{
      Navigator.pop(navigatorKey.currentContext!);
      isStartingGame = false;
      notifyListeners();
      customSnack(context: navigatorKey.currentContext!, text: "Something went wrong",isSuccess: false);
    }
  }
  Future<void> connectSocket() async {


    await pusher.connect();
    await pusher.subscribeUserChannel(authRepo.getUserObject()!.user!.id.toString());
    await pusher.subscribeEvent(
      "room-$roomCode",
      onGameStart: (payload) async {
        await unsubEvent();
        Navigator.pushReplacementNamed(navigatorKey.currentContext!, GameRoom.routeName,arguments: roomCode);
      },
      onUserJoin: (payload) {
        getRoomDetails(false);
      },
      playerLeft: (payload) {
        getRoomDetails(false);
      },
    );
  }

  // Timer? _timer;
  // void _startPolling() {
  //   _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
  //     getRoomDetails(false);
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   _timer?.cancel(); // ✅ Stops when leaving screen
  //   super.dispose();
  // }
}