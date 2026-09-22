import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/outpass.dart';
import 'package:unity_hr/models/overtime_request.dart';
import 'package:unity_hr/models/overtime_response.dart';
import 'package:unity_hr/models/reform_person.dart';
import 'package:unity_hr/models/request_person.dart';
import 'dashboard_controller.dart';
import 'navbar_controller.dart';

class OutPassController extends GetxController {
  TextEditingController txtReasonController = TextEditingController();
  TextEditingController txtRemarkController = TextEditingController();
  TextEditingController txtFromTimeController = TextEditingController();
  TextEditingController txtToTimeController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String overtimeDate = DateFormat("MMMM - yyyy").format(DateTime.now());
  //TimeOfDay formattedTime = TimeOfDay.now();
  String duration = 'Choose Date';
  String toDuration = 'Choose Date';
  String totalWorkingDayOT = '00:00:00';
  String totalOffDayOT = '00:00:00';
  late OverTimeResponse overTimeResponse;

  // outpass request
  final List<OutpassRequestModel> outpassRequestList = [];

  List<String> outPassTypeList = ['On Duty Form', "Travel Request Form"];
  String outPassType = "On Duty Form";

  List orderType = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController costController = TextEditingController();

  String monthType = DateFormat('MMMM').format(DateTime.now());
  String date = DateFormat(
    'yyyy-MM',
  ).format(DateTime(DateTime.now().year, DateTime.now().month));

  List<OverTimeRequest> overtimeRequestList = [];
  bool isOT = false;
  bool isOTRequest = false;

