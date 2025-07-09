import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'home.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  // Email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Password validation
  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#\$&*~]).{6,}$');
    return passwordRegex.hasMatch(password);
  }

  // Phone number validation
  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\d{10}$');
    return phoneRegex.hasMatch(phone);
  }

  void _register(
      BuildContext context,
      String name,
      String phone,
      String email,
      String password,
      ) async {
    if (name.trim().isEmpty) {
      _showError(context, 'Name is required.');
      return;
    }
    if (!_isValidPhone(phone)) {
      _showError(context, 'Enter a valid 10-digit mobile number.');
      return;
    }
    if (!_isValidEmail(email)) {
      _showError(context, 'Enter a valid email.');
      return;
    }
    if (!_isValidPassword(password)) {
      _showError(context,
          'Password must be at least 6 characters, include one uppercase letter and one special character.');
      return;
    }

    try {
      // Create user in Firebase Auth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //  Navigate to HomeScreen if registration is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      //  Handle Firebase errors
      if (e.code == 'email-already-in-use') {
        _showError(context, 'This email is already registered.');
      } else if (e.code == 'weak-password') {
        _showError(context, 'Password is too weak.');
      } else {
        _showError(context, 'Registration failed: ${e.message}');
      }
    } catch (e) {
      _showError(context, 'Something went wrong. Try again.');
    }
  }


  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneNumController = TextEditingController();
    final emailController = TextEditingController();
    final pwdController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/images/loginani.json',
              height: 180,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Enter your Name...'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: phoneNumController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Enter your Mobile Number...'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Enter your email...'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: pwdController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Enter your password...'),
            ),
            const SizedBox(height: 30),

            // Gradient-styled register button
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F9792), Color(0xFF6FB3AC)],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _register(
                    context,
                    nameController.text.trim(),
                    phoneNumController.text.trim(),
                    emailController.text.trim(),
                    pwdController.text.trim(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bottom Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already Have An Account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                      color: Color(0xFF4F9792),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
