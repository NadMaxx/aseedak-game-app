import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_vm.dart';

class LoginView extends StatelessWidget {
  static const String routeName = '/login';
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginVm>(builder: (context, vm, child) {
      return Scaffold(
        body: Center(
          child: Text('Login View'),
        ),
      );
    });
  }
}
