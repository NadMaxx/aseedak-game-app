import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../data/utils/app_colors.dart';
import '../data/utils/app_constants.dart';




ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnack({required BuildContext context, Color? color,required String text, required bool isSuccess}){
  return ScaffoldMessenger.of(context)
      .showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 20),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color:isSuccess?AppColors.primary: Colors.red,
          ),
          child: Row(
            children: [
              Image.asset("assets/pngs/logo.png",width: 25,height: 25,),
              const SizedBox(width: 20,),
              SizedBox(
                width: AppConstants.getScreenWidth(context)/1.8,
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
}