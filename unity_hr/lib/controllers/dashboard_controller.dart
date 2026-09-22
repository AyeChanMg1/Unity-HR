import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/attendance_model.dart';
import 'package:unity_hr/models/birthday.dart';
import 'package:unity_hr/models/holiday.dart';
import 'package:unity_hr/models/home_attendace_report_request.dart';
import 'package:unity_hr/models/home_report.dart';

class DashboardController extends GetxController {
  bool isLoading = false;
  bool isHoliday = false;
  HomeReport? homeReport;
  DailyAttendanceReport? dailyAttendanceReport;
  CheckInRequestReport? checkInRequestReport;
  CheckOutRequestReport? checkOutRequestReport;
  LeaveRequestReport? leaveRequestReport;
  OTRequestReport? otRequestReport;
  ResignRequestReport? resignRequestReport;
  OutpassRequestReport? outpassRequestReport;
  DutyRequestReport? dutyRequestReport;
  List<Holiday> holidayList = [];
  List<Holiday> holidayHome = [];
  double linearValue = 0.0;

  bool isBirthday = false;
  bool isWorkingAnniversary = false;
  List<Birthday> birthdayList = [];
  List<Birthday> birthdayHome = [];
  List<Birthday> workingAnniversaryList = [];
  List<Birthday> workingAnniversaryHome = [];

  List<Attendance> attendanceList = [
    Attendance(
      id: '1',
      icon: Icons.location_on_outlined,
      name: "Arrived",
      count: "4",
      color: color1,
    ),
    Attendance(
      id: '2',
      icon: Icons.location_off_outlined,
      name: "Not Arrived",
      count: "4",
      color: Colors.lightBlue,
    ),
    Attendance(
      id: '3',
      icon: Icons.access_time_sharp,
      name: "Late",
      count: "4",
      color: Colors.amber,
    ),
    Attendance(
      id: '4',
      icon: Icons.person_add_alt_outlined,
      name: "Leave",
      count: "0",
      color: Colors.red,
    ),
  ];

  List<Request> requestList = [
    Request(
      id: '1',
      title: 'Check In Requests',
      total: '20',
      color: color1,
      icon: Icons.move_to_inbox_rounded,
    ),
    Request(
      id: '2',
      title: 'Check Out Requests',
      total: '5',
      color: Colors.amber,
      icon: Icons.upload_rounded,
    ),
    Request(
      id: '3',
      title: 'Leave Requests',
      total: '3',
      color: Colors.red,
      icon: Icons.timer_outlined,
    ),
    Request(
      id: '4',
      title: 'OT Requests',
      total: '10',
      color: Colors.blue,
      icon: Icons.timelapse_outlined,
    ),
    Request(
      id: '5',
      title: 'Resign Requests',
      total: '1',
      color: Colors.black,
      icon: Icons.output_outlined,
    ),
    Request(
      id: '6',
      title: 'Out Pass Requests',
      total: '1',
      color: Colors.orange,
      icon: Icons.time_to_leave,
    ),
    Request(
      id: '7',
      title: 'Duty Requests',
      total: '1',
      color: Colors.lightBlueAccent,
      icon: Icons.workspaces_outlined,
    ),
  ];

