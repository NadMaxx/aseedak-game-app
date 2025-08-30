import 'package:aseedak/data/base_vm.dart';
import 'package:flutter/cupertino.dart';

class LoginVm extends BaseVm{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
}