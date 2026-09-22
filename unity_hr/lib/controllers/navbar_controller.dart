import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:unity_hr/views/screens/duty_screen.dart';
import 'package:unity_hr/views/screens/home_screen.dart';
import 'package:unity_hr/views/screens/people_screen.dart';
import 'package:unity_hr/views/screens/profile_screen.dart';
import 'package:unity_hr/views/screens/requests_screen.dart';
import 'package:unity_hr/views/screens/team_screen.dart';

class NavBarController extends GetxController {
  int currentIndex = 0;

  void changePage(int index) {
    currentIndex = index;
    update();
  }

  final List<Widget> indexWidgets = <Widget>[
    const HomeScreen(),
    const RequestsScreen(),
    const TeamScreen(),
    const DutyScreen(),
    const ProfileScreen(),
  ];

  final List<Widget> indexAdminWidgets = <Widget>[
    const HomeScreen(),
    const PeopleScreen(),
    const ProfileScreen(),
  ];
}
