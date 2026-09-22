class Increment {
  String id;
  String type;
  String positionFrom;
  String positionTo;
  String department;
  String branch;
  String salaryFrom;
  String salaryTo;
  String details;
  String dateTo;
  String createdAt;
  Increment(
      {required this.id,
      required this.type,
      required this.positionFrom,
      required this.positionTo,
      required this.department,
      required this.branch,
      required this.salaryFrom,
      required this.salaryTo,
      required this.details,
      required this.dateTo,
      required this.createdAt});

  factory Increment.fromJson(Map<String, dynamic> json) {
    return Increment(
      id: json['id'].toString(),
      type: json['type'].toString(),
      positionFrom: json['position_from'].toString(),
      positionTo: json['position_to'].toString(),
      department: json['transfer_department'].toString(),
      branch: json['transfer_branch'].toString(),
      salaryFrom: json['salary_from'].toString(),
      salaryTo: json['salary_to'].toString(),
      details: json['detail'].toString(),
      dateTo: json['date_to'].toString(),
      createdAt: json['created_at'].toString(),
    );
  }
}
