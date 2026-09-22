class PaySlip {
  EmployeeDetail employee;
  Earning earning;
  Deduction deduction;
  String netSalary;
  Company company;

  PaySlip({
    required this.employee,
    required this.earning,
    required this.deduction,
    required this.netSalary,
    required this.company,
  });

  factory PaySlip.fromJson(Map<String, dynamic> json) {
    return PaySlip(
      employee: EmployeeDetail.fromJson(json['employee']),
      earning: Earning.fromJson(json['earnings']),
      deduction: Deduction.fromJson(json['deductions']),
      netSalary: json['net_salary'].toString(),
      company: Company.fromJson(json['company']),
    );
  }
}

class Earning {
  String basicSalary;
  String ot;
  String salaryCurrency;
  String salaryCurrencySymbol;

  Map allowance;
  Earning({
    required this.basicSalary,
    required this.ot,
    required this.salaryCurrency,
    required this.salaryCurrencySymbol,
    required this.allowance,
  });
  factory Earning.fromJson(Map<String, dynamic> json) {
    // Map allow = {};
    // if (json['allowances'] == null) {
    //   allow = {'Allowances': '0'};
    // } else {
    //   allow = json['allowances'];
    // }
    return Earning(
      basicSalary: json['basic_salary'].toString(),
      ot: json['ot'].toString(),
      allowance: json['allowances'] ?? {},
      salaryCurrency: json['salary_currency'].toString(),
      salaryCurrencySymbol: json['salary_currency_symbol'].toString(),
    );
  }
}

class Deduction {
  String absent;
  String earlyOut;
  String late;
  String unpaidLeave;
  String incomeTax;
  String ssb;
  Map extra;
  Deduction({
    required this.absent,
    required this.earlyOut,
    required this.late,
    required this.unpaidLeave,
    required this.incomeTax,
    required this.ssb,
    required this.extra,
  });

  factory Deduction.fromJson(Map<String, dynamic> json) {
    return Deduction(
      absent: json['absences'].toString(),
      earlyOut: json['early_out'].toString(),
      late: json['late'].toString(),
      unpaidLeave: json['leaves'].toString(),
      incomeTax: json['income_tax'].toString(),
      ssb: json['ssb'].toString(),
      extra: json['extra'] ?? {},
    );
  }
}

class EmployeeDetail {
  String empNo;
  String name;
  String position;
  String department;
  String branch;
  String company;
  String payPeriod;
  String payDate;

  EmployeeDetail({
    required this.empNo,
    required this.name,
    required this.position,
    required this.department,
    required this.branch,
    required this.company,
    required this.payPeriod,
    required this.payDate,
  });

  factory EmployeeDetail.fromJson(Map<String, dynamic> json) {
    return EmployeeDetail(
      empNo: json['emp_no'].toString(),
      name: json['name'].toString(),
      position: json['position'].toString(),
      department: json['department'].toString(),
      branch: json['branch'].toString(),
      company: json['company'].toString(),
      payPeriod: json['pay_period'].toString(),
      payDate: json['pay_date'].toString(),
    );
  }
}

class Company {
  String name;
  String logo;
  String icon;
  String address;
  String phone;
  String email;

  Company({
    required this.name,
    required this.logo,
    required this.icon,
    required this.address,
    required this.phone,
    required this.email,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      logo: json['logo'],
      icon: json['icon'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}
