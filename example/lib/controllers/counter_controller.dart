import 'package:reign/reign.dart';

class CounterController extends ReignController<int> {
  CounterController({required int initialValue}) : super(initialValue);

  int currentCount() => value;

  void increment() {
    value++;
    update();
  }
}
