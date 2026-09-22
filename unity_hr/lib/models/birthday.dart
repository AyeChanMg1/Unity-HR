class Birthday {
  final String id;
  final String name;
  final String date;
  final String title;
  final String branch;
  final String department;
  final String position;

  Birthday({
    required this.id,
    required this.name,
    required this.date,
    required this.title,
    required this.branch,
    required this.department,
    required this.position,
  });

  factory Birthday.fromJson(Map<String, dynamic> json) {
    return Birthday(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      title: json['title'] ?? '',
      branch: json['branch'] ?? '',
      department: json['department'] ?? '',
      position: json['position'] ?? '',
    );
  }
}