  List<OutPass> otHistoryList = [];
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
  OutPass? overTimeDetails;
  bool isOTDetails = false;
  bool isApproval = false;
  List totalTimeList = [];
  Duration totalDuration = const Duration(hours: 00, milliseconds: 00);

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
      firstDate: DateTime.parse(joinDate),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 10),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      duration = outPassDateFormat(selectedDate);
    }
    update();
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: selectedDate.add(Duration(days: 1)),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 10),
    );
    if (picked != null && picked != toDate) {
      toDate = picked;
      toDuration = outPassDateFormat(toDate);
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

  void clearOTFormData() {
    multiReformID.clear();
    multiRequestID.clear();
    dynamicRequestPersonList.clear();
    dynamicReformPersonList.clear();
    duration = 'Choose Date';
    toDuration = 'Choose Date';
    time(Get.context!);
    selectedDate = DateTime.now();
    toDate = DateTime.now();
    txtReasonController.clear();
    orderType.clear();
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

  Future<void> editSelectedRequestPerson(List<String> ids) async {
    await fetchAllRequestPerson();
    for (var id in ids) {
      final personList = requestPersonList.where((e) => e.id == id).first;
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
    }
    superPrint(multiRequestID, title: "New Request Person id");
    update();
  }

  /// approve/reject outpass request
  void postOutpassRequestApproveReject(
    String approval,
    String rejection,
    String id,
  ) async {
    isApproval = true;
    update();
    try {
      http.Response? response = await Network().approveRejectOutpassRequest(
        approval,
        rejection,
        txtRemarkController.text,
        id,
      );
      tooManyRequest(response?.statusCode ?? 429);
      superPrint('---> response body ${response?.body}');
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        //Get.back();
        fetchOutpassRequestHistory();
        Get.find<DashboardController>().fetchAttendanceCount();
        txtRemarkController.clear();
        showSuccessAlert("Out Pass Request status updated successfully.", () {
          Get.back();
          Get.back();
        });
        update();
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode != 429) {
        showAlert(jsonDecode(response!.body)['message']);
      }
    } catch (e) {
      superPrint(e.toString());
    }
    isApproval = false;
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

  Future<void> editSelectedReformPerson(List<String> ids) async {
    await fetchAllReformPerson();
    for (var id in ids) {
      final personList = reformPersonList.where((e) => e.id == id).first;
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
    }

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

  Future<void> fetchOutpassRequestHistory() async {
    // multiReformPerson.clear();
    outpassRequestList.clear();
    // try {
    superPrint("fetchibg");
    http.Response? response = await Network().getAllOutpassRequestHistory();
    superPrint(response?.statusCode, title: "outpass");
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var data in iterable) {
        outpassRequestList.add(OutpassRequestModel.fromJson(data));
      }
      superPrint(outpassRequestList.length, title: "outpass");
      update();
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    // } catch (e) {
    //   superPrint(e);
    // }
  }

  //post outpass
  Future<void> postOutPassRequest() async {
    isOTRequest = true;
    update();
    try {
      http.Response? response = await Network().outPassRequest(
        duration,
        toDuration,
        outPassType,
        orderType,
        txtFromTimeController.text,
        txtToTimeController.text,
        multiRequestID,
        multiReformID,
        txtReasonController.text,
      );
      tooManyRequest(response?.statusCode ?? 429);
      superPrint('response body ${response?.body}');
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        showSuccessAlert("Request sent!", () {
          Get.back();
          Get.back();
        }, color: color1);
        Get.back();
        Get.find<NavBarController>().indexWidgets[2];
        fetchOutPassHistory(date);
        time(Get.context!);
        showSuccessAlert('Request Sent!', () {
          clearOTFormData();
          Get.back();
          Get.back();
        });
        update();
      } else if (response?.statusCode == 400) {
        showAlert(jsonDecode(response!.body)['message']);
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode != 429) {
        showAlert(jsonDecode(response!.body)['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isOTRequest = false;
    update();
  }

  //edit outpass
  Future<void> editOutPassRequest(String id) async {
    isOTRequest = true;
    update();
    try {
      http.Response? response = await Network().editOutPassRequest(
        id,
        duration,
        toDuration,
        outPassType,
        orderType,
        txtFromTimeController.text,
        txtToTimeController.text,
        multiRequestID,
        multiReformID,
        txtReasonController.text,
      );
      tooManyRequest(response?.statusCode ?? 429);
      superPrint('response body ${response?.body}');
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        showSuccessAlert("Edit Request sent!", () {
          Get.back();
          Get.back();
        }, color: color1);
        Get.back();
        Get.find<NavBarController>().indexWidgets[2];
        fetchOutPassHistory(date);
        fetchOutPassByID(id);
        time(Get.context!);
        showSuccessAlert('Edit Request Sent!', () {
          clearOTFormData();
          Get.back();
          Get.back();
        });
        update();
      } else if (response?.statusCode == 400) {
        showAlert(jsonDecode(response!.body)['message']);
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode != 429) {
        showAlert(jsonDecode(response!.body)['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isOTRequest = false;
    update();
  }

  //delete outpass
  Future<void> deleteOutPassRequest(String id) async {
    isOTRequest = true;
    update();
    try {
      http.Response? response = await Network().deleteOutPassRequest(id);
      tooManyRequest(response?.statusCode ?? 429);
      superPrint('response body ${response?.body}');
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        showSuccessAlert("Delete Request!", () {
          Get.back();
          Get.back();
        }, color: color1);
        Get.back();
        Get.find<NavBarController>().indexWidgets[2];
        fetchOutPassHistory(date);
        time(Get.context!);
        showSuccessAlert('Delete Request!', () {
          clearOTFormData();
          Get.back();
          Get.back();
        });
        update();
      } else if (response?.statusCode == 400) {
        showAlert(jsonDecode(response!.body)['message']);
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode != 429) {
        showAlert(jsonDecode(response!.body)['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isOTRequest = false;
    update();
  }

  Future<void> fetchOutPassHistory(String date) async {
    otHistoryList.clear();
    totalTimeList.clear();
    isOTHistory = true;
    update();
    // try {
    //superPrint(date, title: 'Date Format');
    http.Response? response = await Network().getOutPassHistory(date);
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (result['data'] != null) {
        for (var data in result['data']) {
          var list = OutPass.fromJson(data);
          otHistoryList.add(list);
        }
        update();
      } else {
        otHistoryList.add(result['data']);
        update();
      }
      superPrint('history list ${result['data']}');
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['response']['message']);
    }
    // } catch (e) {
    //   superPrint(e);
    // }
    isOTHistory = false;
    update();
  }

  //view overtime by id
  Future<void> fetchOutPassByID(String id) async {
    isOTDetails = true;
    update();
    try {
      superPrint(id, title: 'OutPass Details ID');
      http.Response? response = await Network().getOutPassHistoryByID(id);
      var result = jsonDecode(response!.body);
      superPrint('status code ${response.statusCode}');
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        OutPass data = OutPass.fromJson(result['data']);
        superPrint('result ${result['data']}');
        overTimeDetails = data;
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

  Future<dynamic> showLeaveTypeDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.only(
            top: screenHeight * 0.2,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizedBox(
            width: screenWidth * 0.95,
            height: screenHeight * 0.4,
            child: ListView(
              children: outPassTypeList.map((outpass) {
                return Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          outPassType = outpass;
                          if (outPassType == "On Duty Form") {
                            orderType.clear();
                            nameController.clear();
                            costController.clear();
                          }
                          update();
                          Get.back();
                        },
                        child: Container(
                          width: screenWidth * 0.7,
                          height: 30,
                          alignment: Alignment.centerLeft,
                          color: Colors.transparent,
                          child: Text(outpass),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
