import 'dart:async';

import 'package:flutter/foundation.dart';

class AlarmTimerController extends ValueNotifier<int> {
  AlarmTimerController({
    required this.onAlarmTriggered,
    this.durationSeconds = 60,
  }) : assert(durationSeconds > 0),
       super(durationSeconds);

  final VoidCallback onAlarmTriggered;
  final int durationSeconds;

  Timer? _timer;

  void start() {
    if (_timer?.isActive ?? false) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void reset() {
    value = durationSeconds;
  }

  void _tick() {
    if (value > 0) value--;
    if (value != 0) return;

    onAlarmTriggered();
    reset();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
