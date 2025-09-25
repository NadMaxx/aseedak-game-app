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
}