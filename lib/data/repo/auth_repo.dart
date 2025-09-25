import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/body/RegisterBody.dart';
import '../models/responses/UserModel.dart';
import '../models/responses/my_api_response.dart';
import '../remote/dio/dio_client.dart';
import '../remote/exception/api_error_handler.dart';
import '../utils/api_end_points.dart';
import '../utils/sharedKeys.dart';


class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  void _updateToken() {
    dioClient.updateToken();
  }

  Future<void> setUserObject(UserModel userJson) async {
    try {
      await sharedPreferences.setString(
          SharedPrefsKeys.LOGGED_IN_USER_OBJECT, userModelToJson(userJson));
    } catch (e) {
      log("Error saving user object: $e");
    }
    _updateToken();
  }

  UserModel? getUserObject() {
    if (sharedPreferences.containsKey(SharedPrefsKeys.LOGGED_IN_USER_OBJECT)) {
      return UserModel.fromJson(jsonDecode(
          sharedPreferences.getString(SharedPrefsKeys.LOGGED_IN_USER_OBJECT) ??
              ""));
    } else {
      return null;
    }
  }

  Future setUserLoggedIn(UserModel userJson) async {
    await sharedPreferences.setBool(SharedPrefsKeys.IS_USER_LOGGED_IN, true);
    await sharedPreferences.setString("token", userJson.token ?? "");
    dioClient.updateHeader(userJson.token);
    await setUserObject(userJson);
  }

  bool isUserLoggedIn() {
    return sharedPreferences.getBool(SharedPrefsKeys.IS_USER_LOGGED_IN) ??
        false;
  }
  //
  Future<bool> clearSharedData() async {
    await sharedPreferences.remove(SharedPrefsKeys.IS_USER_LOGGED_IN);
    await sharedPreferences.remove(SharedPrefsKeys.LOGGED_IN_USER_OBJECT);
    await sharedPreferences.remove("token");
    _updateToken();
    // FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
    return true;
  }
  //
  //
  Future<ApiResponse> login({required String email,required String password}) async {
    try {
      Response response = await dioClient.post(
        ApiEndPoints.login,
        data:  {
          "email": email,
          "password": password,
        }
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> register({required RegisterBody body}) async {
    try {
      Response response = await dioClient.post(
        ApiEndPoints.signUp,
        data:  body.toJson()
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> resendOTP({required String email}) async {
    try {
      Response response = await dioClient.post(
        ApiEndPoints.resendOTP,
        data:  {
          "email": email,
        }
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> verifyOTP({required String email,required String otp}) async {
    try {
      Response response = await dioClient.post(
        ApiEndPoints.verifyOTP,
        data: {
          "email": email,
          "otp": otp
        }
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> logout() async {
    try {
      Response response = await dioClient.post(
        ApiEndPoints.logout,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  //
  forgotPassword({required String email}) {
    return dioClient.post(
      ApiEndPoints.forgotPassword,
      data: {
        "email": email,
      },
    ).then((response) {
      return ApiResponse.withSuccess(response);
    }).catchError((error) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(error));
    });
  }


}