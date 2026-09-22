class ViewAttendance {
  String id;
  String date;
  String checkin;
  String checkout;
  String approvalStatus;
  String checkoutStatus;
  String checkinDescription;
  String checkoutDescription;
  String earlyOut;
  String late;
  String workingHr;

  ViewAttendance({
    required this.id,
    required this.date,
    required this.checkin,
    required this.checkout,
    required this.approvalStatus,
    required this.checkoutStatus,
    required this.checkinDescription,
    required this.checkoutDescription,
    required this.earlyOut,
    required this.late,
    required this.workingHr,
  });

  factory ViewAttendance.fromJson(Map<String, dynamic> json) {
    return ViewAttendance(
      id: json['id'].toString(),
      date: json['date'].toString(),
      checkin: json['check_in'].toString(),
      checkout: json['check_out'].toString(),
      approvalStatus: json['approval_status'].toString(),
      checkoutStatus: json['check_out_approval_status'].toString(),
      checkinDescription: json['check_in_description'].toString(),
      checkoutDescription: json['check_out_description'].toString(),
      earlyOut: json['early_out'].toString(),
      late: json['late'].toString(),
      workingHr: json['working_hour'].toString(),
    );
  }
}
