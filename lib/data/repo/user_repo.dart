import 'dart:developer';

import 'package:aseedak/data/models/body/CreateRoomBody.dart';
import 'package:dio/dio.dart';

import '../models/responses/my_api_response.dart';
import '../remote/dio/dio_client.dart';
import '../remote/exception/api_error_handler.dart';
import '../utils/api_end_points.dart';

class UserRepo {
  final DioClient dioClient;

  UserRepo({required this.dioClient});
  Future<ApiResponse> createGameRoom({required CreateRoomBody body}) async {
    try {
      Response response = await dioClient.post(
          ApiEndPoints.gameRoomCreate,
          data:  body.toJson()
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> joinGameRoom({required String roomCode}) async {
    try {
      Response response = await dioClient.post(
          "${ApiEndPoints.joinRoom}$roomCode/join",
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> leaveGameRoom({required String roomCode}) async {
    try {
      Response response = await dioClient.post(
          "${ApiEndPoints.joinRoom}$roomCode/leave",
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getRoomDetails({required String roomCode}) async {
    try {
      Response response = await dioClient.get(
          "${ApiEndPoints.joinRoom}$roomCode/complete",
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  startGameRoom({required String roomCode}) async {
    try {
      Response response = await dioClient.post(
        "${ApiEndPoints.joinRoom}$roomCode/start",
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  requestKill({required String roomCode,required String targetId}) async {
    try {
      Response response = await dioClient.post(
        "${ApiEndPoints.joinRoom}$roomCode/eliminate",
        data: {
          "targetId" : targetId
        }
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  confirmKill({required String roomCode,required String killId}) async {
    try {
      Response response = await dioClient.post(
        "${ApiEndPoints.joinRoom}$roomCode/confirm-elimination",
        data: {
          "eliminationId" : killId,
          "confirmed": true
        }
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  updateMaxPlayers({required String paymentIntendId,required dynamic amount}) async {
    try {
      Response response = await dioClient.post(
        ApiEndPoints.updateMaxPlayers,
        data: {
          "newMaxMembers": 8,
          "paymentIntentId": paymentIntendId,
          "amount": amount
        }
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  getAvatars() async {
    try {
      Response response = await dioClient.get(
        ApiEndPoints.getAvatars,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  updateUser(String key,int val) async {
    try {
      Response response = await dioClient.put(
        ApiEndPoints.updateUser,
        data: {
          key : val
        }
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  inProgressRooms() async {
    try {
      Response response = await dioClient.get(
        "${ApiEndPoints.joinRoom}inprogress",
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}