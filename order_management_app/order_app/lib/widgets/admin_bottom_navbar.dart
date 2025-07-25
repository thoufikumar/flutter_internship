import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminBottomNavbar extends StatelessWidget {
  final int currentIndex;
  const AdminBottomNavbar({super.key,required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index){
        if(index == currentIndex) return;

        switch(index){
          case 0:
            Get.offNamed('/orders');
          case 1:
            Get.offNamed('/receipts');
          case 2:
            Get.offNamed('/profile');
          case 3:
            Get.offNamed('/requests');
          default:
            Get.offNamed('/orders');
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.list_alt),label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt),label: 'Receipts'),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.payment),label: 'Requests'),
      ],
    );
  }
}
