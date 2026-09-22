class UserInfo {
  String employeeID;
  String name;
  String email;
  String userName;
  Branch branch;
  Department department;
  String gender;
  String image;
  String position;
  String joinedDate;
  String dob;
  String phone;
  String address;
  String employeeType;
  WorkSchedule? workSchedule;

  UserInfo({
    required this.employeeID,
    required this.name,
    required this.email,
    required this.userName,
    required this.branch,
    required this.department,
    required this.gender,
    required this.image,
    required this.position,
    required this.joinedDate,
    required this.dob,
    required this.phone,
    required this.address,
    required this.employeeType,
    this.workSchedule,
  });

  @override
  String toString() {
    return 'UserInfo{workSchedule: $workSchedule}';
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    Branch branch = Branch(id: '', branchName: '');
    Department department = Department(id: '', departmentName: '');
    if (json['branch'] != null && json['branch'] != '') {
      branch = Branch.fromJson(json['branch']);
    }
    if (json['department'] != null && json['department'] != '') {
      department = Department.fromJson(json['department']);
    }
    return UserInfo(
      employeeID: json['employee_id'].toString(),
      name: json['name'].toString(),
      email: json['email'].toString(),
      userName: json['username'].toString(),
      branch: branch,
      department: department,
      gender: json['gender'].toString(),
      image: json['image'].toString(),
      position: json['position'].toString(),
      joinedDate: json['joined_date'].toString(),
      dob: json['date_of_birth'] ?? "",
      phone: json['phone'].toString(),
      address: json['address'].toString(),
      employeeType: json['employee_type'].toString(),
      workSchedule: WorkSchedule(
        shiftTitle: '',
        workingHourFrom: '22:14:00',
        workingHourTo: '21:17:00',
        halfTime: '',
      ),
      // workSchedule: json['work_schedule'] == "null" ||  json['work_schedule'] == null || json['work_schedule'] == ''? WorkSchedule(shiftTitle: '',workingHourFrom: '09:00:00',workingHourTo: '17:00:00',halfTime: '') : WorkSchedule.fromJson(json['work_schedule'])
    );
  }
}

class Branch {
  String id;
  String branchName;

  Branch({required this.id, required this.branchName});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'].toString(),
      branchName: json['name'].toString(),
    );
  }
}

class Department {
  String id;
  String departmentName;

  Department({required this.id, required this.departmentName});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'].toString(),
      departmentName: json['name'].toString(),
    );
  }
}

class WorkSchedule {
  String? shiftTitle;
  String? workingHourFrom;
  String? workingHourTo;
  String? halfTime;

  WorkSchedule({
    this.shiftTitle,
    this.workingHourFrom,
    this.workingHourTo,
    this.halfTime,
  });

  factory WorkSchedule.fromJson(Map<String, dynamic> json) {
    return WorkSchedule(
      shiftTitle: json['shift_title'],
      workingHourFrom: json['working_hour_from'],
      workingHourTo: json['working_hour_to'],
      halfTime: json['half_time'],
    );
  }

  @override
  String toString() {
    return 'WorkSchedule{shiftTitle: $shiftTitle, workingHourFrom: $workingHourFrom, workingHourTo: $workingHourTo, halfTime: $halfTime}';
  }
}
