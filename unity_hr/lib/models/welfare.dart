class Welfare {
  String id;
  String title;
  String allowance;
  String descriprion;
  Welfare({
    required this.id,
    required this.title,
    required this.allowance,
    required this.descriprion,
  });

  factory Welfare.fromJson(Map<String, dynamic> json) {
    return Welfare(
      id: json['id'].toString(),
      title: json['title'].toString(),
      allowance: json['allowance'].toString(),
      descriprion: json['description'].toString(),
    );
  }
}
