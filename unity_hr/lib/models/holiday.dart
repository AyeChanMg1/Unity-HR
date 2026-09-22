class Holiday {
  String name;
  String branch;
  String department;
  String date;

  Holiday({
    required this.name,
    required this.branch,
    required this.department,
    required this.date,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      name: json['name'].toString(),
      branch: json['branch'].toString(),
      department: json['department'].toString(),
      date: json['date'].toString(),
    );
  }
}
