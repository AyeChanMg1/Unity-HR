class HomeReport {
  MonthlyReport monthlyReport;
  DailyReport dailyReport;
  HomeReport({required this.monthlyReport, required this.dailyReport});
  factory HomeReport.fromJson(Map<String, dynamic> json) {
    return HomeReport(
      monthlyReport: MonthlyReport.fromJson(json['monthly_report']),
      dailyReport: DailyReport.fromJson(json['daily_report']),
    );
  }
}

class MonthlyReport {
  String name;
  String early;
  String late;
  String ot;
  MonthlyReport(
      {required this.name,
      required this.early,
      required this.late,
      required this.ot});

  factory MonthlyReport.fromJson(Map<String, dynamic> json) {
    return MonthlyReport(
      name: json['name'].toString(),
      early: json['early'].toString(),
      late: json['late'].toString(),
      ot: json['ot'].toString(),
    );
  }
}

class DailyReport {
  bool workingDay;
  String status;
  String description;
  Time time;
  Shift shift;
  bool isCheckedIn;
  bool isCheckOut;
  bool isArrived;
  bool isLate;

  DailyReport(
      {required this.workingDay,
        required this.status,
      required this.description,
      required this.time,
      required this.shift,
      required this.isCheckedIn,
      required this.isCheckOut,
      required this.isArrived,
      required this.isLate});

  factory DailyReport.fromJson(Map<String, dynamic> json) {
    return DailyReport(
      workingDay: json['working_day'] ?? false,
      status: json['status'].toString(),
      description: json['description'].toString(),
      time: Time.fromJson(json['time']),
      shift: Shift.fromJson(json['shift']),
      isCheckedIn: json['is_checked_in'] ?? false,
      isCheckOut: json['is_checked_out'] ?? false,
      isArrived: json['is_arrived'] ?? false,
      isLate: json['is_late'] ?? false,
    );
  }
}

class Time {
  String checkIn;
  String checkOut;
  Time({required this.checkIn, required this.checkOut});
  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      checkIn: json['check_in'] ?? "00:00:00",
      checkOut: json['check_out'] ?? "00:00:00",
    );
  }
}

class Shift {
  String from;
  String to;
  Shift({required this.from, required this.to});
  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      from: json['from'] ?? "09:00:00",
      to: json['to'] ?? "17:00:00",
    );
  }
}
