import 'package:unity_hr/models/reform_person.dart';
import 'package:unity_hr/models/request_person.dart';

class EmployeeLeaveRequestDetail {
  String id;
  String employeeId;
  String name;
  String position;
  String department;
  String image;
  String leaveType;
  String leaveTypeID;
  String dateFrom;
  String dateTo;
  String status;
  String duration;
  String reason;
  String remark;
  List<RequestPerson> requestpersonlist;
  List<ReformPerson> informToPerson;
  List<LeaveImages>? leaveImages;
  EmployeeLeaveRequestDetail({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.position,
    required this.department,
    required this.image,
    required this.leaveType,
    required this.leaveTypeID,
    required this.dateFrom,
    required this.dateTo,
    required this.status,
    required this.duration,
    required this.reason,
    required this.remark,
    required this.requestpersonlist,
    required this.informToPerson,
    this.leaveImages,
  });

  factory EmployeeLeaveRequestDetail.fromJson(Map<String, dynamic> json) {
    return EmployeeLeaveRequestDetail(
      id: json['id'].toString(),
      employeeId: json['employee_id'].toString(),
      name: json['employee_name'].toString(),
      position: json['position'].toString(),
      department: json['department'].toString(),
      image: json['image_url'].toString(),
      leaveType: json['leave_type'].toString(),
      leaveTypeID: json['leave_type_id'] ?? "",
      dateFrom: json['date_from'].toString(),
      dateTo: json['date_to'].toString(),
      status: json['status'].toString(),
      duration: json['duration'].toString(),
      reason: json['reason'].toString(),
      remark: json['remark'].toString(),
      requestpersonlist: List<RequestPerson>.from(
        json["request_to_persons"].map((x) => RequestPerson.fromJson(x)),
      ),
      informToPerson: List<ReformPerson>.from(
        json["inform_to_persons"].map((x) => ReformPerson.fromJson(x)),
      ),
      leaveImages: json['leave_request_images'] == null
          ? []
          : List<LeaveImages>.from(
              json["leave_request_images"].map((x) => LeaveImages.fromJson(x)),
            ),
    );
  }
}

class LeaveImages {
  String? id;
  String? url;

  LeaveImages({this.id, this.url});

  factory LeaveImages.fromJson(Map<String, dynamic> json) {
    return LeaveImages(id: json['id'], url: json['url']);
  }
}
