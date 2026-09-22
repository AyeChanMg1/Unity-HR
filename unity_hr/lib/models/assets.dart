class Asset {
  String name;
  String date;
  String description;

  Asset({required this.name, required this.date, required this.description});

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      name: json['name'].toString(),
      date: json['date'].toString(),
      description: json['description'].toString(),
    );
  }
}
