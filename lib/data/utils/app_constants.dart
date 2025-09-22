import 'package:aseedak/data/models/responses/UserModel.dart';
import 'package:flutter/cupertino.dart';


class AppConstants {
  AppConstants._();


  static getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  static getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  static isValidEmail(String email) {
    final regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return regex.hasMatch(email.trim());
  }
  static UserModel? currentUser;
}