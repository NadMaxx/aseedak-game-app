import 'dart:async';

import 'package:aseedak/data/base_vm.dart';

class OTPVm extends BaseVm{
  int _seconds = 60;
  Timer? _timer;

  OTPVm() {
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
          _seconds--;
          notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get seconds => _seconds;

}