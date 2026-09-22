class Transfer {
  String id;
  String type;
  String transferBranch;
  String transferDepartment;
  String dateFrom;
  String dateTo;
  String details;
  String createdAt;

  Transfer({
    required this.id,
    required this.type,
    required this.transferBranch,
    required this.transferDepartment,
    required this.dateFrom,
    required this.dateTo,
    required this.details,
    required this.createdAt,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'].toString(),
      type: json['type'].toString(),
      transferBranch: json['transfer_branch'].toString(),
      transferDepartment: json['transfer_department'].toString(),
      dateFrom: json['date_from'].toString(),
      dateTo: json['date_to'].toString(),
      details: json['detail'].toString(),
      createdAt: json['created_at'].toString(),
    );
  }
}
