import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/manageCustomer_controller.dart';

class CustomerDetailScreen extends StatelessWidget {
  final String customerId;

  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerController>();
    final customer = controller.getCustomerById(customerId);

    if (customer == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Customer Details")),
        body: const Center(child: Text("Customer not found")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Get.defaultDialog(
                title: "Delete",
                middleText: "Are you sure you want to delete this customer?",
                onConfirm: () {
                  controller.deleteCustomer(customerId);
                  Get.back(); // close dialog
                  Get.back(); // back to list
                },
                onCancel: () {},
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.dialog(AddOrEditCustomerDialog(editCustomer: customer));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${customer.name}", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text("Email: ${customer.email}"),
            const SizedBox(height: 8),
            Text("Phone: ${customer.phone}"),
          ],
        ),
      ),
    );
  }
}
class AddOrEditCustomerDialog extends StatefulWidget {
  final Customer? editCustomer;

  const AddOrEditCustomerDialog({super.key, this.editCustomer});

  @override
  State<AddOrEditCustomerDialog> createState() => _AddOrEditCustomerDialogState();
}

class _AddOrEditCustomerDialogState extends State<AddOrEditCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  final controller = Get.find<CustomerController>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.editCustomer?.name ?? '');
    emailController = TextEditingController(text: widget.editCustomer?.email ?? '');
    phoneController = TextEditingController(text: widget.editCustomer?.phone ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.editCustomer != null ? "Edit Customer" : "Add Customer"),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
      // actions: [
      //   TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
      //   ElevatedButton(
      //     onPressed: () {
      //       if (_formKey.currentState!.validate()) {
      //         if (widget.editCustomer != null) {
      //           // Update
      //           controller.updateCustomer(
      //             widget.editCustomer!.id,
      //             Customer(
      //               id: widget.editCustomer!.id,
      //               name: nameController.text,
      //               email: emailController.text,
      //               phone: phoneController.text,
      //             ),
      //           );
      //         } else {
      //           // Add
      //           final newId = DateTime.now().millisecondsSinceEpoch.toString();
      //           controller.addCustomer(Customer(
      //             id: newId,
      //             name: nameController.text,
      //             email: emailController.text,
      //             phone: phoneController.text,
      //           ));
      //         }
      //         Get.back();
      //       }
      //     },
      //     child: const Text("Save"),
      //   ),
      // ],
    );
  }
}