  GlobalKey key = GlobalKey();
  double checkIn = 0.0;
  double checkOut = 0.0;
  String checkInTime = "08:00:00";
  String checkOutTime = "18:00:00";
  String shiftTime = "";
  String shiftTo = "";
  DateTime arrivedTime = DateTime.now();
  DateTime leaveTime = DateTime.now();

  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  void updateWorkTimesFromUserInfo() {
    final today = DateTime.now();

    final partsStartTime = userInfo.workSchedule?.workingHourFrom
        ?.split(':')
        .map(int.parse)
        .toList();
    final partsEndTime = userInfo.workSchedule?.workingHourTo
        ?.split(':')
        .map(int.parse)
        .toList();

    if (partsStartTime != null && partsStartTime.length == 3) {
      startTime = DateTime(
        today.year,
        today.month,
        today.day,
        partsStartTime[0],
        partsStartTime[1],
        partsStartTime[2],
      );

      // The checkInTime string is used for display/range.
      // It's adjusted to show 1 hour before the scheduled start.
      final adjustedCheckInTime = DateTime(
        today.year,
        today.month,
        today.day,
        partsStartTime[0],
        partsStartTime[1],
        partsStartTime[2],
      ).subtract(const Duration(hours: 1));

      checkInTime =
          "${adjustedCheckInTime.hour.toString().padLeft(2, '0')}:${adjustedCheckInTime.minute.toString().padLeft(2, '0')}:${adjustedCheckInTime.second.toString().padLeft(2, '0')}";
    }

    if (partsEndTime != null && partsEndTime.length == 3) {
      endTime = DateTime(
        today.year,
        today.month,
        today.day,
        partsEndTime[0],
        partsEndTime[1],
        partsEndTime[2],
      );

      // The checkOutTime string is used for display/range.
      // It's adjusted to show 1 hour after the scheduled end.
      final adjustedCheckOutTime = DateTime(
        today.year,
        today.month,
        today.day,
        partsEndTime[0],
        partsEndTime[1],
        partsEndTime[2],
      ).add(const Duration(hours: 1));

      checkOutTime =
          "${adjustedCheckOutTime.hour.toString().padLeft(2, '0')}:${adjustedCheckOutTime.minute.toString().padLeft(2, '0')}:${adjustedCheckOutTime.second.toString().padLeft(2, '0')}";
    }
    superPrint('start time end time $startTime $endTime');
  }

  bool isLateCheckIn(DateTime checkInTime) {
    final allowedLatestCheckIn = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
      startTime.hour,
      startTime.minute,
      59,
    );

