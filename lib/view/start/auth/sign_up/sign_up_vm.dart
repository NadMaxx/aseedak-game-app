import 'package:aseedak/data/base_vm.dart';
import 'package:flutter/cupertino.dart';

class SignUpVm extends BaseVm{
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
}