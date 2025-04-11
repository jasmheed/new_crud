import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterDemo extends StateNotifier<int> {
  CounterDemo() : super(0);
  void increment() {
    state++;
  }
}
