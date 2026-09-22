class Company {
  String name;
  String domain;
  Company({required this.name, required this.domain});

  factory Company.formJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'].toString(),
      domain: json['domain'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'domain': domain};
  }
}
