import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReceiptController extends GetxController {
  RxInt selectedTabIndex = 0.obs;
  RxString selectedMonth = 'July'.obs;
  RxString selectedYear = '2025'.obs;
  RxString selectedDay = '14'.obs;

  RxList<Map<String, dynamic>> receipts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReceipts(); // fetch on load
  }


  void fetchReceipts() {
    FirebaseFirestore.instance.collection('receipts').snapshots().listen((snapshot) {
      final fetchedReceipts = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': data['name'] ?? '',
          'amount': "₹${data['amount'] ?? '0'}",
          'date': _formatDate(data['date']),
          'status': data['status'] ?? 'Pending',
          'details': _generateDetails(data),
        };
      }).toList();

      receipts.value = fetchedReceipts;
    });
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final dt = DateTime.parse(isoDate);
      return "${_monthName(dt.month)} ${dt.day}, ${dt.year}";
    } catch (e) {
      return isoDate;
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _generateDetails(Map<String, dynamic> data) {
    return '''
Order: ${data['orderDetails'] ?? '-'}
Size: ${data['size'] ?? '-'}
Contact: ${data['contact'] ?? '-'}
Image Link: ${data['imageLink'] ?? '-'}
''';
  }
}
