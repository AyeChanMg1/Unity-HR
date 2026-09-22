class ResignLastRequest {
  String id;
  String name;
  String date;
  String status;
  ResignLastRequest(
      {required this.id,
      required this.name,
      required this.date,
      required this.status});

  factory ResignLastRequest.formJson(Map<String, dynamic> json) {
    return ResignLastRequest(
        id: json['id'].toString(),
        name: json['employee_name'].toString(),
        date: json['date'].toString(),
        status: json['status'].toString());
  }
}
