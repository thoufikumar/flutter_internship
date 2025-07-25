import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? get _uid => _auth.currentUser?.uid;

  // Save an expense -- CREATE
  Future<void> saveExpense({ //future - async func
    required String title,    // mandatory field - required
    required double amount,
    required String date,
  }) async {
    if (_uid == null) return;    // if no user logged in, return

    await _firestore
        .collection('users') // create a collection called users
        .doc(_uid) // unique user id document in users collection
        .collection('expenses')   //subcollection called expenses
        .add({
      'title': title,
      'amount': amount,
      'date': date,
      'createdAt': FieldValue.serverTimestamp(), //timestamp
    });
  }


  // Save budget plan -- CREATE
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

  // Get all expenses with ID -- READ
  Future<List<Map<String, dynamic>>> getExpenses() async { //returns a list of maps
    if (_uid == null) return [];

    final snapshot = await _firestore //get all documents in expenses collection
        .collection('users')
        .doc(_uid)
        .collection('expenses')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) { //return a list of maps
      return {
        'id': doc.id, // unique id for each document
        ...doc.data(), // all data in document
      };
    }).toList(); // convert to list
  }

  // Get all budgets with ID -- READ
  Future<List<Map<String, dynamic>>> getBudgets() async {
    if (_uid == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('budgets')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }




  // Optional: Update amount -- UPDATE
  Future<void> updateAmount({
    required String collection,
    required String docId,
    required double newAmount,
  }) async {
    if (_uid == null) return;

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection(collection)
        .doc(docId)
        .update({
      'amount': newAmount,
    });
  }

  // Delete any document by ID -- DELETE
  Future<void> deleteItem({
    required String collection,
    required String docId,
  }) async {
    if (_uid == null) return;

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection(collection)
        .doc(docId)
        .delete();
  }


}
/*
Create a firestore database called expenses or other name
        ↓
Update pubspec.yaml -> add firebase_core, cloud_firestore
        ↓
Create a firebase_collections.dart file (any name) in controllers folder
        ↓
This file should have core functions for all collections
        ↓
import the firebase_core package and collection file in required screens
        ↓
UI Interaction
        ↓
User taps "Add Expense"
        ↓
Calls firebaseService.saveExpense()
        ↓
Firestore stores data in expenses collection
        ↓
To update data in realtime - use snapshots or streams
        ↓
User taps edit/delete → updateAmount() or deleteItem()
*/