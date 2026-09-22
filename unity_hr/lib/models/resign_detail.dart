import 'package:unity_hr/models/resign_images.dart';

class ResignDetail {
  String id;
  String name;
  String image;
  String position;
  String department;
  String subject;
  String date;
  String reason;
  String status;
  String remark;
  List<ResignImages>? resignImages;

  ResignDetail({
    required this.id,
    required this.name,
    required this.image,
    required this.position,
    required this.department,
    required this.date,
    required this.reason,
    required this.status,
    required this.remark,
    required this.subject,
    this.resignImages,
  });

  factory ResignDetail.fromJson(Map<String, dynamic> json) {
    return ResignDetail(
      id: json['id'].toString(),
      name: json['employee_name'].toString(),
      image: json['image_url'].toString(),
      position: json['position'].toString(),
      department: json['department'].toString(),
      date: json['date'].toString(),
      reason: json['reason'].toString(),
      status: json['status'].toString(),
      remark: json['remark'].toString(),
      subject: json['subject'].toString(),
      resignImages: List<ResignImages>.from(
        json["resign_request_images"].map((x) => ResignImages.fromJson(x)),
      ),
    );
  }
}
