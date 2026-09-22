import 'package:flutter/material.dart';
import 'package:unity_hr/views/widgets/super_scaffold.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      child: Scaffold(
        body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
          itemCount: 20,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('Team Screen - section ${index + 1}')),
            );
          },
        ),
      ),
    );
  }
}
