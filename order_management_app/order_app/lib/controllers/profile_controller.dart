import 'package:get/get.dart';

class ProfileController extends GetxController {
  var username = 'AdminUser'.obs;
  var profileImageUrl = ''.obs;

  void updateUsername(String newName) {
    username.value = newName;
  }

  void updateProfileImage(String newUrl) {
    profileImageUrl.value = newUrl;
  }
}
