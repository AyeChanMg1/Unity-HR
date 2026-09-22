import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/company.dart';
import 'package:unity_hr/models/overtime_detail.dart';
import 'package:unity_hr/models/overtime_history.dart';
import 'package:unity_hr/models/overtime_request.dart';
import 'package:unity_hr/models/overtime_response.dart';
import 'package:unity_hr/models/reform_person.dart';
import 'package:unity_hr/models/request_person.dart';
import 'dashboard_controller.dart';
import 'navbar_controller.dart';

class OverTimeController extends GetxController {
  TextEditingController txtReasonController = TextEditingController();
  TextEditingController txtRemarkController = TextEditingController();
  TextEditingController txtSiteIdController = TextEditingController();
  TextEditingController txtWorkOrderIdController = TextEditingController();
  TextEditingController txtFromTimeController = TextEditingController();
  TextEditingController txtToTimeController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String overtimeDate = DateFormat("MMMM - yyyy").format(DateTime.now());
  //TimeOfDay formattedTime = TimeOfDay.now();
  String duration = 'Choose Date';
  String totalOvertime = '00:00:00';
  String totalWorkingDayOT = '00:00:00';
  String totalOffDayOT = '00:00:00';
  late OverTimeResponse overTimeResponse;

  String monthType = DateFormat('MMMM').format(DateTime.now());
  String date = DateFormat(
    'yyyy-MM',
  ).format(DateTime(DateTime.now().year, DateTime.now().month));

  List<OverTimeRequest> overtimeRequestList = [];
  bool isOT = false;
  bool isOTRequest = false;

  List<OverTimeHistory> otHistoryList = [];
  bool isOTHistory = false;
  List<RequestPerson> requestPersonList = [];
  List<RequestPerson> searchRequestList = [];
  List<RequestPerson> dynamicRequestPersonList = [];
  List<String> multiRequestID = [];

  List<ReformPerson> reformPersonList = [];
  List<ReformPerson> searchReformList = [];
  List<ReformPerson> dynamicReformPersonList = [];
  List<String> multiReformID = [];
  bool isRequest = false;
  bool isReform = false;
  bool isSearching = false;
  OverTimeDetails? overTimeDetails;
  bool isOTDetails = false;
  bool isApproval = false;
  List totalTimeList = [];
  Duration totalDuration = const Duration(hours: 00, milliseconds: 00);

  String company = "";

