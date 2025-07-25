import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'manageCustomer_controller.dart'; // make sure path is correct

class NotifyController extends GetxController {
  var message = ''.obs;
  final customerController = Get.find<CustomerController>();

  void updateMessage(String newMessage) {
    message.value = newMessage;
  }

  Future<void> sendNotification() async {
    if (message.value.trim().isEmpty) {
      Get.snackbar("Error", "Message cannot be empty");
      return;
    }

    final customers = customerController.customers;

    if (customers.isEmpty) {
      Get.snackbar("Error", "No customers found to notify");
      return;
    }

    for (var customer in customers) {
      final phone = customer.phone.trim();

      // Ensure phone number has only digits (remove spaces, dashes, +91, etc. if needed)
      final formattedPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');

      if (formattedPhone.isNotEmpty) {
        final encodedMessage = Uri.encodeComponent(message.value);
        final uri = Uri.parse("https://wa.me/$formattedPhone?text=$encodedMessage");

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          print("Could not launch WhatsApp for $formattedPhone");
        }
      }
    }

    Get.snackbar("Success", "Message sent to all customers via WhatsApp");
  }
}