    superPrint('checkin time $checkInTime  allowed time $allowedLatestCheckIn');
    return checkInTime.isAfter(allowedLatestCheckIn);
  }

  bool isEarlyCheckOut(DateTime checkOutTime) {
    return checkOutTime.isBefore(endTime);
  }

  //Shift Progress
  int calculateTimeDifference(DateTime start, DateTime end) {
    Duration difference = end.difference(start);
    return difference.inMinutes;
  }

  Future<void> checkInTimeMethod() async {
    int difference = Get.find<DashboardController>().calculateTimeDifference(
      startTime,
      endTime,
    );
    checkIn =
        (calculateTimeDifference(startTime, arrivedTime) / difference) *
        key.currentContext!.size!.width;
    update();
    superPrint(checkIn);
  }

  void checkOutTimeMethod() {
    int difference = Get.find<DashboardController>().calculateTimeDifference(
      startTime,
      endTime,
    );
    checkOut =
        (calculateTimeDifference(leaveTime, endTime) / difference) *
        key.currentContext!.size!.width;
    update();
    superPrint(checkOut, title: "Check out");
  }

  Future<void> fetchHomeReport() async {
    isLoading = true;
    update();
    http.Response? response = await Network().getHomeReport();
    var result = jsonDecode(response!.body);
    //superPrint('home report $result');
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      homeReport = HomeReport.fromJson(result['data']);
      update();
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['response']['message']);
    }
    isLoading = false;
    update();
  }

  bool isAttendance = false;
  //getHomeAttendanceCount
  Future<void> fetchAttendanceCount() async {
    isAttendance = true;
    update();
    http.Response? response = await Network().getHomeAttendanceCount();
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    // superPrint(response.body);
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        dailyAttendanceReport = DailyAttendanceReport.fromJson(
          result['data']['daily_attendance_report'],
        );
        checkInRequestReport = CheckInRequestReport.fromJson(
          result['data']['check_in_requests_report'],
        );
        checkOutRequestReport = CheckOutRequestReport.fromJson(
          result['data']['check_out_requests_report'],
        );
        leaveRequestReport = LeaveRequestReport.fromJson(
          result['data']['leave_requests_report'],
        );
        otRequestReport = OTRequestReport.fromJson(
          result['data']['overtime_requests_report'],
        );
        resignRequestReport = ResignRequestReport.fromJson(
          result['data']['resignation_requests_report'],
        );
        outpassRequestReport = OutpassRequestReport.fromJson(
          result['data']['out_pass_requests_report'],
        );
        dutyRequestReport = DutyRequestReport.fromJson(
          result['data']['duty_requests_report'],
        );
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e.toString());
    }
    isAttendance = false;
    update();
  }

  Future<void> fetchAllHoliday() async {
    holidayHome.clear();
    holidayList.clear();
    isHoliday = true;
    //update();
    http.Response? response = await Network().getAllHoliday();
    // superPrint("All Holiday ${response?.statusCode}");
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var i in iterable) {
        var data = Holiday.fromJson(i);
        holidayList.add(data);
      }

      for (var element in holidayList) {
        DateTime date = DateTime.parse(element.date);
        if (date.isAfter(DateTime.now())) {
          holidayHome.add(element);
        }
        // superPrint(holidayHome?.name);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['response']['message']);
    }
    isHoliday = false;
    update();
  }

  Future<void> fetchAllBirthdays() async {
    birthdayHome.clear();
    birthdayList.clear();
    isBirthday = true;
    //update();
    http.Response? response = await Network().getAllBirthdays();
    // superPrint("All Holiday ${response?.statusCode}");
    var result = jsonDecode(response!.body);
    debugPrint(result);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var i in iterable) {
        var data = Birthday.fromJson(i);
        birthdayList.add(data);
      }

      for (var element in birthdayList) {
        DateTime date = DateTime.parse(element.date);
        date = DateTime(DateTime.now().year, date.month, date.day);
        if (date.isAfter(DateTime.now()) ||
            date.isAtSameMomentAs(DateTime.now())) {
          birthdayHome.add(element);
        }
        // superPrint(birthdayHome.first.name);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['response']['message']);
    }
    isBirthday = false;
    update();
  }

  Future<void> fetchAllWorkingAnniversary() async {
    workingAnniversaryHome.clear();
    workingAnniversaryList.clear();
    isWorkingAnniversary = true;
    //update();
    http.Response? response = await Network().getAllWorkingAnniversary();
    // superPrint("All Holiday ${response?.statusCode}");
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var i in iterable) {
        var data = Birthday.fromJson(i);
        workingAnniversaryList.add(data);
      }

      for (var element in workingAnniversaryList) {
        DateTime date = DateTime.parse(element.date);
        date = DateTime(DateTime.now().year, date.month, date.day);
        if (date.isAfter(DateTime.now()) ||
            date.isAtSameMomentAs(DateTime.now())) {
          workingAnniversaryHome.add(element);
        }
        // superPrint(holidayHome?.name);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['response']['message']);
    }
    isHoliday = false;
    update();
  }

  // double progress = 0.0;
  // progressBarValue() {
  //   String checkInTime = homeReport?.dailyReport.time.checkIn ?? "00:00:00";
  //   String checkOutTime = homeReport?.dailyReport.time.checkOut ?? "00:00:00";
  //   DateTime arrivedTime = DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //     DateTime.now().day,
  //     int.parse(checkInTime.substring(0, 2)),
  //     int.parse(checkInTime.substring(3, 5)),
  //     int.parse(checkInTime.substring(6, 8)),
  //   );
  //   DateTime leavedTime = DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //     DateTime.now().day,
  //     int.parse(checkOutTime.substring(0, 2)),
  //     int.parse(checkOutTime.substring(3, 5)),
  //     int.parse(checkOutTime.substring(6, 8)),
  //   );
  //   if (arrivedTime.isAfter(startTime) && arrivedTime.isBefore(endTime)) {
  //     progress = arrivedTime.difference(startTime).inMilliseconds /
  //         endTime.difference(startTime).inMilliseconds;
  //   } else if (arrivedTime.isAfter(endTime)) {
  //     progress = 1.0;
  //   }
  //   superPrint(progress);
  //   update();
  // }
}
