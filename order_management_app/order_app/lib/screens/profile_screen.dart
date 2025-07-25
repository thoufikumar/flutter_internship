import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/admin_bottom_navbar.dart';
import 'manageCustomer_screen.dart';
import 'notifycustomer_screen.dart';
import 'performance_screen.dart';

class AdminAccountScreen extends StatelessWidget {
  const AdminAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileController = Get.put(ProfileController());
    final authController = Get.put(AuthController());

    final TextEditingController nameController =
    TextEditingController(text: profileController.username.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Profile Image with camera icon
            Obx(() {
              return Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: theme.cardColor,
                    backgroundImage: profileController.profileImageUrl.value.isNotEmpty
                        ? NetworkImage(profileController.profileImageUrl.value)
                        : null,
                    child: profileController.profileImageUrl.value.isEmpty
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: InkWell(
                      onTap: () {
                        profileController.updateProfileImage("https://i.pravatar.cc/300");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.primaryColor,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),

            // Username Field with pencil icon
            Obx(() {
              nameController.text = profileController.username.value;
              return TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      profileController.updateUsername(nameController.text);
                      Get.snackbar('Success', 'Username updated',
                          snackPosition: SnackPosition.BOTTOM);
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 32),

            // Action List with Navigation
            AccountActionTile(
              title: 'Notify customers',
              onTap: () => Get.to(() =>  NotifyCustomersScreen()),
            ),
            AccountActionTile(
              title: 'Manage customers',
              onTap: () => Get.to(() => const ManageCustomersScreen()),
            ),
            AccountActionTile(
              title: 'Performance',
              onTap: () => Get.to(() =>  PerformanceScreen()),
            ),
            AccountActionTile(
              title: 'Logout',
              onTap: () {
                authController.logout();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavbar(currentIndex: 2),
    );
  }
}

class AccountActionTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const AccountActionTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16)),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}
