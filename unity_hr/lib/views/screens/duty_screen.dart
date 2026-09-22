import 'package:flutter/material.dart';
import 'package:unity_hr/views/widgets/super_scaffold.dart';

class DutyScreen extends StatefulWidget {
  const DutyScreen({super.key});

  @override
  State<DutyScreen> createState() => _DutyScreenState();
}

class _DutyScreenState extends State<DutyScreen> {
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
              child: Center(child: Text('Duty Screen - section ${index + 1}')),
            );
          },
        ),
      ),
    );
  }
}
