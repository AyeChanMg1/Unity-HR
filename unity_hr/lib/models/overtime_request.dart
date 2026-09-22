class OverTimeRequest {
  String id;
  String employeeName;
  String position;
  String date;
  String timeFrom;
  String timeTo;
  String status;
  String profileImage;
  bool isManageable;

  OverTimeRequest({
    required this.id,
    required this.employeeName,
    required this.position,
    required this.date,
    required this.timeFrom,
    required this.timeTo,
    required this.status,
    required this.profileImage,
    required this.isManageable,
  });

  factory OverTimeRequest.fromJson(Map<String, dynamic> json) {
    return OverTimeRequest(
      id: json['id'].toString(),
      employeeName: json['employee_name'].toString(),
      position: json['position'].toString(),
      date: json['date'].toString(),
      timeFrom: json['time_from'].toString(),
      timeTo: json['time_to'].toString(),
      status: json['status'].toString(),
      profileImage: json['profile_image'].toString(),
      isManageable: json['is_manageable'] ?? false,
    );
  }
}
