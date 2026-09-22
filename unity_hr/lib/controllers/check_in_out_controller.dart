import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/check_in_out.dart';

import 'dashboard_controller.dart';

class CheckInOutController extends GetxController {
  TextEditingController txtRemarkController = TextEditingController();
  bool isCheckIn = false;
  bool isCheckOut = false;
  List<CheckIn> checkInList = [];
  List<CheckOut> checkOutList = [];
  bool isApproval = false;

  Future<void> fetchCheckInControlelr() async {
    checkInList.clear();
    isCheckIn = true;
    update();
    http.Response? response = await Network().getAllCheckInRequest();
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var i in iterable) {
        var data = CheckIn.fromJson(i);
        checkInList.add(data);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    isCheckIn = false;
    update();
  }

  Future<void> fetchCheckOutControlelr() async {
    checkOutList.clear();
    isCheckOut = true;
    update();
    http.Response? response = await Network().getAllCheckOutRequest();
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var i in iterable) {
        var data = CheckOut.fromJson(i);
        checkOutList.add(data);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    isCheckOut = false;
    update();
  }

  Future<void> postCheckInApproveReject(
    String approval,
    String rejection,
    String id,
  ) async {
    isApproval = true;
    update();
    try {
      http.Response? response = await Network().approveRejectCheckInRequest(
        approval,
        rejection,
        txtRemarkController.text,
        id,
      );
      superPrint(response?.statusCode, title: "Status Code");
      superPrint(response?.body);
      tooManyRequest(response?.statusCode ?? 429);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        fetchCheckInControlelr();
        Get.find<DashboardController>().fetchAttendanceCount();
        txtRemarkController.clear();
        showSuccessAlert(jsonDecode(response!.body)['response']['message'], () {
          Get.back();
          Get.back();
        });
        update();
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode != 429) {
        showAlert(jsonDecode(response!.body)['response']['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isApproval = false;
    update();
  }

  Future<void> postCheckOutApproveReject(
    String approval,
    String rejection,
    String id,
  ) async {
    isApproval = true;
    update();
    try {
      http.Response? response = await Network().approveRejectCheckOutRequest(
        approval,
        rejection,
        txtRemarkController.text,
        id,
      );
      tooManyRequest(response?.statusCode ?? 429);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        fetchCheckOutControlelr();
        Get.find<DashboardController>().fetchAttendanceCount();
        txtRemarkController.clear();
        showSuccessAlert(jsonDecode(response!.body)['response']['message'], () {
          Get.back();
          Get.back();
        });
        update();
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode != 429) {
        showAlert(jsonDecode(response!.body)['response']['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isApproval = false;
    update();
  }
}
