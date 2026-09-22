class DutyTask {
  int id;
  String? dutyId;
  String name;
  String description;
  String? jobDate;
  String? employeeId;
  String? priority;
  String? status;
  String? requestStatus;
  String? remark;
  String finishStatus;
  bool extend;
  String extendStatus;
  String extendReason;
  int extendDays;
  int? percentage;
  int? duration;
  String? intervalStatus;
  String? img;
  String? timeFrom;
  String? timeTo;
  String subName;
  String subDesc;
  String subStatus;
  bool substitute;
  String subReason;
  bool? extendButtonStatus;

  DutyTask({
    required this.id,
    this.dutyId,
    required this.name,
    required this.description,
    this.jobDate,
    this.employeeId,
    this.priority,
    this.status,
    this.requestStatus,
    this.remark,
    required this.finishStatus,
    required this.extend,
    required this.extendStatus,
    required this.extendReason,
    required this.extendDays,
    this.percentage,
    this.duration,
    this.intervalStatus,
    this.img,
    this.timeFrom,
    this.timeTo,
    required this.subName,
    required this.subDesc,
    required this.subStatus,
    required this.substitute,
    required this.subReason,
    this.extendButtonStatus,
  });

  // Factory method to create an instance from JSON
  factory DutyTask.fromJson(Map<String, dynamic> json) {
    return DutyTask(
      id: json['id'],
      dutyId: json['duty_id'],
      name: json['name'],
      description: json['description'],
      jobDate: json['job_date'],
      employeeId: json['employee_id'],
      priority: json['priority'],
      status: json['status'],
      requestStatus: json['request_status'] ?? "pending",
      remark: json['remark'] ?? "--",
      finishStatus: json['finish_status'] ?? "0",
      extend: json['extend'] == 1 ? true : false,
      extendStatus: json['extend_status'],
      extendReason: json['extend_reason'] ?? "",
      extendDays: json['extend_days'] ?? 0,
      percentage: json['percentage'] is int
          ? json['percentage']
          : int.tryParse(json['percentage'].toString()),
      duration: json['duration'] is int
          ? json['duration']
          : int.tryParse(json['duration'].toString()),
      intervalStatus: json['interval_status'],
      img: json['img'],
      timeFrom: json['time_from'],
      timeTo: json['time_to'],
      subName: json['sub_name'] ?? "",
      subDesc: json['sub_description'] ?? "",
      subStatus: json['sub_status'] ?? "",
      substitute: json['substitute'] == 1 ? true : false,
      subReason: json['sub_reason'] ?? "--",
      extendButtonStatus: json['extend_btn_status'] == 1 ? true : false,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duty_id': dutyId,
      'name': name,
      'description': description,
      'job_date': jobDate,
      'employee_id': employeeId,
      'priority': priority,
      'status': status,
      "request_status": requestStatus,
      "remark": remark,
      'finish_status': finishStatus,
      'extend': extend,
      'extend_status': extendStatus,
      'extend_reason': extendReason,
      'extend_days': extendDays,
      'interval_status': intervalStatus,
      'img': img,
      'time_from': timeFrom,
      'time_to': timeTo,
      'sub_name': subName,
      'sub_description': subDesc,
      'sub_status': subStatus,
      'substitute': substitute,
      'sub_reason': subReason,
    };
  }
}
