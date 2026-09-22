import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unity_hr/controllers/navbar_controller.dart';
import 'package:unity_hr/views/widgets/bottom_nav_bar.dart';
import 'package:unity_hr/views/widgets/super_scaffold.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      child: GetBuilder<NavBarController>(
        builder: (controller) {
          return Scaffold(
            extendBody: true,
            body: Stack(
              fit: StackFit.expand,
              children: [
                controller.indexWidgets[controller.currentIndex],
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: buildButtomNavBar(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
