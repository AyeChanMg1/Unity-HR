class Promotion {
  String id;
  String type;
  String positionFrom;
  String positionTo;
  String dateFrom;
  String dateTo;
  String details;
  String createdAt;

  Promotion(
      {
        required this.id,
      required this.type,
      required this.positionFrom,
      required this.positionTo,
      required this.dateFrom,
      required this.dateTo,
      required this.details,
      required this.createdAt});

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'].toString(),
      type: json['type'].toString(),
      positionFrom: json['position_from'].toString(),
      positionTo: json['position_to'].toString(),
      dateFrom: json['date_from'].toString(),
      dateTo: json['date_to'].toString(),
      details: json['detail'].toString(),
      createdAt: json['created_at'].toString(),
    );
  }
}
