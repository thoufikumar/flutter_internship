import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/notification_controller.dart';
import '../widgets/admin_bottom_navbar.dart';
import '../controllers/payment_controller.dart';

class AdminRequestScreen extends StatefulWidget {
  const AdminRequestScreen({super.key});

  @override
  State<AdminRequestScreen> createState() => _RequestHandlingScreenState();
}

class _RequestHandlingScreenState extends State<AdminRequestScreen> {
  String selectedStatus = 'Accepted';
  final List<String> statusOptions = ['Accepted', 'Rejected', 'Waiting'];
  final notificationController = NotificationController();
  Map<String, String> selectedStatuses = {};

  int calculateAmount(String size, String orderDetails) {
    final isSingle = orderDetails.toLowerCase().contains("single");
    final isDual = orderDetails.toLowerCase().contains("dual");
    final isFamily = orderDetails.toLowerCase().contains("family");

    switch (size.toUpperCase()) {
      case 'A5':
        if (isSingle) return 399;
        if (isDual) return 699;
        if (isFamily) return 1299;
        break;
      case 'A4':
        if (isSingle) return 699;
        if (isDual) return 1199;
        if (isFamily) return 2399;
        break;
      case 'A3':
        if (isSingle) return 999;
        if (isDual) return 1799;
        if (isFamily) return 2799;
        break;
      case 'A2':
        if (isSingle) return 1499;
        if (isDual) return 2299;
        if (isFamily) return 3499;
        break;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Handle Requests")),
      bottomNavigationBar: const AdminBottomNavbar(currentIndex: 3),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;

              final name = data['name'] ?? '';
              final deadline = data['paymentMode'] ?? '';
              final orderDetails = data['orderDetails'] ?? '';
              final size = data['deadline'] ?? '';
              final imageLink = data['imageLink'] ?? '';
              final phone = data['phone'] ?? '';
              final contact = data['contact'] ?? '';
              final agreement = data['agreement'] ?? '';
              final email = data['email'] ?? '';
              final status = data['status'] ?? 'Waiting';

              final price = calculateAmount(size, orderDetails);
              final paymentController = PaymentController();

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 12),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name: $name", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text("Order Type: $orderDetails"),
                            Text("Sheet Size: $size"),
                            Text("Deadline: $deadline"),
                            Text("Phone: $phone"),
                            Text("Email: $contact"),
                            const SizedBox(height: 10),
                            Text("Agreement: $agreement", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 10),
                            Text("Amount: ₹$price", style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        final TextEditingController amountController = TextEditingController();

                                        return AlertDialog(
                                          title: const Text("Enter Payment Amount"),
                                          content: TextField(
                                            controller: amountController,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            decoration: const InputDecoration(
                                              labelText: "Amount (INR)",
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text("Cancel"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final amountText = amountController.text.trim();
                                                final amount = double.tryParse(amountText);

                                                if (amount == null || amount <= 0) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text("Please enter a valid amount")),
                                                  );
                                                  return;
                                                }

                                                Navigator.pop(context); // Close the dialog

                                                final paymentUrl = await paymentController.generateWhatsappLink(docId, amount.toString());

                                                if (paymentUrl != null) {
                                                  try {
                                                    await launchUrl(Uri.parse(paymentUrl), mode: LaunchMode.externalApplication);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text("Payment request sent to $name")),
                                                    );
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text("Could not open WhatsApp: $e")),
                                                    );
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text("Failed to generate payment link")),
                                                  );
                                                }
                                              },
                                              child: const Text("Send Request"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    textStyle: const TextStyle(fontSize: 13),
                                  ),
                                  child: const Text("Request Payment"),
                                ),

                                SizedBox(
                                  height: 42,
                                  child: DropdownButton<String>(
                                    value: statusOptions.contains(selectedStatuses[docId] ?? status)
                                        ? (selectedStatuses[docId] ?? status)
                                        : null,
                                    underline: const SizedBox(),
                                    hint: const Text("Status"),
                                    items: statusOptions.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedStatuses[docId] = newValue!;
                                      });
                                      FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(docId)
                                          .update({'status': newValue});
                                    },
                                  ),
                                ),

                                IconButton(
                                  onPressed: () async {
                                    await notificationController.notifyCustomerFromOrder(docId);
                                  },
                                  icon: const Icon(Icons.telegram),
                                  tooltip: "Notify via Telegram",
                                  color: Colors.deepPurple,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                imageLink,
                                height: 160,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Text("Image failed to load"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
