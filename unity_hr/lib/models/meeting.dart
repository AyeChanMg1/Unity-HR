class Meeting {
  String id;
  String title;
  String date;
  String description;
  String timeFrom;
  String timeTo;
  String place;
  Meeting(
      {required this.id,
      required this.title,
      required this.date,
      required this.description,
      required this.timeFrom,
      required this.timeTo,
      required this.place});

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'].toString(),
      title: json['title'].toString(),
      date: json['date'].toString(),
      description: json['description'].toString(),
      timeFrom: json['time_from'].toString(),
      timeTo: json['time_to'].toString(),
      place: json['place'].toString(),
    );
  }
}
