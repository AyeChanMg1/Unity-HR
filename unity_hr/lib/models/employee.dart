class Employee {
  String id;
  String name;
  String image;
  String email;
  String phone;
  String department;
  String position;
  String employeeNo;
  String dob;
  String gender;
  String address;
  String joinDate;

  Employee({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
    required this.phone,
    required this.department,
    required this.position,
    required this.employeeNo,
    required this.dob,
    required this.gender,
    required this.address,
    required this.joinDate,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'].toString(),
      name: json['name'].toString(),
      image: json['profile_image'].toString(),
      email: json['email'].toString(),
      phone: json['phone'].toString(),
      department: json['department'].toString(),
      position: json['position'].toString(),
      employeeNo: json['employee_no'].toString(),
      dob: json['dob'].toString(),
      gender: json['gender'].toString(),
      address: json['address'].toString(),
      joinDate: json['join_date'].toString(),
    );
  }
}
