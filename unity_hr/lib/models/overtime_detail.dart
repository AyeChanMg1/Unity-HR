class OverTimeDetails {
  String id;
  String name;
  String image;
  String timeFrom;
  String timeTo;
  String position;
  String department;
  String date;
  String status;
  String reason;
  String remark;
  String siteId;
  String workOrderId;
  OverTimeDetails({
    required this.id,
    required this.name,
    required this.image,
    required this.timeFrom,
    required this.timeTo,
    required this.position,
    required this.department,
    required this.date,
    required this.status,
    required this.reason,
    required this.remark,
    required this.siteId,
    required this.workOrderId,
  });

  factory OverTimeDetails.fromJson(Map<String, dynamic> json) {
    return OverTimeDetails(
        id: json['id'].toString(),
        name: json['employee_name'].toString(),
        image: json['image_url'].toString(),
        timeFrom: json['time_from'].toString(),
        timeTo: json['time_to'].toString(),
        position: json['position'].toString(),
        department: json['department'].toString(),
        date: json['date'].toString(),
        status: json['status'].toString(),
        reason: json['reason'].toString(),
        remark: json['remark'].toString(),
        siteId: json['site_id'] ?? "",
      workOrderId: json['work_order_id'] ?? "",
    );
  }
}
