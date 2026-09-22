class OutPass {
  String id;
  String employeeName;
  String date;
  String dateFrom;
  String dateTo;
  String timeFrom;
  String timeTo;
  String status;
  String formType;
  String? reason;
  String? remark;
  List<Expense> expense;
  List<String>? requestToPerson;
  List<String>? requestPersonIds;
  List<String>? informPersonIds;
  OutPass({
    required this.id,
    required this.employeeName,
    required this.date,
    required this.dateFrom,
    required this.dateTo,
    required this.timeFrom,
    required this.timeTo,
    required this.status,
    required this.formType,
    this.reason,
    this.remark,
    required this.expense,
    this.requestToPerson,
    this.requestPersonIds,
    this.informPersonIds,
  });

  @override
  String toString() {
    return 'OutPass{id: $id, employeeName: $employeeName, date: $date, dateFrom: $dateFrom, dateTo: $dateTo, timeFrom: $timeFrom, timeTo: $timeTo, status: $status, formType: $formType, reason: $reason, remark: $remark, expense: $expense, resuestTo : $requestToPerson, requestPersonIds : $requestPersonIds, informPersonIds : $informPersonIds}';
  }

  factory OutPass.fromJson(Map<String, dynamic> json) {
    return OutPass(
      id: json['id'].toString(),
      employeeName: json['employee_name'].toString(),
      date: json['date'].toString(),
      dateFrom: json['date_from'] ?? "",
      dateTo: json['date_to'] ?? "",
      timeFrom: json['time_from'].toString(),
      timeTo: json['time_to'].toString(),
      status: json['status'].toString(),
      formType: json['form_type'].toString(),
      reason: json['reason'],
      remark: json['remark'],
      expense: json['expense'] != null
          ? (json['expense'] as List).map((e) => Expense.fromJson(e)).toList()
          : [],
      requestToPerson: json['request_to'] != null
          ? List<String>.from(json['request_to'])
          : [],
      requestPersonIds: json['request_to_ids'] != null
          ? List<String>.from(json['request_to_ids'])
          : [],
      informPersonIds: json['inform_to_ids'] != null
          ? List<String>.from(json['inform_to_ids'])
          : [],
    );
  }
}

class Expense {
  String name;
  int cost;

  Expense({required this.name, required this.cost});

  @override
  String toString() {
    return 'Expense{name: $name, cost: $cost}';
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      name: json['name'] ?? "",
      cost: int.tryParse(json['cost'].toString()) ?? 0,
    );
  }
}

class OutpassRequestModel {
  final String? id;
  final String? employeeId;
  final String? date;
  final String? dateFrom;
  final String? dateTo;
  final String? timeFrom;
  final String? timeTo;
  final String? reason;
  final String? remark;
  final String? status;
  final String? formType;
  final List<Expense>? expense;
  final dynamic approvedBy;
  final int? createdBy;
  final dynamic updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;
  final Employee? employee;

  OutpassRequestModel({
    this.id,
    this.employeeId,
    this.date,
    this.dateFrom,
    this.dateTo,
    this.timeFrom,
    this.timeTo,
    this.reason,
    this.remark,
    this.status,
    this.formType,
    this.expense,
    this.approvedBy,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.employee,
  });

  factory OutpassRequestModel.fromJson(Map<String, dynamic> json) {
    return OutpassRequestModel(
      id: json['id'],
      employeeId: json['employee_id'],
      date: json['date'],
      dateFrom: json['date_from'],
      dateTo: json['date_to'],
      timeFrom: json['time_from'],
      timeTo: json['time_to'],
      reason: json['reason'],
      remark: json['remark'],
      status: json['status'],
      formType: json['form_type'],
      expense: (json["expense"] == [] || json["expense"] == null)
          ? []
          : (json["expense"] as List<dynamic>)
                .map((e) => Expense.fromJson(e))
                .toList(),
      approvedBy: json['approved_by'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      employee: Employee.fromJson(json['employee']),
    );
  }
}

class Employee {
  final String id;
  final String name;
  final String email;
  final String employeeNo;
  final String phone;
  final String gender;
  final String maritalStatus;
  final String nationality;
  final String nrc;
  final String currentAddress;
  final String permanentAddress;
  final String dateOfBirth;
  final String joinDate;
  final String employeeType;
  final String employmentType;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.employeeNo,
    required this.phone,
    required this.gender,
    required this.maritalStatus,
    required this.nationality,
    required this.nrc,
    required this.currentAddress,
    required this.permanentAddress,
    required this.dateOfBirth,
    required this.joinDate,
    required this.employeeType,
    required this.employmentType,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      employeeNo: json['employee_no'] ?? "",
      phone: json['phone'] ?? "",
      gender: json['gender'] ?? "",
      maritalStatus: json['marital_status'] ?? "",
      nationality: json['nationality'] ?? "",
      nrc: json['nrc'] ?? "",
      currentAddress: json['current_address'] ?? "",
      permanentAddress: json['permanent_address'] ?? "",
      dateOfBirth: json['date_of_birth'] ?? "",
      joinDate: json['join_date'] ?? "",
      employeeType: json['employee_type'] ?? "",
      employmentType: json['employment_type'] ?? "",
    );
  }
}
