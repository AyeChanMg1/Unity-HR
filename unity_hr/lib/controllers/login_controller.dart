import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_hr/controllers/navbar_controller.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/company.dart';
import 'package:unity_hr/models/user.dart';
import 'package:unity_hr/views/screens/first_screen.dart';
import 'package:unity_hr/views/screens/login_screen.dart';
import 'package:uuid/uuid.dart';

class LoginController extends GetxController {
  TextEditingController txtPasswordController = TextEditingController();
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtselectcompanyController = TextEditingController();

  TextEditingController txtOldPassword = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  bool xLogin = false;
  bool xLogout = false;
  bool xVisible = true;
  bool xUpdate = false;
  bool xOldPs = false;
  bool xNewPs = false;
  bool xConfirmPs = false;

  String deviceId = "";
  String deviceImei = "";
  String deviceName = "";
  String deviceModel = "";

  bool showModal = false;

  List<Company> companyList = [];

  void toggleVisiblity() {
    xVisible = !xVisible;
    update();
  }

  void oldPsVisiblity() {
    xOldPs = !xOldPs;
    update();
  }

  void newPsVisiblity() {
    xNewPs = !xNewPs;
    update();
  }

  void confirmPsVisiblity() {
    xConfirmPs = !xConfirmPs;
    update();
  }

  void changePasswordClear() {
    txtOldPassword.clear();
    txtNewPassword.clear();
    txtConfirmPassword.clear();
  }

  void changeButtonColor(String value, String title) {
    if (title == 'Old Password') {
      txtOldPassword.text.isNotEmpty;
    } else if (title == 'New Password') {
      txtNewPassword.text.isNotEmpty;
    } else {
      txtConfirmPassword.text.isNotEmpty;
    }
    update();
  }

