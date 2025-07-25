import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Login using email and password
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Login error: $e");
      rethrow; // Re-throws for controller to handle error/snackbar
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    try {
      await _auth.signOut();
      print("User logged out");
    } catch (e) {
      print("Logout error: $e");
      rethrow;
    }
  }

  /// Get the currently signed-in user (returns null if not logged in)
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
}
