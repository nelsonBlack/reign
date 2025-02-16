import 'package:reign/reign.dart';

class CounterController extends ReignController {
  int _count = 0;
  int currentCount() => _count;

  void increment() {
    _count++;
    update();
  }
}
