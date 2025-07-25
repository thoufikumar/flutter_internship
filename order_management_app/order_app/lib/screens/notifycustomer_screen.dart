import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/manageCustomer_controller.dart';
import '../controllers/notify_controller.dart';
import '../widgets/admin_bottom_navbar.dart';

class NotifyCustomersScreen extends StatelessWidget {
  NotifyCustomersScreen({super.key});

  final controller = Get.put(NotifyController());
  final controller1= Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Notify Customers")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Good move!", style: TextStyle(fontSize: 18)),
            const Text("Awake the customers", style: TextStyle(fontSize: 18)),
            const Text(
              "Sale season is live",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // TEXT FIELD
            Obx(() => TextField(
              onChanged: controller.updateMessage,
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: controller.message.value,
                  selection: TextSelection.collapsed(offset: controller.message.value.length),
                ),
              ),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Type a message...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            )),

            const SizedBox(height: 16),

            // SEND BUTTON
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: controller.sendNotification,
                child: const Text("Send"),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const AdminBottomNavBar(currentIndex: 3),
    );
  }
}
