class OverTimeHistory {
  String id;
  String employeeName;
  String position;
  String date;
  String timeFrom;
  String timeTo;
  String status;
  OverTimeHistory({
    required this.id,
    required this.employeeName,
    required this.position,
    required this.date,
    required this.timeFrom,
    required this.timeTo,
    required this.status,
  });

  factory OverTimeHistory.fromJson(Map<String, dynamic> json) {
    return OverTimeHistory(
      id: json['id'].toString(),
      employeeName: json['employee_name'].toString(),
      position: json['position'].toString(),
      date: json['date'].toString(),
      timeFrom: json['time_from'].toString(),
      timeTo: json['time_to'].toString(),
      status: json['status'].toString(),
    );
  }
}
