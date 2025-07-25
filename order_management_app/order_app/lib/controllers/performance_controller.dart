import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PerformanceController extends GetxController {
  final totalOrders = 0.obs;
  final completedOrders = 0.obs;
  final cancelledOrders = 0.obs;
  final totalRevenue = 0.0.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchPerformanceData();
  }

  Future<void> fetchPerformanceData() async {
    try {
      final snapshot = await _firestore.collection('orders').get();
      final docs = snapshot.docs;

      int total = docs.length;
      int completed = 0;
      int cancelled = 0;
      double revenue = 0.0;

      for (var doc in docs) {
        final data = doc.data();
        final status = data['status'] ?? '';

        double amount = 0.0;
        final rawAmount = data['amount'];

        if (rawAmount is num) {
          amount = rawAmount.toDouble();
        } else if (rawAmount is String) {
          amount = double.tryParse(rawAmount.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
        }

        if (status == 'Completed') {
          completed++;
          revenue += amount;
        } else if (status == 'Cancelled') {
          cancelled++;
        }
      }


      totalOrders.value = total;
      completedOrders.value = completed;
      cancelledOrders.value = cancelled;
      totalRevenue.value = revenue;
    } catch (e) {
      print('Error fetching performance data: $e');
    }
  }

  void refreshPerformanceData() => fetchPerformanceData();
}
