import 'package:flutter/material.dart';
import '../controllers/firebase_collection.dart';

final firebaseService = FirebaseService();

class BudgetPlannerScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddToStats;

  const BudgetPlannerScreen({super.key, required this.onAddToStats});

  @override
  State<BudgetPlannerScreen> createState() => _BudgetPlannerScreenState();
}

class _BudgetPlannerScreenState extends State<BudgetPlannerScreen> {
  final _incomeController = TextEditingController();
  final Map<String, TextEditingController> _categoryControllers = {
    'Food': TextEditingController(),
    'Rent': TextEditingController(),
    'Transport': TextEditingController(),
    'Entertainment': TextEditingController(),
    'Savings': TextEditingController(),
  };

  double _income = 0;
  double _totalAllocated = 0;
  double _remaining = 0;
  bool _calculated = false;

  void _calculate() {
    setState(() {
      _income = double.tryParse(_incomeController.text.trim()) ?? 0;
      _totalAllocated = 0;

      for (var controller in _categoryControllers.values) {
        _totalAllocated += double.tryParse(controller.text) ?? 0;
      }

      _remaining = _income - _totalAllocated;
      _calculated = true;
    });
  }

  Future<void> _submitPlan() async {
    _income = double.tryParse(_incomeController.text.trim()) ?? 0;
    if (_income <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid income')),
      );
      return;
    }

    final Map<String, double> categories = {};
    _totalAllocated = 0;

    _categoryControllers.forEach((key, controller) {
      final value = double.tryParse(controller.text) ?? 0;
      _totalAllocated += value;
      categories[key] = value;
    });

    final budgetPlan = {
      'title': 'Monthly Budget',
      'amount': _totalAllocated,
      'income': _income,
      'date': DateTime.now().toString(),
      'categories': categories,
    };

    try {
      await firebaseService.saveBudget(
        title: 'Monthly Budget',
        amount: _totalAllocated,
        income: _income,
        date: DateTime.now().toString(),
        categories: categories,
      );

      widget.onAddToStats(budgetPlan);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget plan saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving budget: $e')),
      );
    }
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _categoryControllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF4F3),
      appBar: AppBar(
        title: const Text('Budget Planner'),
        backgroundColor: const Color(0xFF4F9792),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _incomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Income (₹)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Allocate Budget:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          ..._categoryControllers.entries.map(
                (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: entry.value,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '${entry.key} Budget (₹)',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F9792),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
              ),
              ElevatedButton.icon(
                onPressed: _submitPlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.add_chart),
                label: const Text('Add to Stats'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (_calculated)
            Card(
              color: _remaining >= 0 ? Colors.green[50] : Colors.red[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Total Allocated: ₹${_totalAllocated.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _remaining >= 0
                          ? 'Remaining Budget: ₹${_remaining.toStringAsFixed(2)}'
                          : 'Over Budget by ₹${_remaining.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _remaining >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
