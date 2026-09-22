import 'dart:convert';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/view_attendance.dart';

class AttendanceController extends GetxController {
  String monthType = DateFormat('MMMM').format(DateTime.now());
  String monthNum = DateFormat('MM').format(DateTime.now());
  String yearType = DateFormat('yyyy').format(DateTime.now());
  String attendanceDate = DateFormat("MMMM - yyyy").format(DateTime.now());
  bool isAttendance = false;
  List<ViewAttendance> viewAttendanceList = [];
  String selectedIndex = '0';

  List<String> yearList = [];

  // Month Type DropDown Value Update
  void monthTypeDropDown(String type) {
    monthType = type;
    update();
  }

  void changeMonthNumber(String num) {
    monthNum = num;
    update();
  }

  // Year Type DropDown Value Update
  void yearTypeDropDown(String type) {
    yearType = type;
    update();
  }

  // getAllMyAttendance
  Future<void> fetchAllMyAttendance(String year, String month) async {
    viewAttendanceList.clear();
    isAttendance = true;
    superPrint(monthNum, title: "Month Number");
    update();
    http.Response? response = await Network().getAllMyAttendance(year, month);
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var i in iterable) {
        var data = ViewAttendance.fromJson(i);
        viewAttendanceList.add(data);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    isAttendance = false;
    update();
  }

  void clearSelectedIndex() {
    selectedIndex = '';
    update();
  }

  void updateSelectedIndex(String index) {
    selectedIndex = index;
    update();
  }

  //Year
  Future<void> fetchYears() async {
    yearList.clear();
    isAttendance = true;
    update();
    http.Response? response = await Network().getYear();
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    //superPrint(result['data']);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var list in iterable) {
        yearList.add(list);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    isAttendance = false;
    update();
  }

  void clearAttendanceData() {
    monthType = DateFormat('MMMM').format(DateTime.now());
    yearType = DateFormat('yyyy').format(DateTime.now());
    monthNum = DateFormat('MM').format(DateTime.now());
    selectedIndex = '0';
  }
}
