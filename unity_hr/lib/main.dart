import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unity_hr/helpers/app_themes.dart';
import 'package:unity_hr/controllers/global_controller.dart';
import 'package:unity_hr/views/screens/first_screen.dart';
import 'package:unity_hr/views/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Unity HR',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      initialBinding: BindingsBuilder(() {
        GlobalController().initController();
      }),
      // home: const LoginScreen(),
      home: FirstScreen(),
    );
  }
}
