import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/widgets/custom_sheet.dart';
import 'package:aseedak/widgets/simple_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../data/utils/app_colors.dart';
import '../../../../widgets/customText.dart';
import '../../../../widgets/custom_button.dart';


class ProfileVm extends BaseVm{



  showDeleteAccountSheet(BuildContext context) {
    showCustomSheet(title: "Delete", subTitle: "Are you sure you want to delete your account?", onConfirmPressed: (){},confirmText: "YES, DELETE");
  }

  showLogoutSheet(BuildContext context) {
    showCustomSheet(title: "Logout", subTitle: "Are you sure you want to logout?", onConfirmPressed: (){},confirmText: "YES, LOGOUT");
  }

}