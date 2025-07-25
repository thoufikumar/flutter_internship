import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/notification_controller.dart';
import '../controllers/order_controller.dart';
import '../widgets/admin_bottom_navbar.dart';
import '../theme/admin_theme.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AdminOrderScreen extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  AdminOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: adminTheme,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('My Orders', style: Theme.of(context).textTheme.titleLarge),
            bottom: const TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'In Progress'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FirestoreOrderList(status: 'Accepted'),
              FirestoreOrderList(status: 'Completed'),
              FirestoreOrderList(status: 'Rejected'),
            ],
          ),
          bottomNavigationBar: const AdminBottomNavbar(currentIndex: 0),
        ),
      ),
    );
  }
}

class FirestoreOrderList extends StatelessWidget {
  final String status;
  const FirestoreOrderList({super.key, required this.status});

  int calculateAmount(String size, String orderDetails) {
    final isSingle = orderDetails.toLowerCase().contains("single");
    final isDual = orderDetails.toLowerCase().contains("dual");
    final isFamily = orderDetails.toLowerCase().contains("family");

    switch (size.toUpperCase()) {
      case 'A5':
        if (isSingle) return 399;
        if (isDual) return 699;
        if (isFamily) return 1299;
      case 'A4':
        if (isSingle) return 699;
        if (isDual) return 1199;
        if (isFamily) return 2399;
      case 'A3':
        if (isSingle) return 999;
        if (isDual) return 1799;
        if (isFamily) return 2799;
      case 'A2':
        if (isSingle) return 1499;
        if (isDual) return 2299;
        if (isFamily) return 3499;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').where('status', isEqualTo: status).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final orders = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final data = orders[index].data() as Map<String, dynamic>;
            final docId = orders[index].id;

            final name = data['name'] ?? '';
            final date = data['paymentMode'] ?? '';
            final orderDetails = data['orderDetails'] ?? '';
            final size = data['deadline'] ?? '';
            final imageLink = data['imageLink'] ?? '';
            final contact = data['contact'] ?? '';
            final price = calculateAmount(size, orderDetails);

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("Date: $date", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
                          const SizedBox(height: 8),
                          Text("Order Type: $orderDetails", style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 12),
                          Text("Amount: ₹$price", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),

                          if (status == 'Completed')
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final receiptData = {
                                    'name': name,
                                    'date': DateTime.now().toString(),
                                    'orderDetails': orderDetails,
                                    'size': size,
                                    'amount': price,
                                    'imageLink': imageLink,
                                    'contact': contact,
                                    'orderId': docId,
                                    'status': 'Generated',
                                    'quantity': '1',
                                    'price': price.toString(),
                                  };

                                  await FirebaseFirestore.instance.collection('receipts').doc(docId).set(receiptData);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Receipt generated.")));

                                  // Navigate to Receipt Screen
                                  // Get.toNamed('/receipts', arguments: receiptData);
                                },
                                icon: const Icon(Icons.receipt_long),
                                label: const Text("Generate Receipt"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                            ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              // Dropdown for status
                              Expanded(
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: DropdownButton<String>(
                                    style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
                                    isExpanded: true,
                                    value: status,
                                    underline: const SizedBox(),
                                    icon: const Icon(Icons.arrow_drop_down),
                                    items: const [
                                      DropdownMenuItem(value: 'Accepted', child: Text('In Progress')),
                                      DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                                      DropdownMenuItem(value: 'Rejected', child: Text('Cancelled')),
                                    ],
                                    onChanged: (value) async {
                                      if (value != null) {
                                        await FirebaseFirestore.instance.collection('orders').doc(docId).update({'status': value});

                                        if (value == 'Completed') {
                                          final receiptData = {
                                            'name': name,
                                            'date': DateTime.now().toString(),
                                            'orderDetails': orderDetails,
                                            'size': size,
                                            'amount': price,
                                            'imageLink': imageLink,
                                            'contact': contact,
                                            'orderId': docId,
                                            'status': 'Generated',
                                            'quantity': '1',
                                            'price': price.toString(),
                                          };

                                          await FirebaseFirestore.instance.collection('receipts').doc(docId).set(receiptData);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Receipt generated.")));
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  final NotificationController controller = Get.put(NotificationController());
                                  await controller.notifyOrderInProgress(docId);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  textStyle: const TextStyle(fontSize: 12),
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Notify User"),
                              ),

                            ],
                          ),
                          const SizedBox(height: 8),

                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("Full Details for $name"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: data.entries.map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          children: [
                                            Text("${e.key}: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                                            Expanded(child: Text(e.value.toString())),
                                          ],
                                        ),
                                      )).toList(),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Close"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text("Tap to view full details", style: TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Image View
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Submitted Image"),
                            content: imageLink.isNotEmpty
                                ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(imageLink),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await downloadImageToDevice(imageLink);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Downloading image...")),
                                    );
                                  },
                                  icon: const Icon(Icons.download),
                                  label: const Text("Download Image"),
                                ),
                              ],
                            )
                                : const Text("No image available"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Close"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text("Image"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Future<void> downloadImageToDevice(String imageUrl) async {
  try {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      print("Permission denied");
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final fileName = "art_image_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final filePath = "${tempDir.path}/$fileName";

    await Dio().download(imageUrl, filePath);

    final downloadsDir = Directory("/storage/emulated/0/Download");
    if (await downloadsDir.exists()) {
      final savedPath = "${downloadsDir.path}/$fileName";
      await File(filePath).copy(savedPath);
      print("Image saved to $savedPath");
    }

  } catch (e) {
    print("Download error: $e");
  }
}
