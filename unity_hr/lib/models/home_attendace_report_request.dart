class DailyAttendanceReport {
  String arrivedEmployeeCount;
  String notArrivedEmployeeCount;
  String lateEmployeeCount;
  String leaveEmployeeCount;
  List<TodayArrivedReport> todayArrivedList;
  List<TodayLateReport> todayLateList;
  List<TodayLeaveReport> todayLeaveList;

  DailyAttendanceReport({
    required this.arrivedEmployeeCount,
    required this.notArrivedEmployeeCount,
    required this.lateEmployeeCount,
    required this.leaveEmployeeCount,
    required this.todayArrivedList,
    required this.todayLateList,
    required this.todayLeaveList,
  });

  factory DailyAttendanceReport.fromJson(Map<String, dynamic> json) {
    List<dynamic> todayArrivedJsonList = json['today_arrived_list'];

    List<TodayArrivedReport> todayArrivedList =
        todayArrivedJsonList.map((item) {
      return TodayArrivedReport.fromJson(item);
    }).toList();

    List<dynamic> todayLateJsonList = json['today_late_list'];

    List<TodayLateReport> todayLateList = todayLateJsonList.map((item) {
      return TodayLateReport.fromJson(item);
    }).toList();

    List<dynamic> todayLeaveJsonList = json['today_leave_list'];

    List<TodayLeaveReport> todayLeaveList = todayLeaveJsonList.map((item) {
      return TodayLeaveReport.fromJson(item);
    }).toList();

    return DailyAttendanceReport(
      arrivedEmployeeCount: json['arrived_employees'].toString(),
      notArrivedEmployeeCount:
          json['not_arrived_employees_count']?.toString() ?? '0',
      lateEmployeeCount: json['late_employees_count'].toString(),
      leaveEmployeeCount: json['leave_employees_count'].toString(),
      todayArrivedList: todayArrivedList,
      todayLateList: todayLateList,
      todayLeaveList: todayLeaveList,
    );
  }
}

class TodayLeaveReport {
  String name;
  String position;
  String status;
  String department;
  String leaveFrom;
  String leaveTo;
  String leaveDuration;
  String leaveType;
  String leaveReason;

  TodayLeaveReport(
      {required this.name,
      required this.position,
      required this.status,
      required this.department,
      required this.leaveFrom,
      required this.leaveTo,
      required this.leaveDuration,
      required this.leaveType,
      required this.leaveReason});

  factory TodayLeaveReport.fromJson(Map<String, dynamic> json) {
    return TodayLeaveReport(
      name: json['name'].toString(),
      position: json['position'].toString(),
      status: json['status'].toString(),
      department: json['department'].toString(),
      leaveFrom: json['leave_from'].toString(),
      leaveTo: json['leave_to'].toString(),
      leaveDuration: json['leave_duration'].toString(),
      leaveType: json['leave_type'].toString(),
      leaveReason: json['leave_reason'].toString(),
    );
  }
}

class TodayArrivedReport {
  String name;
  String position;
  String status;
  String department;
  String date;
  String checkIn;
  String checkOut;

  TodayArrivedReport(
      {required this.name,
      required this.position,
      required this.status,
      required this.department,
      required this.date,
      required this.checkIn,
      required this.checkOut});

  factory TodayArrivedReport.fromJson(Map<String, dynamic> json) {
    return TodayArrivedReport(
      name: json['name'].toString(),
      position: json['position'].toString(),
      status: json['status'].toString(),
      department: json['department'].toString(),
      date: json['date'].toString(),
      checkIn: json['check_in'].toString(),
      checkOut: json['check_out'].toString(),
    );
  }
}

class TodayLateReport {
  String name;
  String position;
  String status;
  String department;
  String date;
  String checkIn;
  String late;
  String lateReason;

  TodayLateReport(
      {required this.name,
      required this.position,
      required this.status,
      required this.department,
      required this.date,
      required this.checkIn,
      required this.late,
      required this.lateReason});

  factory TodayLateReport.fromJson(Map<String, dynamic> json) {
    return TodayLateReport(
      name: json['name'].toString(),
      position: json['position'].toString(),
      status: json['status'].toString(),
      department: json['department'].toString(),
      date: json['date'].toString(),
      checkIn: json['check_in'].toString(),
      late: json['late'].toString(),
      lateReason: json['late_reason'] ?? '--',
    );
  }
}

class CheckInRequestReport {
  String checkInCount;

  CheckInRequestReport({required this.checkInCount});

  factory CheckInRequestReport.fromJson(Map<String, dynamic> json) {
    return CheckInRequestReport(
      checkInCount: json['check_in_requests_count'].toString(),
    );
  }
}

class CheckOutRequestReport {
  String checkOutCount;

  CheckOutRequestReport({required this.checkOutCount});

  factory CheckOutRequestReport.fromJson(Map<String, dynamic> json) {
    return CheckOutRequestReport(
      checkOutCount: json['check_out_requests_count'].toString(),
    );
  }
}

class LeaveRequestReport {
  String leaveCount;

  LeaveRequestReport({required this.leaveCount});

  factory LeaveRequestReport.fromJson(Map<String, dynamic> json) {
    return LeaveRequestReport(
      leaveCount: json['leave_requests_count'].toString(),
    );
  }
}

class OTRequestReport {
  String otCount;

  OTRequestReport({required this.otCount});

  factory OTRequestReport.fromJson(Map<String, dynamic> json) {
    return OTRequestReport(
      otCount: json['overtime_requests_count'].toString(),
    );
  }
}

class ResignRequestReport {
  String resignCount;

  ResignRequestReport({required this.resignCount});

  factory ResignRequestReport.fromJson(Map<String, dynamic> json) {
    return ResignRequestReport(
      resignCount: json['resignation_requests_count'].toString(),
    );
  }
}

class OutpassRequestReport {
  String outpassCount;

  OutpassRequestReport({required this.outpassCount});

  factory OutpassRequestReport.fromJson(Map<String, dynamic> json) {
    return OutpassRequestReport(
      outpassCount: json['out_pass_requests_count'].toString(),
    );
  }
}

class DutyRequestReport {
  String dutyCount;
  String doneTasks;

  DutyRequestReport({
    required this.dutyCount,
    required this.doneTasks,
  });

  factory DutyRequestReport.fromJson(Map<String, dynamic> json) {
    return DutyRequestReport(
      dutyCount: json['duty_requests_count']?.toString() ?? "0",
      doneTasks: json['done_tasks']?.toString() ?? "0",
    );
  }
}
