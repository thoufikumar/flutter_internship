import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> expenses;
  final List<Map<String, dynamic>> budgets;

  const StatsScreen({
    super.key,
    required this.expenses,
    required this.budgets,
  });

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}



class _StatsScreenState extends State<StatsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Map<String, dynamic>> _expenses;
  late List<Map<String, dynamic>> _budgets;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? get _uid => _auth.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _expenses = widget.expenses;
    _budgets = widget.budgets;
  }

  Future<void> _loadData() async {
    if (_uid == null) return;

    final expensesSnapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('expenses')
        .orderBy('createdAt', descending: true)
        .get();

    final budgetsSnapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('budgets')
        .orderBy('createdAt', descending: true)
        .get();

    setState(() {
      _expenses = expensesSnapshot.docs.map((doc) => doc.data()).toList();
      _budgets = budgetsSnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  void _editItem(Map<String, dynamic> item, int index, bool isBudget) {
    final controller = TextEditingController(text: item['amount'].toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit ${item['title']}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updated = double.tryParse(controller.text);
              if (updated != null) {
                setState(() {
                  if (isBudget) {
                    _budgets[index]['amount'] = updated;
                  } else {
                    _expenses[index]['amount'] = updated;
                  }
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(int index, bool isBudget) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isBudget) {
                  _budgets.removeAt(index);
                } else {
                  _expenses.removeAt(index);
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildList(bool isBudget) {
    final dataList = isBudget ? _budgets : _expenses;

    if (dataList.isEmpty) {
      return Center(child: Text('No ${isBudget ? "budgets" : "expenses"} yet.'));
    }

    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final item = dataList[index];
        return ListTile(
          leading: Icon(isBudget ? Icons.account_balance_wallet : Icons.money),
          title: Text(item['title'] ?? 'Untitled'),
          subtitle: Text(item['date'] ?? 'No date'),
          trailing: Text('₹${item['amount']?.toStringAsFixed(2) ?? "0.00"}'),
          onTap: () => _editItem(item, index, isBudget),
          onLongPress: () => _deleteItem(index, isBudget),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Statistics'),
          backgroundColor: const Color(0xFF4F9792),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Expenses'),
              Tab(text: 'Budgets'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildList(false),
            _buildList(true),
          ],
        ),
      ),
    );
  }
}
