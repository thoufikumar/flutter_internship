import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RequestController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> requests = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  void fetchRequests() {
    _firestore
        .collection('orders')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      requests.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id, // important for updating later
          'name': data['name'] ?? 'Unnamed',
          'status': data['status'] ?? 'Pending',
          'imageLink': data['imageLink'] ?? '',
        };
      }).toList();
    });
  }

  void updateStatus(int index, String newStatus) async {
    final docId = requests[index]['id'];
    try {
      await _firestore.collection('orders').doc(docId).update({
        'status': newStatus,
      });

      // Create a new map with updated status
      final updatedRequest = Map<String, dynamic>.from(requests[index]);
      updatedRequest['status'] = newStatus;

      // Replace the old map with the new one
      requests[index] = updatedRequest;
      requests.refresh();
    } catch (e) {
      print("Status update error: $e");
    }
  }

}
