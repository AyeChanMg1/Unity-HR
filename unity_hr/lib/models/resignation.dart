import 'package:unity_hr/models/reform_person.dart';
import 'package:unity_hr/models/request_person.dart';
import 'package:unity_hr/models/resign_images.dart';

class Resignation {
  String id;
  String empName;
  String position;
  String subject;
  String date;
  String status;
  String? url;
  String? reason;
  List<ResignImages>? resignImages;
  List<ReformPerson>? informPerson;
  List<RequestPerson>? requestPerson;
  Resignation({
    required this.id,
    required this.empName,
    required this.position,
    required this.subject,
    required this.date,
    required this.status,
    this.url,
    this.resignImages,
    this.informPerson,
    this.requestPerson,
    this.reason,
  });

  factory Resignation.fromJson(Map<String, dynamic> json) {
    return Resignation(
      id: json['id'].toString(),
      empName: json['employee_name'].toString(),
      position: json['position'].toString(),
      subject: json['subject'].toString(),
      date: json['date'].toString(),
      status: json['status'].toString(),
      url: json['url'],
      reason: json['reason'],
      resignImages: List<ResignImages>.from(
        json["resign_request_images"].map((x) => ResignImages.fromJson(x)),
      ),
      informPerson: List<ReformPerson>.from(
        json["inform_to"].map((x) => ReformPerson.fromJson(x)),
      ),
      requestPerson: List<RequestPerson>.from(
        json["request_to"].map((x) => RequestPerson.fromJson(x)),
      ),
    );
  }
}
