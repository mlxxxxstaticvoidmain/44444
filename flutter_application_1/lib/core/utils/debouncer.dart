import 'dart:async';
import 'dart:ui';

class Debouncer {
  Debouncer(this._duration);

  final Duration _duration;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(_duration, action);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() => cancel();
}
