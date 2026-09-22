import 'package:flutter/material.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/views/widgets/super_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      topColor: color1,
      botColor: color1,
      child: Scaffold(
        backgroundColor: Colors.green.shade50,
        body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
          itemCount: 20,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('Home Screen - section ${index + 1}')),
            );
          },
        ),
      ),
    );
  }
}
