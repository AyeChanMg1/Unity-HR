class NotificationModel {
  String id;
  String title;
  String description;
  Sender sender;
  String date;
  String isRead;
  String refID;
  String refType;
  String isManageable;
  String type;
  List<Duty>? duty;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.sender,
    required this.date,
    required this.isRead,
    required this.refID,
    required this.refType,
    required this.isManageable,
    required this.type,
    this.duty,
  });
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    Sender sender = Sender(name: '', image: '');

    if (json['sender'] != null && json['sender'] != '') {
      sender = Sender.fromJson(json['sender']);
    } else {
      sender = Sender(name: '', image: '');
    }

    List<Duty>? duties;

    if (json['duty'] is List) {
      duties = (json['duty'] as List).map((e) => Duty.fromJson(e)).toList();
    } else {
      duties = null;
    }

    return NotificationModel(
      id: json['id'].toString(),
      title: json['title'].toString(),
      description: json['description'].toString(),
      sender: sender,
      date: json['created_at'].toString(),
      isRead: json['is_read'].toString(),
      refID: json['ref_id'].toString(),
      refType: json['ref_type'].toString(),
      isManageable: json['is_management_required'].toString(),
      type: json['type'].toString(),
      duty: duties,
    );
  }
}

class Sender {
  String name;
  String image;
  Sender({required this.name, required this.image});
  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      name: json['name'].toString(),
      image: json['image'].toString(),
    );
  }
}

class Duty {
  int id;
  String dutyId;
  String name;
  String description;
  String jobDate;
  String priority;
  String empName;
  String status;

  Duty({
    required this.id,
    required this.dutyId,
    required this.name,
    required this.description,
    required this.jobDate,
    required this.priority,
    required this.empName,
    required this.status,
  });

  factory Duty.fromJson(Map<String, dynamic> json) {
    return Duty(
      id: json['id'] ?? 0,
      dutyId: json['duty_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      jobDate: json['job_date']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      empName: json['employee_name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}
