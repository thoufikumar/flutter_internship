import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? get _uid => _auth.currentUser?.uid;

  // Save an expense
  Future<void> saveExpense({
    required String title,
    required double amount,
    required String date,
  }) async {
    if (_uid == null) return;

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('expenses')
        .add({
      'title': title,
      'amount': amount,
      'date': date,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get all expenses (ordered by createdAt desc)
  Future<List<Map<String, dynamic>>> getExpenses() async {
    if (_uid == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('expenses')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Save budget plan
  Future<void> saveBudget({
    required String title,
    required double amount,
    required double income,
    required String date,
    required Map<String, double> categories,
  }) async {
    if (_uid == null) return;

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('budgets')
        .add({
      'title': title,
      'amount': amount,
      'income': income,
      'date': date,
      'categories': categories,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ✅ Get all budgets (or only latest if needed)
  Future<List<Map<String, dynamic>>> getBudgets() async {
    if (_uid == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('budgets')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
