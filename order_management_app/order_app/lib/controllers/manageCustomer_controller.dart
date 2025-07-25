import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });
}

class CustomerController extends GetxController {
  RxList<Customer> customers = <Customer>[].obs;

  @override
  void onInit() {
    fetchCustomersFromOrders();
    super.onInit();
  }

  /// Fetch unique customers from 'orders' collection
  void fetchCustomersFromOrders() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('orders').get();

      final uniqueCustomers = <String, Customer>{};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final id = data['customerId'] ?? doc.id;
        final name = data['name'] ?? 'Unknown';
        final email = data['contact'] ?? 'No Email'; // contact holds actual email
        final phone = data['phone'] ?? 'No Phone';

        if (!uniqueCustomers.containsKey(id)) {
          uniqueCustomers[id] = Customer(id: id, name: name, email: email, phone: phone);
        }
      }

      customers.value = uniqueCustomers.values.toList();
    } catch (e) {
      print("Error fetching customers: $e");
    }
  }


  Customer? getCustomerById(String id) {
    return customers.firstWhereOrNull((c) => c.id == id);
  }

  /// Delete customer by deleting all their related orders
  Future<void> deleteCustomer(String customerId) async {
    try {
      // Delete orders where customerId matches
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('customerId', isEqualTo: customerId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Remove from local list
      customers.removeWhere((c) => c.id == customerId);
    } catch (e) {
      print("Error deleting customer: $e");
    }
  }
}
