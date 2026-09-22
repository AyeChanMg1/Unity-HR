import 'dart:convert';

class DutyRequest {
  final int? id;
  final String? name;
  final String? description;
  final String? jobDate;
  final String? timeFrom;
  final String? timeTo;
  final String? priority;
  final String? status;
  final String? requestStatus;
  final String? intervalStatus;
  final int? substitute;
  final String? subStatus;
  final String? subName;
  final String? subDesc;
  final String? subReason;
  final int? extend;
  final String? extendStatus;
  final String? extendReason;
  final int? extendDays;
  final String? employeeId;
  final String? employeeName;
  final String? branchName;
  final String? departmentName;
  final String? empNo;
  final String? remark;
  final String? img;

  DutyRequest({
    this.id,
    this.name,
    this.description,
    this.jobDate,
    this.timeFrom,
    this.timeTo,
    this.priority,
    this.status,
    this.requestStatus,
    this.intervalStatus,
    this.substitute,
    this.subStatus,
    this.subName,
    this.subDesc,
    this.subReason,
    this.extend,
    this.extendStatus,
    this.extendReason,
    this.extendDays,
    this.employeeId,
    this.employeeName,
    this.branchName,
    this.departmentName,
    this.empNo,
    this.remark,
    this.img,
  });

  factory DutyRequest.fromJson(Map<String, dynamic> json) {
    return DutyRequest(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      jobDate: json['job_date'],
      timeFrom: json['time_from'],
      timeTo: json['time_to'],
      priority: json['priority'],
      status: json['status'],
      requestStatus: json['request_status'] ?? "pending",
      intervalStatus: json['interval_status'],
      substitute: json['substitute'] is int
          ? json['substitute']
          : int.tryParse(json['substitute'].toString()),
      subStatus: json['sub_status'],
      subName: json['sub_name'],
      subDesc: json['sub_description'],
      subReason: json['sub_reason'],
      extend: json['extend'] is int
          ? json['extend']
          : int.tryParse(json['extend'].toString()),
      extendStatus: json['extend_status'],
      extendReason: json['extend_reason'],
      extendDays: json['extend_days'] ?? 0,
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      branchName: json['branch_name'],
      departmentName: json['department_name'],
      empNo: json['employee_no'],
      remark: json['remark'],
      img: json['img'],
    );
  }

  // Convert DutyRequest Object to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'job_date': jobDate,
      'time_from': timeFrom,
      'time_to': timeTo,
      'priority': priority,
      'status': status,
      'substitute': substitute,
      'sub_status': subStatus,
      'extend': extend,
      'extend_status': extendStatus,
      'extend_reason': extendReason,
      'extend_days': extendDays,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'branch_name': branchName,
      'department_name': departmentName,
      'employee_no': empNo,
    };
  }
}

// Helper method to parse a list of DutyRequests
List<DutyRequest> dutyRequestFromJson(String str) => List<DutyRequest>.from(
  json.decode(str).map((x) => DutyRequest.fromJson(x)),
);

String dutyRequestToJson(List<DutyRequest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