  Future<void> login() async {
    xLogin = true;
    update();
    http.Response? response = await Network().login(
      txtEmailController.text.trim(),
      txtPasswordController.text..trim(),
      deviceName,
      deviceModel,
      deviceId,
      deviceImei,
    );
    superPrint(response?.statusCode, title: 'login');
    tooManyRequest(response?.statusCode ?? 429);
    if (response?.statusCode == 200 || response?.statusCode == 201) {
      var result = jsonDecode(response!.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      apiToken = result['data']['token'];
      isApprovalPerson = result['data']['is_approval_person'].toString();
      prefs.setString('login', apiToken);
      prefs.setString('isApproval', isApprovalPerson);
      superPrint(prefs.getString('login'), title: 'Login or Not');
      Get.offAll(() => const FirstScreen());
      await Future.delayed(const Duration(seconds: 1));
      Fluttertoast.showToast(
        msg: "You have successfully \n logged in.",
        backgroundColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    } else if (response?.statusCode == 401) {
      Get.back();
      var result = jsonDecode(response!.body);
      debugPrint("result----$result");
      showAlert(result['response']['message'].toString());
    } else if (response?.statusCode != 429) {
      Get.back();
      showAlert("Username and password is invalid! ");
    }
    xLogin = false;
    update();
  }

  Future<void> setPlayerId() async {
    //String playerId = await OneSignal.User.pushSubscription.getPlayerId();
    String playerId = '';
    http.Response? response = await Network().setPlayerId(playerId);
    if (response!.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Set Player ID Successfully.",
        backgroundColor: Colors.white,
        toastLength: Toast.LENGTH_LONG, //duration for message to show
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Failed To Set Player ID.",
        backgroundColor: Colors.white,
        toastLength: Toast.LENGTH_LONG, //duration for message to show
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.red,
        fontSize: 16.0,
      );
    }
  }

  Future<void> logout() async {
    xLogout = true;
    update();
    http.Response? response = await Network().logout();
    superPrint(response?.statusCode, title: 'logout');
    var result = jsonDecode(response!.body);
    superPrint(result);
    if (response.statusCode == 200 || response.statusCode == 201) {
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
      companyName?.name = '';
      apiToken = '';
      Get.find<NavBarController>().currentIndex = 0;
      txtEmailController.clear();
      txtPasswordController.clear();
      prefs.remove('login');
      prefs.remove('isApproval');
      superPrint(apiToken, title: 'Logout Token');
      Get.offAll(() => const LoginScreen());
      update();
    } else if (response.statusCode == 400) {
      showAlert(response.body);
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(jsonDecode(response.body)['response']['message']);
    }
    xLogout = false;
    update();
  }

  Future<void> refreshToken() async {
    http.Response? response = await Network().tokenRefresh();
    //superPrint(response?.statusCode, title: 'refresh token');
    if (response?.statusCode == 200 || response?.statusCode == 201) {
      var result = jsonDecode(response!.body);
      superPrint(result, title: 'refresh token response');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      apiToken = result['data']['token'];
      prefs.setString('login', apiToken);
      apiToken = prefs.getString('login') ?? '';
      update();
      //superPrint(prefs.getString('login'), title: 'Token Refresh');
    } else if (response?.statusCode == 401) {
      apiToken = '';
      Get.offAll(() => const LoginScreen());
    } else {
      //showAlert(response!.body.toString());
    }
    update();
  }

  Future<void> updatePassword() async {
    xUpdate = true;
    update();
    http.Response? response = await Network().password(
      txtOldPassword.text,
      txtNewPassword.text,
      txtConfirmPassword.text,
    );
    tooManyRequest(response?.statusCode ?? 429);

    if (response?.statusCode == 200 || response?.statusCode == 201) {
      Get.back();
      showSuccessAlert("Success", () {
        Get.back();
        Get.back();
      });
    } else if (response?.statusCode == 400) {
      if (jsonDecode(
            response!.body,
          )['response']['message']['current_password'][0] ==
          'The current password does not match with the old password.') {
        showAlert("The current password does not match with the old password");
      } else {
        showAlert(response.body);
      }
    }
    xUpdate = false;
    update();
  }

  //Check Sever
  Future<bool> checkServerTooManyRequset() async {
    try {
      http.Response response = await http.get(
        Uri.parse("${baseURL}api/v1/profile"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
      superPrint(
        response.statusCode,
        title: 'Check Server Too Many Request Status Code',
      );
      if (response.statusCode == 429) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      superPrint(e.toString(), title: 'Catch of Check Server Too Many Request');
      return false;
    }
  }

  Future<void> getCompanies() async {
    companyList.clear();
    update();
    http.Response? response = await Network.companies();
    superPrint(response?.statusCode, title: 'Companies');
    if (response?.statusCode == 200 || response?.statusCode == 201) {
      var result = jsonDecode(response!.body);
      Iterable list = result['data'];
      for (var data in list) {
        companyList.add(Company.formJson(data));
      }
      companyName = companyList.first;
      update();
    } else {
      showAlert(response!.body.toString());
    }
    update();
  }

  Future<void> updateCompanyName(Company data) async {
    companyName = data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('company', jsonEncode(data.toJson()));
    if (kDebugMode) {
      baseURL = 'https://${companyName?.domain}.cityhr.com.mm/';
    } else {
      baseURL = 'https://${companyName?.domain}.cityhr.com.mm/';
    }
    superPrint(prefs.getString('company'), title: 'Compnay');
    showModal = false;
    update();
  }

  Future<void> getDeviceInformation() async {
    if (Platform.isIOS) {
      try {
        //deviceId = (await UniqueIdentifier.serial)!;
        DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
        String? deviceUUID = await getDeviceIdOrUUID(); // get Device UUID
        deviceId = deviceUUID;
        deviceImei = iosDeviceInfo.identifierForVendor!;
        deviceName = iosDeviceInfo.name;
        deviceModel = iosDeviceInfo.model;
        update();
      } on PlatformException {
        Fluttertoast.showToast(msg: 'Fail to get Device ID');
      }
    } else {
      try {
        final deviceInfoPlugin = DeviceInfoPlugin();
        final androidInfo = await deviceInfoPlugin.androidInfo;
        String? deviceUUID = await getDeviceIdOrUUID();
        deviceId = deviceUUID;
        deviceImei = deviceUUID;
        deviceModel = androidInfo.model;
        deviceName = androidInfo.device;
        update();
      } on PlatformException {
        Fluttertoast.showToast(msg: 'Fail to get Device ID');
      }
    }
  }

  Future<String> getDeviceIdOrUUID() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await prefs.setString('device_id', deviceId);
    }
    return deviceId;
  }
}
