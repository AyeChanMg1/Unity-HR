class CheckIn {
  String id;
  String date;
  String checkIn;
  String approvalStatus;
  String name;
  double latitude;
  double longitude;
  String position;
  String department;
  String description;
  String remark;

  CheckIn({
    required this.id,
    required this.date,
    required this.checkIn,
    required this.approvalStatus,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.position,
    required this.department,
    required this.description,
    required this.remark,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'].toString(),
      date: json['date'].toString(),
      checkIn: json['check_in'].toString(),
      approvalStatus: json['approval_status'].toString(),
      name: json['name'].toString(),
      latitude: json['latitude'],
      longitude: json['longitude'],
      position: json['position'].toString(),
      department: json['department'].toString(),
      description: json['description'].toString(),
      remark: json['remark'].toString(),
    );
  }
}

class CheckOut {
  String id;
  String date;
  String checkout;
  String approvalStatus;
  String name;

  double latitude;
  double longitude;
  String position;
  String department;
  String description;
  String remark;

  CheckOut({
    required this.id,
    required this.date,
    required this.checkout,
    required this.approvalStatus,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.position,
    required this.department,
    required this.description,
    required this.remark,
  });

  factory CheckOut.fromJson(Map<String, dynamic> json) {
    return CheckOut(
      id: json['id'].toString(),
      date: json['date'].toString(),
      checkout: json['check_out'].toString(),
      approvalStatus: json['approval_status'].toString(),
      name: json['name'].toString(),
      latitude: json['latitude'],
      longitude: json['longitude'],
      position: json['position'].toString(),
      department: json['department'].toString(),
      description: json['description'].toString(),
      remark: json['remark'].toString(),
    );
  }
}
