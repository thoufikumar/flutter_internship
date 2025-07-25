import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart'; // ✅ Required for Lottie animations
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to LoginScreen after 2 seconds
    Future.delayed(const Duration(seconds: 4), () {
      Get.off(() =>  LoginScreen());
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie Animation
            Lottie.asset(
              'assets/images/splashscreen.json',
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),

            // App Title
            const Text(
              "Order Managed in Minutes",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
