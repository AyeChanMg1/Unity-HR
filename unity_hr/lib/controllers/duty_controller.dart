import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_watermark/image_watermark.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:unity_hr/controllers/remote_check_in_controller.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/duty.dart';

class DutyController extends GetxController {
  bool xDuty = false;
  List<DutyTask> dutyTaskList = [];

  bool xUpdate = false;

  DateTime selectedDate = DateTime.now();
  String duration = dobFormat(DateTime.now());

  DateTime selectedDateEmp = DateTime.now();
  String durationEmp = dobFormat(DateTime.now());

  TextEditingController reasonController = TextEditingController();
  TextEditingController extendDayController = TextEditingController();

  DateTime selectedDateDuty = DateTime.now();
  TextEditingController dutyNameController = TextEditingController();
  TextEditingController dutyDescController = TextEditingController();
  int dutyType = 1;
  bool isDutyReport = false;
  bool isSubstitute = false;
  bool isSelfAssign = false;
  bool isHodAssign = false;
  var selectedPriority = {"data": "low", "name": "Low", "color": Colors.grey};

  var editPriority = {"data": "low", "name": "Low", "color": Colors.grey};
  var priorities = [
    {"data": "low", "name": "Low", "color": Colors.grey},
    {"data": "normal", "name": "Normal", "color": Colors.blue},
    {"data": "high", "name": "High", "color": Colors.yellow},
    {"data": "urgent", "name": "Urgent", "color": Colors.red},
  ];

  bool xDutyAssign = false;
  List<DutyTask> dutyAssignList = [];

  bool xDutyAssignUpdate = false;

  TextEditingController subNameController = TextEditingController();
  TextEditingController subDescController = TextEditingController();
  TextEditingController subReasonController = TextEditingController();

  Future<void> changeDateDuty(DateTime selectedDate) async {
    selectedDateDuty = selectedDate;
    getDutyAssign(dobFormat(selectedDate));
    update();
  }

  Future<void> changePriority(dynamic data) async {
    selectedPriority = data;
    update();
  }

  Future<void> updatePriority(dynamic data) async {
    editPriority = data;
    update();
  }

  Future<void> clearFormData() async {
    dutyNameController.clear();
    dutyDescController.clear();
    subDescController.clear();
    subNameController.clear();
    subReasonController.clear();
    selectedPriority = {"data": "low", "name": "Low", "color": Colors.grey};
    update();
  }

  Future<Uint8List> addWatermark(File image) async {
    LatLng currentLocation =
        Get.find<RemoteCheckInController>().currentLocation;
    // String location =
    //     "Latitude - ${currentLocation.latitude}\nLongitude - ${currentLocation.longitude}";
    xUpdate = true;
    update();
    // final DateTime timeAmsterdamTZ =
    //     DateTime.now();
    CompressFormat format = CompressFormat.jpeg;

    final String targetPath = p.join(
      Directory.systemTemp.path,
      'temp.${format.name}',
    );
    final XFile? compressedImage =
        await FlutterImageCompress.compressAndGetFile(
          image.path,
          targetPath,
          quality: 20,
          format: format,
        );
    final t = await compressedImage?.readAsBytes();
    var imageBytes = Uint8List.fromList(t!);
    String dateValue = DateFormat("dd MMMM yyyy").format(DateTime.now());
    String timeValue = DateFormat("hh:mm a").format(DateTime.now());

    // 1. Separate the text into Left (Labels) and Right (Values)
    String labelsText =
        "Date\n"
        "Time\n"
        "Latitude\n"
        "Longitude";

    String valuesText =
        ":  $dateValue\n"
        ":  $timeValue\n"
        ":  ${currentLocation.latitude}\n"
        ":  ${currentLocation.longitude}";

    final watermarkedLabelsBytes = await ImageWatermark.addTextWatermark(
      imgBytes: imageBytes,
      watermarkText: labelsText,
      color: Colors.white,
      dstX: 40,
      dstY: 40,
    );

    final finalWatermarkedBytes = await ImageWatermark.addTextWatermark(
      imgBytes: watermarkedLabelsBytes,
      watermarkText: valuesText,
      color: Colors.white,
      dstX: 300,
      dstY: 40,
    );
    return finalWatermarkedBytes;
  }

