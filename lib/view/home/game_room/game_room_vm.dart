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
    ApiResponse apiResponse = await userRepo.requestKill(roomCode: roomCode, targetId: myTarget.user!.id!);
    if(apiResponse.response != null && apiResponse.response?.statusCode == 200){
      getRoomDetails(false);
      requestingKill = false;
      notifyListeners();
      customSnack(context: navigatorKey.currentContext!, text: "Kill request sent",isSuccess: true);
    }else{
      requestingKill = false;
      notifyListeners();
      customSnack(context: navigatorKey.currentContext!, text: "Something went wrong",isSuccess: true);
    }
  }
}