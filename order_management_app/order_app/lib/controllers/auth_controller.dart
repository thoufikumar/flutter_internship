// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../services/firebase_service.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  void login(String email, String password) async {
    try {
      final user = await _firebaseService.loginWithEmail(email, password);
      if (user != null) {
        Get.offAllNamed('/orders');
      }
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        e.toString().replaceAll(RegExp(r'\[.*\]'), ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    }
  }

  Future<void> logout() async {
    await _firebaseService.logout();
    Get.offAll(() =>  LoginScreen());
  }
}
