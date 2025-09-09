import 'package:aseedak/data/base_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ProfileSettingsVm extends BaseVm {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ProfileSettingsVm() {
    if (kDebugMode)
    // Initialize with existing user data if available
    {
      nameController.text = "John Doe"; // Replace with actual user data
      emailController.text = "johndoe@gmail.com"; // Replace with actual user data
      phoneController.text = "3515415641185"; // Replace with actual user data
    }
  }

  // Add properties and methods for the Profile Settings ViewModel
}
