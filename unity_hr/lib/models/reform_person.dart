class ReformPerson {
  String id;
  String employeeID;
  String name;
  String employeeNo;
  String position;
  String image;

  ReformPerson({
    required this.id,
    required this.employeeID,
    required this.name,
    required this.employeeNo,
    required this.position,
    required this.image,
  });

  factory ReformPerson.fromJson(Map<String, dynamic> json) {
    return ReformPerson(
      id: json['id'].toString(),
      employeeID: json['employee_id'].toString(),
      name: json['name'].toString(),
      employeeNo: json['employee_no'].toString(),
      position: json['position'].toString(),
      image: json['profile_image'].toString(),
    );
  }
}
