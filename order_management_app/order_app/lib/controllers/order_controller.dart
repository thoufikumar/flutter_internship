import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var orders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrdersFromFirestore();
  }

  void fetchOrdersFromFirestore() async {
    FirebaseFirestore.instance.collection('orders').snapshots().listen((snapshot) {
      final fetched = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['name'] ?? 'Untitled',
          'date': data['deadline'] ?? '',
          'status': _mapStatusToTab(data['status'] ?? 'Waiting'),
          'imageLink': data['imageLink'] ?? '',
          'rawStatus': data['status'] ?? 'Waiting', // useful if needed
        };
      }).toList();

      orders.value = fetched;
    });
  }

  String _mapStatusToTab(String status) {
    switch (status) {
      case 'Accepted':
        return 'In Progress';
      case 'Rejected':
        return 'Cancelled';
      case 'Completed':
        return 'Completed';
      default:
        return 'In Progress'; // Waiting/Other
    }
  }

  void updateOrderStatus(String orderId, String newStatus) {
    FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': newStatus,
    });
  }

  void requestPayment(String title, String amount) {
    // Store this in a collection like 'payments' or send notification
    print('Requesting payment ₹$amount for $title');
  }
}
