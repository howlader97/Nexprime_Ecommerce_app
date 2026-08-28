import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final otpCountdownProvider = NotifierProvider<OtpCountdownNotifier, int>(OtpCountdownNotifier.new);

class OtpCountdownNotifier extends Notifier<int> {
  Timer? _timer;

  static const int _duration = 180; // 3 minutes

  @override
  int build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    start();
    return _duration;
  }

  void start() {
    _timer?.cancel();

    state = _duration;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state <= 1) {
        timer.cancel();
        state = 0;
      } else {
        state--;
      }
    });
  }

  bool get canResend => state == 0;
}
