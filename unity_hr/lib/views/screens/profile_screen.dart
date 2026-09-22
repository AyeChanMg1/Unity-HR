import 'package:flutter/material.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/views/widgets/super_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      child: Scaffold(
        backgroundColor: color2.withValues(alpha: 0.2),
        body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
          itemCount: 20,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text('Profile Screen - section ${index + 1}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
