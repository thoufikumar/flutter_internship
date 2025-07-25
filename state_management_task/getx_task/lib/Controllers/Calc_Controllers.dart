import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalcController extends GetxController {
  var num1 = 0.obs;
  var num2 = 0.obs;
  var result = 0.obs;

  void setAdd(int a, int b) {
    num1.value = a;
    num2.value = b;
    result.value = a + b;
  }

  void setSub(int a, int b) {
    num1.value = a;
    num2.value = b;
    result.value = a - b;
  }

  void setMul(int a, int b) {
    num1.value = a;
    num2.value = b;
    result.value = a * b;
  }

  void setDiv(int a, int b) {
    num1.value = a;
    num2.value = b;
    if (b != 0) {
      result.value = a ~/ b;
    } else {
      result.value = 0;
    }
  }

  void setMod(int a, int b) {
    num1.value = a;
    num2.value = b;
    result.value = a % b;
  }

  void clear() {
    num1.value = 0;
    num2.value = 0;
    result.value = 0;
  }
}
