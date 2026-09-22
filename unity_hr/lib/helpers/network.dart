import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_hr/controllers/login_controller.dart';
import 'package:unity_hr/controllers/navbar_controller.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/user.dart';
import 'package:unity_hr/views/screens/login_screen.dart';

void validateLogout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userInfo = UserInfo(
    employeeID: '',
    name: '',
    email: '',
    userName: '',
    branch: Branch(id: '', branchName: ''),
    department: Department(id: '', departmentName: ''),
    gender: '',
    image: '',
    position: '',
    joinedDate: '',
    dob: '',
    phone: '',
    address: '',
    employeeType: '',
  );
  apiToken = '';
  Get.find<NavBarController>().currentIndex = 0;
  Get.find<LoginController>().txtEmailController.clear();
  Get.find<LoginController>().txtPasswordController.clear();
  prefs.remove('login');
  prefs.remove('isApproval');
  superPrint(apiToken, title: 'Logout Token');
  Get.offAll(() => const LoginScreen());
}

class Network {
  //login
  Future<http.Response?> login(
    String name,
    String password,
    String deviceName,
    String deviceModel,
    String deviceId,
    String deviceImei,
  ) async {
    superPrint(baseURL);

    var data = {
      'username': name,
      'password': password,
      'device_name': deviceName,
      'device_model': deviceModel,
      'device_id': deviceId,
      'device_imei': deviceImei,
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/login"),
        body: data,
        headers: {'Accept': 'application/json'},
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //logout
  Future<http.Response?> setPlayerId(String playerId) async {
    var data = {'player_id': playerId};
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/users/set-player-id"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  // create Password
  Future<http.Response?> password(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    superPrint(oldPassword);
    superPrint(newPassword);
    var data = {
      'current_password': oldPassword,
      'new_password': newPassword,
      'new_confirm_password': confirmPassword,
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/update-password"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //logout
  Future<http.Response?> logout() async {
    superPrint(apiToken, title: "logout");
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/logout"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Token Refresh
  Future<http.Response?> tokenRefresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken = prefs.getString('login') ?? '';
    //superPrint("==>${baseURL}api/v1/refresh");

    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/refresh"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint('refresh token failed $e');
    }
    return response;
  }

  //Profile Data
  Future<http.Response?> getProfile() async {
    //superPrint("get profile ==>${baseURL}api/v1/profile");
    http.Response? response;
    try {
      //superPrint("Token==>$apiToken");
      response = await http.get(
        Uri.parse("${baseURL}api/v1/profile"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Home
  Future<http.Response?> getHomeReport() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/home"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Sub Home Count
  Future<http.Response?> getHomeAttendanceCount() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse(
          "${baseURL}api/v1/subordination-home?date=${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
      debugPrint("response-------${response.body}");
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //All Holiday
  Future<http.Response?> getAllHoliday() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/holidays"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getAllBirthdays() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/birthdays"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getAllWorkingAnniversary() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/working_anniversary"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Check in request
  Future<http.Response?> getAllCheckInRequest() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/subordination-checkin-requests"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Check out request
  Future<http.Response?> getAllCheckOutRequest() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/subordination-checkout-requests"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //View All My Attendance
  Future<http.Response?> getAllMyAttendance(String year, String month) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/attendances?month=$year-$month"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //year
  Future<http.Response?> getYear() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/years"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Welfare
  Future<http.Response?> getAllWelfare() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/welfares"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Asset
  Future<http.Response?> getAllAssets() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/assets"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Training
  Future<http.Response?> getAllTraining() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/trainings"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Promotions
  Future<http.Response?> getAllPromotions() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/promotions"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Transfer
  Future<http.Response?> getAllTransfers() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/transfers"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Resignations
  Future<http.Response?> getAllResignations() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/resignations"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Order
  Future<http.Response?> getAllOrders() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/orders"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Warning
  Future<http.Response?> getAllWarning() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/warnings"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Increment
  Future<http.Response?> getAllIncrement() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/increments"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Increment
  Future<http.Response?> getOtherInformation(String id) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/employees/$id/other_information"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Payslip or payroll
  Future<http.Response?> getPaySlip(String year, String month) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/payslips?month=$year-$month"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Over Time Request List
  Future<http.Response?> getOTRequest() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/subordination-overtime-requests"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Request Person
  Future<http.Response?> getAllRequestPerson() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/request-to-persons"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Resign Request Person
  Future<http.Response?> getAllResignRequestPerson() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/all-resignation-requests"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Reform Person
  Future<http.Response?> getAllReformPerson() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/inform-to-persons"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Request History
  Future<http.Response?> getAllOutpassRequestHistory() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/outpass-requests-list"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Leave Type api
  Future<http.Response?> getAllLeaveType() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/my-leaves"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Leave Types With Employee ID
  Future<http.Response?> getLeaveTypeByEmployeeID(String empId) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/my-leaves?employee_id=$empId"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //post leave form
  Future<http.Response?> leaveFormRequest(
    String leaveID,
    String startDate,
    String endDate,
    String leaveRequestType,
    List<String> requestPersonList,
    List<String> reformPersonList,
    String reason,
    List<String> imageList,
  ) async {
    var data = {
      "employee_id": userInfo.employeeID,
      "leave_type_id": leaveID,
      "date_from": startDate,
      "date_to": endDate,
      "duration": leaveRequestType,
      "request_to": requestPersonList,
      "inform_to": reformPersonList,
      "reason": reason,
      "leave_images": imageList,
    };
    superPrint("leave request body $data");
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/leave-request"),
        body: json.encode(data),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> editleaveFormRequest(
    String leaveID,
    String leaveTypeID,
    String startDate,
    String endDate,
    String leaveRequestType,
    List<String> requestPersonList,
    List<String> reformPersonList,
    String reason,
    List<String> leaveImages,
  ) async {
    superPrint(userInfo.employeeID, title: "Employee ID");
    superPrint(leaveTypeID, title: "Leave");
    superPrint(startDate, title: "from");
    superPrint(endDate, title: "to");
    superPrint(requestPersonList, title: "Request");
    superPrint(reformPersonList, title: "Reform");
    superPrint(leaveRequestType, title: "Leave request");
    superPrint(reason, title: "Reason");
    var data = {
      "employee_id": userInfo.employeeID,
      "leave_type_id": leaveTypeID,
      "date_from": startDate,
      "date_to": endDate,
      "duration": leaveRequestType,
      "request_to": requestPersonList,
      "inform_to": reformPersonList,
      "reason": reason,
      "leave_images": leaveImages,
    };
    http.Response? response;
    try {
      response = await http.put(
        Uri.parse("${baseURL}api/v1/leave-request/$leaveID/update"),
        body: json.encode(data),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Leave List History
  Future<http.Response?> getLeaveHistory(
    String startDate,
    String endDate,
  ) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse(
          "${baseURL}api/v1/all-leave-requests?date_from=$startDate&date_to=$endDate",
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //post OT form
  Future<http.Response?> otFormRequest(
    String date,
    String timeFrom,
    String timeTo,
    List<String> requestPersonList,
    List<String> reformPersonList,
    String reason,
    String siteId,
    String workOrderId,
  ) async {
    superPrint(userInfo.employeeID, title: "Employee ID");
    superPrint(date, title: "Leave");
    superPrint(timeFrom, title: "from");
    superPrint(timeTo, title: "to");
    superPrint(requestPersonList, title: "Request");
    superPrint(reformPersonList, title: "Reform");
    superPrint(reason, title: "Reason");
    var data = {
      "employee_id": userInfo.employeeID,
      "date": date,
      "time_from": timeFrom,
      "time_to": timeTo,
      "request_to": requestPersonList,
      "inform_to": reformPersonList,
      "reason": reason,
      "site_id": siteId,
      "work_order_id": workOrderId,
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/overtime-request"),
        body: json.encode(data),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //request outpass
  Future<http.Response?> outPassRequest(
    String date,
    String toDate,
    String formType,
    List orderType,
    String timeFrom,
    String timeTo,
    List<String> requestPersonList,
    List<String> reformPersonList,
    String reason,
  ) async {
    var data = {
      "employee_id": userInfo.employeeID,
      "date": date,
      "date_from": date,
      "date_to": toDate,
      "form_type": formType,
      "expense": orderType,
      if (formType != 'Movement Order Form' ||
          formType != 'Travel Request Form')
        "time_from": timeFrom,
      if (formType != 'Movement Order Form' ||
          formType != 'Travel Request Form')
        "time_to": timeTo,
      "request_to": requestPersonList,
      "inform_to": reformPersonList,
      "reason": reason,
    };
    http.Response? response;
    try {
      superPrint('data here ${json.encode(data)}');
      response = await http.post(
        Uri.parse("${baseURL}api/v1/outpass-request"),
        body: json.encode(data),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //edit outpass
  Future<http.Response?> editOutPassRequest(
    String id,
    String date,
    String toDate,
    String formType,
    List orderType,
    String timeFrom,
    String timeTo,
    List<String> requestPersonList,
    List<String> reformPersonList,
    String reason,
  ) async {
    var data = {
      "id": id,
      "employee_id": userInfo.employeeID,
      "date": date,
      "date_from": date,
      "date_to": toDate,
      "form_type": formType,
      "expense": orderType,
      if (formType != 'Movement Order Form' ||
          formType != 'Travel Request Form')
        "time_from": timeFrom,
      if (formType != 'Movement Order Form' ||
          formType != 'Travel Request Form')
        "time_to": timeTo,
      "request_to": requestPersonList,
      "inform_to": reformPersonList,
      "reason": reason,
    };
    http.Response? response;
    try {
      superPrint('data here ${json.encode(data)}');
      response = await http.post(
        Uri.parse("${baseURL}api/v1/outpass-request/$id/update"),
        body: json.encode(data),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //delate outpass
  Future<http.Response?> deleteOutPassRequest(String id) async {
    var data = {"id": id};
    http.Response? response;
    try {
      superPrint('data here ${json.encode(data)}');
      response = await http.post(
        Uri.parse("${baseURL}api/v1/delete-outpass-request"),
        body: json.encode(data),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //fetch all overtime
  Future<http.Response?> getOverTimeHistory(String date) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/all-overtime-requests?month=$date"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //fetch all outpass
  Future<http.Response?> getOutPassHistory(String date) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/all-outpass-requests?month=$date"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //fetch ovettime by id
  Future<http.Response?> getOverTimeHistoryByID(String outpassId) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/overtime-request/$outpassId/show"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //fetch outpass by id
  Future<http.Response?> getOutPassHistoryByID(String otID) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/outpass-request/$otID/show"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Leave Request Detail Employee
  Future<http.Response?> getEmployeeLeaveDetailByID(String leaveID) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/leave-request/$leaveID/show"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Employee List
  Future<http.Response?> getAllEmployeeList() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/employees"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Notification
  Future<http.Response?> getAllNotification() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/notifications"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Read Noti
  Future<http.Response?> readNoti(String notiID) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/notifications/$notiID/read"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Resign Request
  Future<http.Response?> resignFormRequest(
    String subject,
    String date,
    List<String> requestPersonList,
    List<String> reformPersonList,
    String reason,
    String emergency,
    List<String> imageList,
  ) async {
    var data = {
      "employee_id": userInfo.employeeID,
      "subject": subject,
      "date": date,
      "request_to": requestPersonList,
      "inform_to": reformPersonList,
      "reason": reason,
      "emergency": emergency,
      "resign_images": imageList,
    };
    superPrint('resign request body $data');
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/resignation-request"),
        body: json.encode(data),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> updateResignFormRequest(
    String subject,
    String date,
    List<String> requestPersonList,
    List<String> reformPersonList,
    String reason,
    String emergency,
    List<String> imageList,
    String id,
  ) async {
    var data = {
      "employee_id": userInfo.employeeID,
      "subject": subject,
      "date": date,
      "request_to": requestPersonList,
      "inform_to": reformPersonList,
      "reason": reason,
      "emergency": emergency,
      "resign_images": imageList,
    };
    superPrint('resign request body $data');
    http.Response? response;
    superPrint('---> $id', title: "iddd");
    try {
      response = await http.put(
        Uri.parse("${baseURL}api/v1/resignation-request/$id/update"),
        body: json.encode(data),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Approval Person Leave View
  Future<http.Response?> getLeaveRequest() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/subordination-leave-requests"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Resign Request
  Future<http.Response?> getResignRequest() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/subordination-resignation-requests"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //fetch resign by id
  Future<http.Response?> getResignByID(String resignID) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/resignation-request/$resignID/show"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //My team leave history
  Future<http.Response?> searchLeaveRequestHistory(
    String startDate,
    String endDate,
    String status,
  ) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse(
          "${baseURL}api/v1/all-subordination-leave-requests?date_from=$startDate&date_to=$endDate&status=$status",
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //My Team OT History
  Future<http.Response?> searchOverTimeRequestHistory(
    String startDate,
    String endDate,
    String status,
  ) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse(
          "${baseURL}api/v1/all-subordination-overtime-requests?date_from=$startDate&date_to=$endDate&status=$status",
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //leave approve reject
  Future<http.Response?> approveRejectLeaveRequest(
    String approval,
    String reject,
    String remark,
    String id,
    String leaveTypeID,
  ) async {
    superPrint(approval, title: "Approval Status");
    superPrint(reject, title: "Rejection Status");
    superPrint(remark, title: "Remark");
    var data = {
      "is_approval": approval,
      "is_rejection": reject,
      "remark": remark,
      'leave_type_id': leaveTypeID,
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/leave-request/$id/approve-reject"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          // 'Content-type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Approval Reject OverTime
  Future<http.Response?> approveRejectOverTimeRequest(
    String approval,
    String reject,
    String remark,
    String id,
    String timeFrom,
    String timeTo,
  ) async {
    superPrint(approval, title: "Approval Status");
    superPrint(reject, title: "Rejection Status");
    superPrint(remark, title: "Remark");
    var data = {
      "is_approval": approval,
      "is_rejection": reject,
      "remark": remark,
      "time_from": timeFrom,
      "time_to": timeTo,
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/overtime-request/$id/approve-reject"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          // 'Content-type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Approval Reject Resign
  Future<http.Response?> approveRejectResignRequest(
    String approval,
    String reject,
    String remark,
    String id,
  ) async {
    superPrint(approval, title: "Approval Status");
    superPrint(reject, title: "Rejection Status");
    superPrint(remark, title: "Remark");
    var data = {
      "is_approval": approval,
      "is_rejection": reject,
      "remark": remark,
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/resignation-request/$id/approve-reject"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          // 'Content-type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Approval Reject Outpass
  Future<http.Response?> approveRejectOutpassRequest(
    String approval,
    String reject,
    String remark,
    String id,
  ) async {
    var data = {
      "is_approval": approval,
      "is_rejection": reject,
      "remark": remark,
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/outpass-request/$id/approve-reject"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          // 'Content-type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //View All Resign Request History
  Future<http.Response?> getAllResignRequestHistory(
    String year,
    String month,
  ) async {
    http.Response? response;
    superPrint('base url $baseURL');
    try {
      response = await http.get(
        Uri.parse(
          "${baseURL}api/v1/all-subordination-resignation-requests?month=$month&year=$year",
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  // Approval Reject Check in request
  Future<http.Response?> approveRejectCheckInRequest(
    String approval,
    String reject,
    String remark,
    String id,
  ) async {
    superPrint(approval, title: "Approval Status");
    superPrint(reject, title: "Rejection Status");
    superPrint(remark, title: "Remark");
    var data = {
      "is_approval": approval,
      "is_rejection": reject,
      "remark": remark,
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse(
          "${baseURL}api/v1/subordination-checkin-requests/$id/confirm",
        ),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  // Approval Reject Check out request
  Future<http.Response?> approveRejectCheckOutRequest(
    String approval,
    String reject,
    String remark,
    String id,
  ) async {
    superPrint(approval, title: "Approval Status");
    superPrint(reject, title: "Rejection Status");
    superPrint(remark, title: "Remark");
    var data = {
      "is_approval": approval,
      "is_rejection": reject,
      "remark": remark,
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse(
          "${baseURL}api/v1/subordination-checkout-requests/$id/confirm",
        ),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Forgot Password
  Future<http.Response?> email(String email) async {
    superPrint(email);
    var data = {'email': email};
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/forgot-password"),
        body: data,
        headers: {'Accept': 'application/json'},
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> forgotPs(
    String otp,
    String newPs,
    String confirmPs,
  ) async {
    superPrint(otp, title: "OTP");
    superPrint(newPs, title: "New Password");
    superPrint(confirmPs, title: "Confrim Password");
    var data = {
      'code': otp,
      'password': newPs,
      'password_confirmation': confirmPs,
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/reset-password"),
        body: data,
        headers: {'Accept': 'application/json'},
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //meeting list
  Future<http.Response?> getAllMeeting() async {
    http.Response? response;

    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/meetings"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //get meeting by id
  Future<http.Response?> getMeetingsByID(String id) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/meetings/$id/show"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  // Check GPS
  Future<http.Response?> checkGPS(String lat, String lng) async {
    http.Response? response;
    var data = {'latitude': lat, 'longitude': lng};
    //superPrint(data);
    try {
      response = await http.post(
        Uri.parse(
          "${baseURL}api/v1/attendances/get-gps-radius/${userInfo.employeeID}",
        ),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Get Branch Location
  Future<http.Response?> getBranchLocation() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/get_branch_location"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Get Check In Out Policies
  Future<http.Response?> getCheckInOutPolicies() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/check_in_out_policies"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Get Camera Settings
  Future<http.Response?> getCameraSettings() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/camera_settings"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Check Wifi BSSID
  Future<http.Response?> checkWifiBSSID(String bssid) async {
    http.Response? response;
    var data = {"bssid": bssid};
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/check_wifi_bssid"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Wifi Check In/Out
  Future<http.Response?> wifiCheckInOut(
    String checkIn,
    String checkOut,
    String bssid,
  ) async {
    http.Response? response;
    var data = {'is_checkin': checkIn, 'is_checkout': checkOut, 'bssid': bssid};
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/check_in_out/wifi"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //QR Check In/Out
  Future<http.Response?> qrCheckInOut(
    String checkIn,
    String checkOut,
    String secretCode,
    String bssid,
    String type,
  ) async {
    http.Response? response;
    var data = {
      'is_checkin': checkIn,
      'is_checkout': checkOut,
      'secret_code': secretCode,
      'bssid': bssid,
      'type': type,
    };
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/check_in_out/qr-code"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Remote Check In
  Future<http.Response?> remoteCheckIn(
    String checkIn,
    String checkOut,
    String lat,
    String lng,
    String radius,
    String isRemote,
    String description,
    String address,
    Uint8List attImage,
    String lateReason,
  ) async {
    http.Response? response;
    var data = {
      'is_checkin': checkIn,
      'is_checkout': checkOut,
      'latitude': lat,
      'longitude': lng,
      'radius': radius,
      'is_remote': isRemote,
      'description': description,
      'address': address,
      "att_image": attImage.isEmpty ? "" : base64Encode(attImage),
      "late_reason": lateReason,
    };
    superPrint('check in request body $data');
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/check_in_out"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //get all companies
  static Future<http.Response?> companies() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("https://cityhr.com.mm/api/v1/companies"),
        // Uri.parse(localBaseURL+"api/v1/companies"),
        headers: {'Accept': 'application/json'},
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Get Probation Assessment Score By ID
  Future<http.Response?> getProbationById(String id) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/probation-assessments/$id"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Get Probation Assessment Result
  Future<http.Response?> calculateResult(
    Map<String, dynamic> scores,
    String id,
  ) async {
    var data = {"scores": scores};
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse(
          "${baseURL}api/v1/probation-assessments/$id/calculate-result",
        ),
        body: jsonEncode(data),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> updateAssessmentScore(
    Map<String, dynamic> scores,
    String id,
    double resultPercentage,
    List<int> approvals,
  ) async {
    var data = {
      "result_percentage": resultPercentage,
      "scores": scores,
      "approvers": approvals,
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/probation-assessments/$id/update"),
        body: jsonEncode(data),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Get Probation Assessment Result
  Future<http.Response?> approveRejectProbation(
    String id,
    String status,
    bool sendToEmp,
  ) async {
    var data = {"status": status, "send_to_employee": sendToEmp ? '1' : '0'};
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/probation-assessments/$id/approve-reject"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Get Duty
  Future<http.Response?> duties(String date) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/duty/$date"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> employeeDuties(String date, String empId) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/duty/$date/$empId"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Get Duty By ID
  Future<http.Response?> getDutyByID(int id) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/duty/$id/show"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Update Duty
  Future<http.Response?> updateDuty(int id, String status, var image) async {
    var data = {
      "id": id.toString(),
      "status": status,
      'img': base64Encode(image),
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/duty/update"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> extendDuty(int id, String reason, int days) async {
    var data = {
      "id": id.toString(),
      "reason": reason,
      "extend_days": days.toString(),
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/duty/extend"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Get Training Surveys
  Future<http.Response?> surveyList() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/survey"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Get Training Surveys Details
  Future<http.Response?> surveyDetails(int id) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/survey/$id"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> updateAnswer(dynamic answer) async {
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/survey"),
        body: answer,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> createDutyAssign(
    String name,
    String desc,
    String priority,
    String date,
  ) async {
    var data = {"name": name, "desc": desc, "priority": priority, "date": date};
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/duty/add_duty"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> updateDutyAssign(
    int id,
    String name,
    String desc,
    String priority,
  ) async {
    var data = {
      "id": id.toString(),
      "name": name,
      "desc": desc,
      "priority": priority,
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/duty/update_duty"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> deleteDutyAssign(int id) async {
    var data = {"id": id.toString()};
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/delete_duty_task"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getDutyAssign(String date) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/duty_assign/get_duty/$date"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> subDuty(int id, String name, String desc) async {
    var data = {"id": id.toString(), "sub_name": name, "sub_description": desc};
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/duty/sub_duty"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> reasonDuty(int id, String reason) async {
    var data = {"id": id.toString(), "sub_reason": reason};
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/duty/reason_duty"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getDutyType() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/duty_type"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getBranches() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/branches"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getDepartments(String branchId) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/departments/$branchId"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getPositions() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/positions"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getEmployees(String positionId) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/employees_by_position/$positionId"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getFilterEmployees(
    String branchId,
    String departmentId,
  ) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse(
          "${baseURL}api/v1/employees_by_department_and_branch/$branchId/$departmentId",
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getPerformanceTasksByPosition(
    String positionId,
  ) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/performance_tasks_by_position/$positionId"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getPerformanceTasksByPmId(int pmId) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/performance_tasks_by_pm_id/$pmId"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> postDutyAssign(Map<String, dynamic> body) async {
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/duty/assign_duty"),
        body: jsonEncode(body),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> updateHodDutyAssign(
    String id,
    Map<String, dynamic> body,
  ) async {
    http.Response? response;
    try {
      response = await http.put(
        Uri.parse("${baseURL}api/v1/update_hod_duty_assign/$id"),
        body: jsonEncode(body),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> deleteHodDutyAssign(String id) async {
    http.Response? response;
    try {
      response = await http.delete(
        Uri.parse("${baseURL}api/v1/delete_hod_duty_assign/$id"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getHodDutyAssignList({
    required String branchId,
    required String departmentId,
    required String employeeId,
    required String dutyId,
    int page = 1,
  }) async {
    // Construct query parameters matching your PHP $filters keys
    final queryParameters = {
      'branch_id': branchId,
      'department_id': departmentId,
      'employee_id': employeeId,
      'duty_id': dutyId,
      'page': page.toString(),
    };

    // Create the URI with query params
    final uri = Uri.parse(
      "${baseURL}api/v1/hod_assign_duty_list",
    ).replace(queryParameters: queryParameters);

    try {
      return await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint("Network Error: $e");
      return null;
    }
  }

  Future<http.Response?> getHodDutyEmployeeList({
    required String branchId,
    required String departmentId,
    required String employeeId,
    required String dutyId,
    int page = 1,
  }) async {
    final queryParameters = {
      'branch_id': branchId,
      'department_id': departmentId,
      'employee_id': employeeId,
      'duty_id': dutyId,
      'page': page.toString(),
    };

    final uri = Uri.parse(
      "${baseURL}api/v1/duty/hod_assign_duty_employee_list",
    ).replace(queryParameters: queryParameters);

    try {
      return await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint("Network Error: $e");
      return null;
    }
  }

  Future<http.Response?> getHodAssignDutyEmpDetail(
    String id, {
    int page = 1,
  }) async {
    final queryParameters = {'page': page.toString()};

    http.Response? response;
    try {
      response = await http.get(
        Uri.parse(
          "${baseURL}api/v1/duty/hod_assign_duty_employee_detail/$id",
        ).replace(queryParameters: queryParameters),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getHodDutyAssignDetails(String id) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/hod_assign_duty_detail/$id"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getDutyApproveRejectList() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/duty/approve_reject_list"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getDutyApproveRejectHistoryList(String date) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/duty_approve_reject_history_list/$date"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> dutyAssignApproveRejectRequest(
    String id,
    String requestType,
    String isApproval,
    String isRejection,
    String? remark,
  ) async {
    var data = {
      "id": id,
      "request_type": requestType,
      "is_approval": isApproval,
      "is_rejection": isRejection,
      "remark": remark,
    };
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/duty/approve_reject"),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getDailyDutyRequestList({
    required String branchId,
    required String departmentId,
    required String employeeId,
    required String date,
    int page = 1,
  }) async {
    // Construct query parameters matching your PHP $filters keys
    final queryParameters = {
      'branch_id': branchId,
      'department_id': departmentId,
      'employee_id': employeeId,
      'date': date,
      'page': page.toString(),
    };

    // Create the URI with query params
    final uri = Uri.parse(
      "${baseURL}api/v1/daily_duty_request_list",
    ).replace(queryParameters: queryParameters);

    try {
      return await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint("Network Error: $e");
      return null;
    }
  }

  Future<http.Response?> getDailyDutyRequestDetails(
    String id,
    String date,
  ) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/daily_duty_request_details/$id/$date"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> getWorkDoneList({required String date}) async {
    final uri = Uri.parse("${baseURL}api/v1/duty/workdone_employee_list/$date");

    try {
      return await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint("Network Error: $e");
      return null;
    }
  }

  Future<http.Response?> getWorkDoneTaskList(String id, String date) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/duty/workdone_task_list/$id/$date"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  Future<http.Response?> dailyDutyApproveReject(
    String id,
    String status,
    String remark,
    int percentage,
  ) async {
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse("${baseURL}api/v1/daily_duty_request_approve_reject/$id"),
        body: {
          'status': status,
          'remark': remark,
          'percentage': percentage.toString(),
        },
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Get Policy Book List
  Future<http.Response?> policyBookList() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/policy-books"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }

  //Get Policy Book Detail
  Future<http.Response?> policyBookDetail(String id) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse("${baseURL}api/v1/policy-books/$id"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      superPrint(e.toString());
    }
    return response;
  }
}
