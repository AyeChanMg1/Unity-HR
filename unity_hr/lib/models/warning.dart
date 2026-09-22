class Warning {
  String id;
  String title;
  String warningTo;
  String description;
  String times;
  String createdAt;
  Warning({
    required this.id,
    required this.title,
    required this.warningTo,
    required this.description,
    required this.times,
    required this.createdAt,
  });

  factory Warning.fromJson(Map<String, dynamic> json) {
    return Warning(
      id: json['id'].toString(),
      title: json['title'].toString(),
      warningTo: json['warning_to'].toString(),
      times: json['times'].toString(),
      description: json['description'].toString(),
      createdAt: json['created_at'].toString(),
    );
  }
}
