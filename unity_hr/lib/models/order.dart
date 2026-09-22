class Order {
  String id;
  String type;
  String dateFrom;
  String dateTo;
  String detail;
  String createdAt;
  Order({
    required this.id,
    required this.type,
    required this.dateFrom,
    required this.dateTo,
    required this.detail,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      type: json['type'].toString(),
      dateFrom: json['date_from'].toString(),
      dateTo: json['date_to'].toString(),
      detail: json['detail'].toString(),
      createdAt: json['created_at'].toString(),
    );
  }
}
