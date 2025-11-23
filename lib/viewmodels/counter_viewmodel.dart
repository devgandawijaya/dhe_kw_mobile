import 'package:flutter/material.dart';
import '../models/counter_model.dart';

class CounterViewModel extends ChangeNotifier {
  final CounterModel _counterModel = CounterModel();

  int get count => _counterModel.count;

  void increment() {
    _counterModel.increment();
    notifyListeners();
  }
}
