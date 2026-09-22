class LeaveHistory {
  String id;
  String employeeName;
  String position;
  String leaveType;
  String startDate;
  String endDate;
  String leaveCount;
  String duration;
  String status;
  bool editStatus;

  LeaveHistory({
    required this.id,
    required this.employeeName,
    required this.position,
    required this.leaveCount,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.status,
    required this.editStatus,
  });

  factory LeaveHistory.fromJson(Map<String, dynamic> json) {
    return LeaveHistory(
      id: json['id'].toString(),
      employeeName: json['employee_name'].toString(),
      position: json['position'].toString(),
      leaveCount: json['leave_count'].toString(),
      leaveType: json['leave_type'].toString(),
      startDate: json['date_from'].toString(),
      endDate: json['date_to'].toString(),
      duration: json['duration'].toString(),
      status: json['status'].toString(),
      editStatus: json['edit_status'] ?? false,
    );
  }
}
