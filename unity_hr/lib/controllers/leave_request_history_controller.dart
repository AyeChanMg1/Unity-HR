import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/leave_request.dart';
import 'package:unity_hr/models/overtime_request.dart';

class LeaveRequestHistoryController extends GetxController {
  String statusType = 'Waiting';
  String status = 'waiting';
  List<LeaveRequest> leaveRequestList = [];
  bool isLeave = false;
  List<LeaveRequest> leaveRequestHistoryList = [];
  List<OverTimeRequest> otRequestHistoryList = [];
  bool isHistory = false;
  bool isOTHistory = false;
  List<String> statusList = ['Waiting', 'Approved', 'Rejected'];

  String dateFrom = dobFormat(
    DateTime(DateTime.now().year, DateTime.now().month, 1),
  );
  String dateTo = dobFormat(
    DateTime(DateTime.now().year, DateTime.now().month + 1, 1),
  );

  //date range
  DateTimeRange selectedDate = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime.now(),
  );

  void statusTypeDropDown(String type) {
    statusType = type;
    if (statusType == 'Waiting') {
      status = 'waiting';
    } else if (statusType == 'Approved') {
      status = 'approved';
    } else if (statusType == 'Rejected') {
      status = 'rejected';
    }
    update();
  }

  //date range
  Future<void> selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      currentDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month - 5, 1),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 11),
    );
    if (picked != null && picked != selectedDate) {
      //superPrint(picked, title: "Date Range");
      selectedDate = picked;
      DateTime start = selectedDate.start;
      DateTime end = selectedDate.end;
      dateFrom = dobFormat(start);
      dateTo = dobFormat(end);
      update();
    }
    update();
  }

  //Leave Request
  Future<void> fetchAllLeaveRequest() async {
    leaveRequestList.clear();
    isLeave = true;
    update();
    try {
      http.Response? response = await Network().getLeaveRequest();
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = LeaveRequest.fromJson(data);
          leaveRequestList.add(list);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isLeave = false;
    update();
  }

  void fetchLeaveRequestHistory(
    String dateFrom,
    String dateTo,
    String status,
  ) async {
    leaveRequestHistoryList.clear();
    isHistory = true;
    update();
    superPrint(dateFrom, title: 'Start Date');
    superPrint(dateTo, title: 'End Date');
    superPrint(status, title: "Status");
    try {
      http.Response? response = await Network().searchLeaveRequestHistory(
        dateFrom,
        dateTo,
        status,
      );
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      superPrint(result);
      superPrint(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = LeaveRequest.fromJson(data);
          leaveRequestHistoryList.add(list);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isHistory = false;
    update();
  }

  void fetchOverTimeRequestHistory(
    String dateFrom,
    String dateTo,
    String status,
  ) async {
    otRequestHistoryList.clear();
    isOTHistory = true;
    update();
    superPrint(dateFrom, title: 'Start Date');
    superPrint(dateTo, title: 'End Date');
    superPrint(status, title: "Status");
    try {
      http.Response? response = await Network().searchOverTimeRequestHistory(
        dateFrom,
        dateTo,
        status,
      );
      var result = jsonDecode(response!.body);
      superPrint(result);
      superPrint(response.statusCode);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = OverTimeRequest.fromJson(data);
          otRequestHistoryList.add(list);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isOTHistory = false;
    update();
  }

  void clearHistoryData() {
    dateFrom = dobFormat(
      DateTime(DateTime.now().year, DateTime.now().month, 1),
    );
    dateTo = dobFormat(
      DateTime(DateTime.now().year, DateTime.now().month + 1, 1),
    );
    status = 'waiting';
    statusType = 'Waiting';
  }
}
