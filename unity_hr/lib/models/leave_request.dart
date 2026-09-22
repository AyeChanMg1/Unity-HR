class LeaveRequest {
  String id;
  String name;
  String position;
  String leaveType;
  String dateFrom;
  String dateTo;
  String status;
  String duration;
  String image;
  bool isManageable;
  LeaveRequest({
    required this.id,
    required this.name,
    required this.position,
    required this.leaveType,
    required this.dateFrom,
    required this.dateTo,
    required this.status,
    required this.duration,
    required this.image,
    required this.isManageable,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'].toString(),
      name: json['employee_name'].toString(),
      position: json['position'].toString(),
      leaveType: json['leave_type'].toString(),
      dateFrom: json['date_from'].toString(),
      dateTo: json['date_to'].toString(),
      status: json['status'].toString(),
      duration: json['duration'].toString(),
      image: json['profile_image'].toString(),
      isManageable: json['is_manageable'] ?? false,
    );
  }
}
