import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String upiId = 'sjartistic3422-1@oksbi'; // Static UPI ID

  Future<String?> generateWhatsappLink(String docId, String amount) async {
    try {
      final doc = await _firestore.collection('orders').doc(docId).get();
      final data = doc.data();

      if (data == null) {
        print("Document not found.");
        return null;
      }

      final customerName = data['name'] ?? 'Customer';
      final phone = data['phone'];

      if (phone == null || phone.toString().isEmpty) {
        print("Phone number not found.");
        return null;
      }

      final upiLink = "upi://pay?pa=$upiId&pn=Teshart&am=$amount&cu=INR";
      final message =
          "Hello $customerName, please make a payment of ₹$amount for your order.\n\nClick to pay via UPI:\n$upiLink\n\nThank you!";
      final encoded = Uri.encodeComponent(message);
      final whatsappLink = "https://wa.me/91$phone?text=$encoded";

      return whatsappLink;
    } catch (e) {
      print("Error generating WhatsApp link: $e");
      return null;
    }
  }
}
