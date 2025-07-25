import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/admin_bottom_navbar.dart';
import '../theme/admin_theme.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _receipts = [];

  @override
  void initState() {
    super.initState();
    _loadReceipts();
  }

  Future<void> _loadReceipts() async {
    final snapshot = await _firestore.collection('receipts').get();
    final fetchedReceipts = snapshot.docs.map((doc) {
      final data = doc.data();
      data['orderId'] = doc.id;
      return data;
    }).toList();

    setState(() {
      _receipts = fetchedReceipts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: adminTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Receipts'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadReceipts,
              tooltip: 'Refresh Receipts',
            ),
          ],
        ),
        bottomNavigationBar: const AdminBottomNavbar(currentIndex: 1),
        body: _receipts.isEmpty
            ? const Center(child: Text('No receipts available'))
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _receipts.length,
          itemBuilder: (context, index) {
            final receipt = _receipts[index];
            final String orderId = receipt['orderId'] ?? 'N/A';
            final String customerName = receipt['name'] ?? 'Customer';
            final String itemName = receipt['orderDetails'] ?? 'Item';
            final String size = receipt['size'] ?? 'N/A';
            final double amount =
                double.tryParse(receipt['amount']?.toString() ?? '0') ?? 0;
            final String status = receipt['status'] ?? 'Pending';
            final String dateStr = receipt['date'] ?? '';
            final DateTime orderDate =
                DateTime.tryParse(dateStr) ?? DateTime.now();
            final formattedDate =
                '${orderDate.day}/${orderDate.month}/${orderDate.year}';

            return Card(
              shape: Theme.of(context).cardTheme.shape,
              color: Theme.of(context).cardTheme.color,
              elevation: Theme.of(context).cardTheme.elevation,
              shadowColor: Theme.of(context).cardTheme.shadowColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order ID: $orderId",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Customer: $customerName",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text("Item: $itemName"),
                    Text("Size: $size"),
                    Text("Amount: ₹${amount.toStringAsFixed(2)}"),
                    Text("Order Date: $formattedDate"),
                    const SizedBox(height: 10),
                    Divider(color: Colors.grey.shade300),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status: $status",
                          style: TextStyle(
                            color: status == 'Fully Paid'
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/receipts',
                                arguments: receipt);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text("View Details"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
