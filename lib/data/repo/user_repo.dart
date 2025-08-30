import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/responses/my_api_response.dart';
import '../remote/dio/dio_client.dart';
import '../remote/exception/api_error_handler.dart';

class UserRepo {
  final DioClient dioClient;

  UserRepo({required this.dioClient});

}