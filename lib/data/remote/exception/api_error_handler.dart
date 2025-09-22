import 'dart:developer';

import 'package:dio/dio.dart';
import 'my_error_response.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          log("DioExceptionType: ${error.type}");

          switch (error.type) {
            case DioExceptionType.badResponse:
              log("DioExceptionType.badResponse ${error.response?.data}");
              try{
                errorDescription = error.response?.data['message'] ?? error.response?.data['error'];
                log("errorDescription: $errorDescription");
              }catch(e){
                log("DioExceptionType.badResponse error: $e");
                errorDescription = "Something went wrong";
              }

              break;
            case DioExceptionType.connectionError:
            case DioExceptionType.cancel:
            // errorDescription = "Request to API server was cancelled due to internet connection";
              errorDescription =  "Please Check Your Internet Connection";
              break;
            case DioExceptionType.connectionTimeout:
            // errorDescription = "Connection timeout with API server";
              errorDescription =  "Please Check Your Internet Connection";
              break;
            case DioExceptionType.unknown:
            // errorDescription = "Connection to API server failed due to internet connection";
              errorDescription =  "Please Check Your Internet Connection";
              break;
            case DioExceptionType.receiveTimeout:
            // errorDescription = "Receive timeout in connection with API server";
              errorDescription =  "Please Check Your Internet Connection";
              break;
            case DioExceptionType.values:
              switch (error.response?.statusCode) {
                case 404:
                case 401:
                  errorDescription = error.response?.statusMessage;
                case 400:
                  errorDescription = error.response?.statusMessage;
                  break;
                case 500:
                case 502:
                  errorDescription = error.response?.statusMessage;
                  break;
                case 503:
                  errorDescription = error.response?.statusMessage;
                  break;
                case 402:
                  MyMethodErrorResponse myMethodErrorResponse =
                  MyMethodErrorResponse.fromJson(error.response?.data);
                  if (myMethodErrorResponse.message.isNotEmpty) {
                    errorDescription = myMethodErrorResponse;
                  } else {
                    errorDescription =
                    "Failed to load data - status code: ${error.response?.statusCode}";
                  }
                  break;
                default:
                  MyErrorResponse errorResponse =
                  MyErrorResponse.fromJson(error.response?.data);
                  if (errorResponse.message.isNotEmpty) {
                    errorDescription = errorResponse;
                  } else {
                    errorDescription =
                    "Failed to load data - status code: ${error.response?.statusCode}";
                  }
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
            case DioExceptionType.badCertificate:
            // TODO: Handle this case.
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}