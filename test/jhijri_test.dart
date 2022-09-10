import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jhijri/jHijri.dart';

void main() {
  test('adds one to input values', () {
    final calculator = JHijri();
    debugPrint(calculator.fullDate);
  });
}
