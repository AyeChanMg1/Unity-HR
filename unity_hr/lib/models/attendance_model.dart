import 'package:flutter/material.dart';

class Attendance {
  String id;
  IconData icon;
  String name;
  String count;
  Color color;

  Attendance(
      {required this.id,
      required this.icon,
      required this.name,
      required this.count,
      required this.color});
}

class Request {
  String id;
  String title;
  String total;
  Color color;
  IconData icon;

  Request({
    required this.id,
    required this.title,
    required this.total,
    required this.color,
    required this.icon,
  });
}
