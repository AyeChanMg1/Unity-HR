import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/payslip.dart';

class PayrollController extends GetxController {
  String monthType = DateFormat('MMMM').format(DateTime.now());
  String monthNum = DateFormat('MM').format(DateTime.now());
  String yearType = DateFormat('yyyy').format(DateTime.now());
  // String payDate =
  //     "${DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day}${DateFormat('-MMM-yyyy').format(
  //   DateTime.now(),
  // )}";
  String payDate = DateFormat("MMMM - yyyy").format(DateTime.now());
  bool isPaySlip = false;
  PaySlip? payslip;
  // Month Type DropDown Value Update
  void monthTypeDropDown(String type) {
    monthType = type;
    update();
  }

  void changeMonthNumber(String num) {
    monthNum = num;
    update();
  }

  void clearData() {
    monthNum = DateFormat('MM').format(DateTime.now());
    monthType = DateFormat('MMMM').format(DateTime.now());
    yearType = DateFormat('yyyy').format(DateTime.now());
    // payDate =
    //     "${DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day}${DateFormat('-MMM-yyyy').format(
    //   DateTime.now(),
    // )}";
    payDate = DateFormat("MMMM - yyyy").format(DateTime.now());
  }

  //PaySlip or Payroll
  Future<void> fetchPaySlip(String year, String month) async {
    isPaySlip = true;
    update();
    http.Response? response = await Network().getPaySlip(year, month);
    var result = jsonDecode(response!.body);
    superPrint(response.statusCode);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = result['data'];
      if (result['data'] != null) {
        payslip = PaySlip.fromJson(data);
        //superPrint(payslip?.netSalary);
      } else {
        payslip = null;
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    isPaySlip = false;
    update();
  }
}
