class LeaveType {
  String id;
  String title;
  String allowDay;
  String remainingDay;
  String description;
  String takenDay;

  LeaveType({
    required this.id,
    required this.title,
    required this.allowDay,
    required this.remainingDay,
    required this.description,
    required this.takenDay,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['id'].toString(),
      title: json['title'].toString(),
      allowDay: json['allow_days'].toString(),
      remainingDay: json['remaining_days'].toString(),
      description: json['description'].toString(),
      takenDay: json['taken_days'].toString(),
    );
  }
}
