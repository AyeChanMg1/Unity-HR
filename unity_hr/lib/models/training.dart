class Training {
  String id;
  String title;
  String details;
  String trainer;
  String dateFrom;
  String dateTo;
  String createdAt;
  Training({
    required this.id,
    required this.title,
    required this.details,
    required this.trainer,
    required this.dateFrom,
    required this.dateTo,
    required this.createdAt,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['id'].toString(),
      title: json['title'].toString(),
      details: json['detail'].toString(),
      trainer: json['trainer'].toString(),
      dateFrom: json['date_from'].toString(),
      dateTo: json['date_to'].toString(),
      createdAt: json['created_at'].toString(),
    );
  }
}
