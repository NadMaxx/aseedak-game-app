import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/data/models/responses/RoomCreatedResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../../data/models/responses/UserModel.dart' show UserModel;
import '../../../../data/repo/auth_repo.dart';

class ProfileSettingsVm extends BaseVm {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  UserModel get currentUser => repo.getUserObject()!;
  AuthRepo repo = GetIt.I.get<AuthRepo>();
  ProfileSettingsVm() {
      nameController.text = currentUser.user!.firstName ?? "";
      emailController.text = currentUser.user!.email ?? "";
      phoneController.text = currentUser.user!.phoneNumber ?? "";

  }

  // Add properties and methods for the Profile Settings ViewModel
}
