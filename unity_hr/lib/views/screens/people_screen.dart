import 'package:flutter/material.dart';
import 'package:unity_hr/views/widgets/super_scaffold.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      child: Scaffold(body: Center(child: Text("People Screen"))),
    );
  }
}
