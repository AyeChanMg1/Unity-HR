class ResignRequest {
  String id;
  String name;
  String position;
  String date;
  String subject;
  String status;
  String image;
  bool isManageable;
  ResignRequest({
    required this.id,
    required this.name,
    required this.position,
    required this.date,
    required this.status,
    required this.subject,
    required this.image,
    required this.isManageable,
  });

  factory ResignRequest.fromJson(Map<String, dynamic> json) {
    return ResignRequest(
      id: json['id'].toString(),
      name: json['employee_name'].toString(),
      position: json['position'].toString(),
      date: json['date'].toString(),
      status: json['status'].toString(),
      subject: json['subject'].toString(),
      image: json['profile_image'].toString(),
      isManageable: json['is_manageable'] ?? false,
    );
  }
}
