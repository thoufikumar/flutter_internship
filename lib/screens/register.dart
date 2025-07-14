import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'home.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#\$&*~]).{6,}$');
    return passwordRegex.hasMatch(password);
  }

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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
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
      backgroundColor: const Color(0xFFF3F7F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/images/register_lottie.json',
                height: 160,
              ),
              const SizedBox(height: 20),
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4F9792),
                ),
              ),
              const SizedBox(height: 30),

              _buildInputCard("Enter your Name...", nameController),
              const SizedBox(height: 15),
              _buildInputCard("Enter your Mobile Number...", phoneNumController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 15),
              _buildInputCard("Enter your email...", emailController,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 15),
              _buildInputCard("Enter your password...", pwdController,
                  obscureText: true),
              const SizedBox(height: 30),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already Have An Account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
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
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(
      String hint,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        bool obscureText = false,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
