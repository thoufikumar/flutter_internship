import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/request_handling_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/reciept_screen.dart';
import 'theme/admin_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: adminTheme,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () =>  LoginScreen()),
        GetPage(name: '/orders', page: () => AdminOrderScreen()),
        GetPage(name: '/requests', page: () => AdminRequestScreen()),
        GetPage(name: '/receipts', page: () => ReceiptScreen()),
        GetPage(name: '/profile', page: () => AdminAccountScreen()),
      ],
    );
  }
}