  Future<void> getCompany() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString('company') ?? "";
    superPrint(json, title: 'Company Name');
    if (json != '') {
      Map<String, dynamic> data = jsonDecode(json);
      companyName = Company.formJson(data);
      company = companyName?.domain ?? "";
    } else {
      companyName = Company(name: '', domain: '');
    }
  }

  void time(BuildContext context) {
    //String time = formattedTime.format(context);
    // txtFromTimeController.text = time;
    // txtToTimeController.text = time;
    txtFromTimeController.text = "Start Time";
    txtToTimeController.text = "End Time";
  }

  void monthTypeDropDown(String type) {
    monthType = type;
    update();
  }

  // Leave Date Value Update
  Future<void> selectDate(BuildContext context, String joinDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      // firstDate: DateTime(DateTime.now().year, DateTime.now().month - 1),
      firstDate: DateTime.parse(joinDate),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 10),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      duration = dobFormat(selectedDate);
    }
    update();
  }

  Future<void> selectTime(
    BuildContext context,
    TextEditingController txtController,
  ) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (pickedTime != null) {
      String formattedTime = pickedTime.format(Get.context!);
      txtController.text = formattedTime; //set the value of text field.
    } else {
      debugPrint("Time is not selected");
    }
  }

  void initialEditTime() {
    if (overTimeDetails != null) {
      txtFromTimeController.text = parseTime(
        overTimeDetails!.timeFrom,
      ).format(Get.context!);
      txtToTimeController.text = parseTime(
        overTimeDetails!.timeTo,
      ).format(Get.context!);
      update();
    }
  }

  Future<void> selectRequestTime(
    BuildContext context,
    TextEditingController txtController,
    String time,
  ) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: parseTime(time),
      context: context,
    );

    if (pickedTime != null) {
      String formattedTime = pickedTime.format(Get.context!);
      txtController.text = formattedTime; //set the value of text field.
    } else {
      debugPrint("Time is not selected");
    }
  }

  TimeOfDay parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  //search
  void onChange(String query) {
    isSearching = true;
    update();
    searchRequestList.clear();
    if (query.trim().isNotEmpty) {
      for (var eachPerson in requestPersonList) {
        if (eachPerson.name.trim().toLowerCase().contains(
          query.trim().toLowerCase(),
        )) {
          searchRequestList.add(eachPerson);
        }
      }
    } else {
      for (var element in requestPersonList) {
        searchRequestList.add(element);
      }
    }
    isSearching = false;
    update();
  }

  void onReformChange(String query) {
    isSearching = true;
    update();
    searchReformList.clear();
    if (query.trim().isNotEmpty) {
      for (var eachPerson in reformPersonList) {
        if (eachPerson.name.trim().toLowerCase().contains(
          query.trim().toLowerCase(),
        )) {
          searchReformList.add(eachPerson);
        }
      }
    } else {
      for (var element in reformPersonList) {
        searchReformList.add(element);
      }
    }
    isSearching = false;
    update();
  }

  //OverTime Request
  Future<void> fetchOverTimeRequest() async {
    overtimeRequestList.clear();
    isOT = true;
    update();
    try {
      http.Response? response = await Network().getOTRequest();
      var result = jsonDecode(response!.body);
      debugPrint(result);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        // totalOvertime = result['totalOvertime'];
        for (var data in iterable) {
          var list = OverTimeRequest.fromJson(data);
          overtimeRequestList.add(list);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }

    isOT = false;
    update();
  }

  void clearOTFormData() {
    multiReformID.clear();
    multiRequestID.clear();
    dynamicRequestPersonList.clear();
    dynamicReformPersonList.clear();
    duration = 'Choose Date';
    time(Get.context!);
    selectedDate = DateTime.now();
    txtReasonController.clear();
    txtRemarkController.clear();
    txtSiteIdController.clear();
    txtWorkOrderIdController.clear();
  }

  //Request person id
  void setSelectedRequestPerson(RequestPerson personList) {
    if (dynamicRequestPersonList.isNotEmpty) {
      var index = dynamicRequestPersonList.indexWhere(
        (element) => element.id == personList.id,
      );
      if (index == -1) {
        dynamicRequestPersonList.add(personList);
        multiRequestID.add(personList.id);
      }
    } else {
      dynamicRequestPersonList.add(personList);
      multiRequestID.add(personList.id);
    }

    superPrint(multiRequestID, title: "New Request Person id");
    update();
  }

  //reform person id
  void setSelectedReformPerson(ReformPerson personList) {
    if (dynamicReformPersonList.isNotEmpty) {
      var index = dynamicReformPersonList.indexWhere(
        (element) => element.id == personList.id,
      );
      if (index == -1) {
        dynamicReformPersonList.add(personList);
        multiReformID.add(personList.id);
      }
    } else {
      dynamicReformPersonList.add(personList);
      multiReformID.add(personList.id);
    }

    superPrint(multiReformID, title: "New Reform Person id");
    update();
  }

  Future<void> fetchAllRequestPerson() async {
    requestPersonList.clear();
    searchRequestList.clear();
    isRequest = true;
    update();
    http.Response? response = await Network().getAllRequestPerson();
    // superPrint(response?.statusCode);
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var data in iterable) {
        var list = RequestPerson.fromJson(data);
        requestPersonList.add(list);
        searchRequestList.add(list);
        // multiRequestPerson.add(list.name);
      }
      update();
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    isRequest = false;
    update();
  }

  Future<void> fetchAllReformPerson() async {
    reformPersonList.clear();
    searchReformList.clear();
    // multiReformPerson.clear();
    isReform = true;
    update();
    try {
      http.Response? response = await Network().getAllReformPerson();
      // superPrint(response?.statusCode);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = ReformPerson.fromJson(data);
          reformPersonList.add(list);
          searchReformList.add(list);
        }
        update();
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isReform = false;
    update();
  }

  //post ot
  Future<void> postOTRequestForm() async {
    isOTRequest = true;
    update();
    try {
      http.Response? response = await Network().otFormRequest(
        duration,
        txtFromTimeController.text,
        txtToTimeController.text,
        multiRequestID,
        multiReformID,
        txtReasonController.text,
        txtSiteIdController.text,
        txtWorkOrderIdController.text,
      );
      tooManyRequest(response?.statusCode ?? 429);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        showSuccessAlert("Request sent!", () {
          Get.back();
          Get.back();
        }, color: color1);
        Get.back();
        Get.find<NavBarController>().indexWidgets[2];
        fetchOTHistory(date);
        time(Get.context!);
        showSuccessAlert('Request Sent!', () {
          clearOTFormData();
          Get.back();
          Get.back();
        });
        update();
      } else if (response?.statusCode == 400) {
        showAlert(jsonDecode(response!.body)['response']['message']);
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode != 429) {
        showAlert(jsonDecode(response!.body)['response']['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isOTRequest = false;
    update();
  }

  Future<void> fetchOTHistory(String date) async {
    otHistoryList.clear();
    totalTimeList.clear();
    isOTHistory = true;
    update();
    try {
      //superPrint(date, title: 'Date Format');
      http.Response? response = await Network().getOverTimeHistory(date);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['data'] != null) {
          Iterable iterable = result['data']['overtime_requests'];
          totalOvertime = result['data']['totalOvertime'].toString();
          totalWorkingDayOT = result['data']['total_working_day_ot'].toString();
          totalOffDayOT = result['data']['total_off_day_ot'].toString();

          for (var data in iterable) {
            var list = OverTimeHistory.fromJson(data);
            otHistoryList.add(list);
          }
          if (otHistoryList.isNotEmpty) {
            for (var element in otHistoryList) {
              if (element.status == 'approved') {
                DateTime start = DateFormat('HH:mm:ss').parse(element.timeFrom);
                DateTime end = DateFormat('HH:mm:ss').parse(element.timeTo);
                Duration duration = end.difference(start);
                totalTimeList.add(duration);
                totalDuration = totalTimeList.reduce((a, b) => a + b);
                // superPrint(totalTimeList);
                // superPrint(totalDuration);
              }
            }
          }
          update();
        } else {
          otHistoryList.add(result['data']);

          update();
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['response']['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isOTHistory = false;
    update();
  }

  //view overtime by id
  Future<void> fetchOverTimeByID(String id) async {
    isOTDetails = true;
    update();
    try {
      superPrint(id, title: 'OT Details ID');
      http.Response? response = await Network().getOverTimeHistoryByID(id);
      var result = jsonDecode(response!.body);
      debugPrint(result);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = OverTimeDetails.fromJson(result['data']);
        overTimeDetails = OverTimeDetails(
          id: data.id,
          name: data.name,
          image: data.image,
          timeFrom: data.timeFrom,
          timeTo: data.timeTo,
          position: data.position,
          department: data.department,
          date: data.date,
          status: data.status,
          reason: data.reason,
          remark: data.remark,
          siteId: data.siteId,
          workOrderId: data.workOrderId,
        );
        initialEditTime();
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['response']['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isOTDetails = false;
    update();
  }

  //Approvel and Reject OverTime
  Future<void> postOverTimeRequestApproveReject(
    String approval,
    String rejection,
    String id,
  ) async {
    isApproval = true;
    update();
    try {
      http.Response? response = await Network().approveRejectOverTimeRequest(
        approval,
        rejection,
        txtRemarkController.text,
        id,
        txtFromTimeController.text,
        txtToTimeController.text,
      );

      tooManyRequest(response?.statusCode ?? 429);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        // Get.back();
        fetchOverTimeRequest();
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
