import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/data/repo/auth_repo.dart';
import 'package:get_it/get_it.dart';

import '../../../data/models/responses/RoomComplete.dart';
import '../../../data/models/responses/my_api_response.dart';
import '../../../data/repo/user_repo.dart';
import '../../../main.dart';
import '../../../widgets/custom_snack.dart';

class GameRoomVm extends BaseVm {
  String roomCode;
  GameRoomVm({required this.roomCode}){
    getRoomDetails(true);
    roomCode = "4D03D13B";
  }

  Players myPlayer = Players();

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
      isLoading = false;
      notifyListeners();
    }else{
      isLoading = false;
      notifyListeners();
      customSnack(context: navigatorKey.currentContext!, text: "Something went wrong",isSuccess: false);
    }
  }

  claimTheWord(String word) async {
    ApiResponse apiResponse = await userRepo.claimWord(roomCode: roomCode, word: word);
    if(apiResponse.response != null && apiResponse.response?.statusCode == 200){
      getRoomDetails(false);
    }else{
      customSnack(context: navigatorKey.currentContext!, text: "Something went wrong",isSuccess: false);
    }
  }
}