  Future<void> getDutyType() async {
    xDuty = true;
    update();
    try {
      http.Response? response = await Network().getDutyType();
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = result['data'] as List;
        isHodAssign = res.where((e) {
          return e['type'] == 'assign_by_hod' && e['status'] == 1;
        }).isNotEmpty;
        isSelfAssign = res.where((e) {
          return e['type'] == 'self_assign' && e['status'] == 1;
        }).isNotEmpty;
        isDutyReport = res.where((e) {
          return e['type'] == 'duty_report' && e['status'] == 1;
        }).isNotEmpty;
        isSubstitute = res.where((e) {
          return e['type'] == 'substitute' && e['status'] == 1;
        }).isNotEmpty;
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xDuty = false;
    update();
  }

  Future<void> duties(String date) async {
    xDuty = true;
    dutyTaskList.clear();
    update();
    try {
      http.Response? response = await Network().duties(date);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = result['data']['duties'];
        for (var e in res) {
          DutyTask dutyTask = DutyTask.fromJson(e);
          dutyTaskList.add(dutyTask);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xDuty = false;
    update();
  }

  Future<void> employeeDuties(String date, String empId) async {
    xDuty = true;
    dutyTaskList.clear();
    update();
    try {
      http.Response? response = await Network().employeeDuties(date, empId);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = result['data'];
        for (var e in res) {
          DutyTask dutyTask = DutyTask.fromJson(e);
          dutyTaskList.add(dutyTask);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xDuty = false;
    update();
  }

  // getDutyByID(int id) async {
  //   xDutyDetails = true;
  //   employeeDutyDetailsList.clear();
  //   update();
  //   try {
  //     http.Response? response = await Network().getDutyByID(id);
  //     var result = jsonDecode(response!.body);
  //     tooManyRequest(response.statusCode);
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       var res = result['data'];
  //       for(var e in res){
  //         EmployeeDuty employeeDuty = EmployeeDuty.fromJson(e);
  //         employeeDutyDetailsList.add(employeeDuty);
  //       }
  //     } else if (response.statusCode == 401) {
  //       validateLogout();
  //     } else if (response.statusCode != 429) {
  //       showAlert(result['message']);
  //     }
  //   } catch (e) {
  //     superPrint(e);
  //   }
  //   xDutyDetails = false;
  //   update();
  // }

  Future<void> updateDuty(int id, String status, String date, var image) async {
    xUpdate = true;
    update();
    try {
      http.Response? response = await Network().updateDuty(id, status, image);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        duties(date);
        showAlert("Success");
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xUpdate = false;
    update();
  }

  Future<void> extendDuty(int id, String date, String reason, int days) async {
    xUpdate = true;
    update();
    try {
      http.Response? response = await Network().extendDuty(id, reason, days);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        duties(date);
        showAlert("Success");
        reasonController.clear();
        extendDayController.clear();
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xUpdate = false;
    update();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(
        DateTime.now().year + 1,
        DateTime.now().month + 8,
        DateTime.now().day,
      ),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      duration = dobFormat(selectedDate);
      duties(duration);
    }
    update();
  }

  Future<void> selectDateEmp(BuildContext context, String empId) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateEmp,
      firstDate: DateTime(1900),
      lastDate: DateTime(
        DateTime.now().year + 1,
        DateTime.now().month + 8,
        DateTime.now().day,
      ),
    );
    if (picked != null && picked != selectedDateEmp) {
      selectedDateEmp = picked;
      durationEmp = dobFormat(selectedDateEmp);
      employeeDuties(durationEmp, empId);
    }
    update();
  }

  Future<void> getDutyAssign(String date) async {
    xDutyAssign = true;
    dutyAssignList.clear();
    update();
    try {
      http.Response? response = await Network().getDutyAssign(date);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(response.body);
        var res = result['data'];
        for (var e in res) {
          DutyTask dutyTask = DutyTask.fromJson(e);
          dutyAssignList.add(dutyTask);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xDutyAssign = false;
    update();
  }

  Future<void> createDutyAssign(
    String date,
    String name,
    String desc,
    String priority,
  ) async {
    xDutyAssignUpdate = true;
    update();
    try {
      http.Response? response = await Network().createDutyAssign(
        name,
        desc,
        priority,
        date,
      );
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        dutyNameController.clear();
        dutyDescController.clear();
        selectedPriority = {"data": "low", "name": "Low", "color": Colors.grey};
        getDutyAssign(date);
        showAlert("Success");
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xDutyAssignUpdate = false;
    update();
  }

  Future<void> updateDutyAssign(
    int id,
    String name,
    String desc,
    String priority,
    String date,
  ) async {
    xDutyAssignUpdate = true;
    update();
    try {
      http.Response? response = await Network().updateDutyAssign(
        id,
        name,
        desc,
        priority,
      );
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        dutyNameController.clear();
        dutyDescController.clear();
        selectedPriority = {"data": "low", "name": "Low", "color": Colors.grey};
        getDutyAssign(date);
        showAlert("Success");
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xDutyAssignUpdate = false;
    update();
  }

  Future<void> deleteDutyAssign(int id, String date) async {
    xDutyAssignUpdate = true;
    update();
    try {
      http.Response? response = await Network().deleteDutyAssign(id);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        getDutyAssign(date);
        showAlert("Success");
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xDutyAssignUpdate = false;
    update();
  }

  Future<void> subDuty(int id, String name, String desc, String date) async {
    xDuty = true;
    update();
    try {
      http.Response? response = await Network().subDuty(id, name, desc);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        subNameController.clear();
        subDescController.clear();
        duties(date);
        showAlert("Success");
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xDuty = false;
    update();
  }

  Future<void> reasonDuty(int id, String reason, String date) async {
    xDuty = true;
    update();
    try {
      http.Response? response = await Network().reasonDuty(id, reason);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        subReasonController.clear();
        duties(date);
        showAlert("Success");
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xDuty = false;
    update();
  }

  bool checkAction(String date) {
    if (DateTime.parse(date).isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }
}
