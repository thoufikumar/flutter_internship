import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/manageCustomer_controller.dart';
import 'customerdetails_screen.dart';

class ManageCustomersScreen extends StatelessWidget {
  const ManageCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Customers"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.customers.isEmpty) {
          return const Center(
            child: Text(
              "No customers found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.customers.length,
          itemBuilder: (context, index) {
            final customer = controller.customers[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade300,
                  child: Text(
                    customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  customer.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customer.email, style: const TextStyle(fontSize: 13)),
                      Text(customer.phone, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(() => CustomerDetailScreen(customerId: customer.id));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
