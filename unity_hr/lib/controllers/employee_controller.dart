import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/employee.dart';
import 'package:unity_hr/models/increment.dart';
import 'package:unity_hr/models/order.dart';
import 'package:unity_hr/models/probation_assessment_score.dart';
import 'package:unity_hr/models/promotion.dart';
import 'package:unity_hr/models/resignation.dart';
import 'package:unity_hr/models/survey_module.dart';
import 'package:unity_hr/models/transfer.dart';
import 'package:unity_hr/models/warning.dart';
import 'package:unity_hr/models/welfare.dart';

class EmployeeController extends GetxController {
  TextEditingController txtEmployeeController = TextEditingController();
  List<Employee> employeeList = [];
  List<Employee> searchEmployeeList = [];
  bool isEmployee = false;
  bool isSearching = false;

  List<Training> trainingList = [];
  List<Warning> warningList = [];
  List<Increment> incrementList = [];
  List<Promotion> promotionList = [];
  List<Transfer> transferList = [];
  List<Resignation> resignationlist = [];
  List<Order> orderlist = [];
  List<Welfare> welfareList = [];
  List<ProbationAssessmentScore> scoreList = [];
  bool isOtherInformation = false;

  //Search
  void onChange(String query) {
    isSearching = true;
    searchEmployeeList.clear();
    update();
    try {
      if (query.trim().isNotEmpty) {
        for (var eachPerson in employeeList) {
          if (eachPerson.name.trim().toLowerCase().contains(
            query.trim().toLowerCase(),
          )) {
            searchEmployeeList.add(eachPerson);
          }
        }
      } else {
        for (var element in employeeList) {
          searchEmployeeList.add(element);
        }
      }
    } catch (e) {
      superPrint(e);
    }
    isSearching = false;
    update();
  }

  //Employee List
  Future<void> fetchAllEmployee() async {
    employeeList.clear();
    searchEmployeeList.clear();
    isEmployee = true;
    update();
    try {
      http.Response? response = await Network().getAllEmployeeList();
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = Employee.fromJson(data);
          employeeList.add(list);
          searchEmployeeList.add(list);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['response']['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isEmployee = false;
    update();
  }

  Future<void> fetchOtherInformation(String id) async {
    scoreList.clear();
    trainingList.clear();
    welfareList.clear();
    warningList.clear();
    incrementList.clear();
    promotionList.clear();
    transferList.clear();
    resignationlist.clear();
    orderlist.clear();
    isOtherInformation = true;
    update();
    //  try {
    http.Response? response = await Network().getOtherInformation(id);
    var result = jsonDecode(response!.body);
    superPrint('other info idddddddd $id');
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Iterable scores = result['probation_assessment_scores'];
      // for (var data in scores) {
      //   var list = ProbationAssessmentScore.fromJson(data);
      //   scoreList.add(list);
      // }
      Iterable training = result['training'];
      for (var data in training) {
        var list = Training.fromJson(data);
        trainingList.add(list);
      }
      Iterable welfare = result['welfare'];
      for (var data in welfare) {
        var list = Welfare.fromJson(data);
        welfareList.add(list);
      }
      Iterable warning = result['warning'];
      for (var data in warning) {
        var list = Warning.fromJson(data);
        warningList.add(list);
      }
      Iterable increment = result['increment'];
      for (var data in increment) {
        var list = Increment.fromJson(data);
        incrementList.add(list);
      }
      Iterable promotion = result['promotion'];
      for (var data in promotion) {
        var list = Promotion.fromJson(data);
        promotionList.add(list);
      }
      Iterable transfer = result['transfer'];
      for (var data in transfer) {
        var list = Transfer.fromJson(data);
        transferList.add(list);
      }
      Iterable resignation = result['resignation'];
      for (var data in resignation) {
        superPrint('resignation list ${result['resignation']}');
        var list = Resignation.fromJson(data);
        resignationlist.add(list);
      }
      Iterable order = result['order'];
      for (var data in order) {
        var list = Order.fromJson(data);
        orderlist.add(list);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    // } catch (e) {
    //   superPrint(e);
    // }
    isOtherInformation = false;
    update();
  }
}
