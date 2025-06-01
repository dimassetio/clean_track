import 'package:clean_track/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavOfficer extends StatelessWidget {
  const BottomNavOfficer({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (int index) {
        switch (index) {
          case 0:
            Get.toNamed(Routes.OFFICER);
            break;
          case 1:
            Get.toNamed(Routes.TASK_HISTORY);
            break;
          case 2:
            Get.toNamed(Routes.PROFILE);
            break;
          default:
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Task History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
