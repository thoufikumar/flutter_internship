import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sends WhatsApp notification to the customer based on general order status.
  Future<void> notifyCustomerFromOrder(String orderId) async {
    try {
      final doc = await _firestore.collection("orders").doc(orderId).get();

      if (!doc.exists) {
        Get.snackbar("Error", "Order not found in Firestore");
        return;
      }

      final data = doc.data()!;
      final customerName = data['name'] ?? 'Customer';
      final customerPhone = (data['phone'] ?? data['contact'] ?? '').toString().trim();
      final orderStatus = data['status'] ?? 'Pending';

      if (customerPhone.isEmpty) {
        Get.snackbar("Error", "Customer phone number is missing in order");
        return;
      }

      // Prepare a message based on the status
      String statusMessage;
      switch (orderStatus.toLowerCase()) {
        case "accepted":
          statusMessage = "Good news, your order has been *Accepted*! 🎉";
          break;
        case "rejected":
          statusMessage = "We regret to inform you that your order was *Rejected*. 😔";
          break;
        case "waiting":
        case "pending":
          statusMessage = "Your order is still in *Pending* status. We'll update you soon.";
          break;
        default:
          statusMessage = "Your order status is: *$orderStatus*";
      }

      final message = '''
Hello $customerName,

This is a quick update from *Custom Art* 🖌️.

$statusMessage

If you have any questions, feel free to reply here.

- Admin (WhatsApp: 8610076840)
''';

      await _launchWhatsAppUrl(customerPhone, message);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  /// Sends WhatsApp message with "order in progress" template
  Future<void> notifyOrderInProgress(String orderId) async {
    try {
      final doc = await _firestore.collection("orders").doc(orderId).get();

      if (!doc.exists) {
        Get.snackbar("Error", "Order not found");
        return;
      }

      final data = doc.data()!;
      final customerName = data['name'] ?? 'Customer';
      final customerPhone = (data['contact'] ?? data['phone'] ?? '').toString().trim();
      final orderDetails = data['orderDetails'] ?? '';
      final size = data['deadline'] ?? '';
      final payment = data['paymentMode'] ?? '';
      final status = data['status'] ?? '';

      if (customerPhone.isEmpty) {
        Get.snackbar("Error", "No phone number in order");
        return;
      }

      if (status.toLowerCase() != 'accepted') {
        Get.snackbar("Not Accepted", "This order is not marked as 'Accepted'");
        return;
      }

      final message = '''
Hello $customerName,

Just letting you know that your order is now *In Progress*! 🛠️

🖌️ Order Details: $orderDetails
📏 Size: $size
💳 Payment Mode: $payment

We’ll update you once it’s completed. Thanks for choosing *Custom Art*! 😊
- Admin (WhatsApp: 8610076840)
''';

      await _launchWhatsAppUrl(customerPhone, message);
      Get.snackbar("WhatsApp", "Opened WhatsApp for $customerName");
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    }
  }

  /// New: Sends WhatsApp message when status message is updated manually (like a statusMessage field)
  Future<void> notifyCustomerFromStatusMessage(String orderId) async {
    try {
      final doc = await _firestore.collection("orders").doc(orderId).get();

      if (!doc.exists) {
        Get.snackbar("Error", "Order not found");
        return;
      }

      final data = doc.data()!;
      final customerName = data['name'] ?? 'Customer';
      final customerPhone = (data['contact'] ?? data['phone'] ?? '').toString().trim();
      final statusMessage = data['statusMessage'] ?? 'Your order has been updated.';

      if (customerPhone.isEmpty) {
        Get.snackbar("Error", "Customer phone number not found");
        return;
      }

      final message = '''
Hello $customerName,

This is an update regarding your order from *Custom Art* 🎨.

$statusMessage

If you have any concerns or queries, feel free to message us.

- Admin (WhatsApp: 8610076840)
''';

      await _launchWhatsAppUrl(customerPhone, message);
      Get.snackbar("WhatsApp", "Opened WhatsApp to notify $customerName");
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    }
  }

  /// Opens WhatsApp URL with pre-filled message
  Future<void> _launchWhatsAppUrl(String phone, String message) async {
    // Clean up phone number to digits only
    String formattedPhone = phone.replaceAll(RegExp(r'\D'), '');

    // Validate minimum 10-digit number
    if (formattedPhone.length < 10) {
      Get.snackbar("Invalid Phone", "The phone number is too short.");
      return;
    }

    // Add country code if missing
    if (!formattedPhone.startsWith('91')) {
      formattedPhone = '91$formattedPhone';
    }

    final encodedMsg = Uri.encodeComponent(message);
    final whatsappUrl = 'https://wa.me/$formattedPhone?text=$encodedMsg';
    final Uri url = Uri.parse(whatsappUrl);
    canLaunchUrl(url);
    await launchUrl(url, mode: LaunchMode.externalApplication);
    // if (await ) {
    // } else {
    //   Get.snackbar("WhatsApp Error", "Could not open WhatsApp for $formattedPhone");
    // }
  }

}
