import 'package:flutter/cupertino.dart';

import '../../../../data/base_vm.dart';

class ChangePasswordVM  extends BaseVm{
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //form key
  final formKey = GlobalKey<FormState>();

}