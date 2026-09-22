import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'dashboard_controller.dart';

class PoliciesCheckInOutController extends GetxController {
  bool isPoliciesLoading = false;
  String checkInOutMethod = "";
  List policies = [];
  bool isCameraSettingLoading = false;
  List cameraSettings = [];
  String wifiName = "";
  String wifiBSSID = "";
  bool isWifiAvailable = false;
  bool isOnSite = false;
  //late QRViewController qrViewController;
  String qrCode = "";
  bool flash = false;

  //fetch all check in out policies
  Future<void> fetchAllPolicies() async {
    isPoliciesLoading = true;
    policies.clear();
    update();
    http.Response? response = await Network().getCheckInOutPolicies();
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var i in iterable) {
        String data = i['type'];
        policies.add(data);
      }
      if (checkInOutMethod == '') {
        checkInOutMethod = policies.first;
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      // showAlert(response.body);
    }
    isPoliciesLoading = false;
    update();
  }

  //fetch all camera settings
  Future<void> fetchCameraSettings() async {
    isCameraSettingLoading = true;
    cameraSettings.clear();
    update();
    http.Response? response = await Network().getCameraSettings();
    var result = jsonDecode(response!.body);
    //superPrint('camera setting $result');
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var i in iterable) {
        String data = i['type'];
        cameraSettings.add(data.toLowerCase().removeAllWhitespace);
      }
      superPrint('camerasetting $cameraSettings');
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      // showAlert(response.body);
    }
    isCameraSettingLoading = false;
    update();
  }

  //check wifi bssid
  Future<void> checkWifiBSSID(String bssid) async {
    isWifiAvailable = false;
    update();
    http.Response? response = await Network().checkWifiBSSID(bssid);
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (result['status'] == true) {
        isWifiAvailable = true;
      } else {
        isWifiAvailable = false;
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      // showAlert(response.body);
    }
    update();
  }

  //check in out with wifi bssid
  Future<void> sendOnSiteCheckIn(
    String checkin,
    String checkout,
    String bssid,
  ) async {
    isOnSite = true;
    update();
    http.Response? response = await Network().wifiCheckInOut(
      checkin,
      checkout,
      bssid,
    );
    var result = jsonDecode(response!.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.find<DashboardController>().fetchHomeReport();
      Get.find<PoliciesCheckInOutController>().checkWifiBSSID(bssid);
      if (checkin == '1') {
        showAlert(result['response']['message']);
      } else {
        showAlert(result['message']);
      }
      update();
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['response']['message']);
    }
    isOnSite = false;
    update();
  }

  //check in out with qr and qrwithbssid
  Future<void> sendOnSiteQRCheckIn(
    String checkin,
    String checkout,
    String secretCode,
    String bssid,
    String type,
  ) async {
    isOnSite = true;
    update();
    http.Response? response = await Network().qrCheckInOut(
      checkin,
      checkout,
      secretCode,
      bssid,
      type,
    );
    var result = jsonDecode(response!.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.find<DashboardController>().fetchHomeReport();
      Get.find<PoliciesCheckInOutController>().checkWifiBSSID(bssid);
      if (checkin == '1') {
        showAlert(result['response']['message']);
      } else {
        showAlert(result['message']);
      }
      Get.find<PoliciesCheckInOutController>().fetchAllPolicies();
      // Get.offAll(() => const HomeScreen());
      update();
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['response']['message']);
    }
    isOnSite = false;
    update();
  }

  void changeMode(String mode) {
    checkInOutMethod = mode;
    update();
  }

  Future<void> changeFlash() async {
    flash = !flash;
    //qrViewController.toggleFlash();
    //flash = (await qrViewController.getFlashStatus())!;
    update();
  }

  void changeCamera() {
    //qrViewController.flipCamera();
    update();
  }

  void createdQR(String code, Map data, MobileScannerController? qrController) {
    qrCode = code;
    update();
    showOnSiteQRCheckInCheckOutAlert(
      data['checkin'] == '1'
          ? "Are you sure check-in by on site?"
          : "Are you sure check-out by on site?",
      () {
        sendOnSiteQRCheckIn(
          data['checkin'],
          data['checkout'],
          qrCode,
          data['bssid'],
          data['type'],
        ).then((value) {
          superPrint('what is the error $data');

          // Add null safety checks for DateTime objects
          DateTime? arriveOrLeaveTime = data['arriveOrLeaveTime'] as DateTime?;
          DateTime? startOrEndTime = data['startOrEndTime'] as DateTime?;

          if (arriveOrLeaveTime != null && startOrEndTime != null) {
            if (data['checkin'] == '1') {
              if (arriveOrLeaveTime.isAfter(startOrEndTime)) {
                superPrint('-----> check in time');
                Get.find<DashboardController>().checkInTimeMethod();
              }
            } else {
              if (arriveOrLeaveTime.isBefore(startOrEndTime)) {
                superPrint('-----> check out time');
                Get.find<DashboardController>().checkOutTimeMethod();
              }
            }
          } else {
            superPrint(
              'Error: DateTime values are null - arriveOrLeaveTime: $arriveOrLeaveTime, startOrEndTime: $startOrEndTime',
            );
          }
        });

        Get.back();
      },
      qrController,
    );
  }

  // createdQR(QRViewController controller, Map data) {
  //   qrCode = "";
  //   update();
  //   qrViewController = controller;
  //   controller.scannedDataStream.listen((event) {
  //     qrCode = event.code.toString();
  //     update();
  //     if (qrCode != "") {
  //       qrViewController.pauseCamera();
  //       showOnSiteQRCheckInCheckOutAlert(
  //           data['checkin'] == '1'
  //               ? "Are you sure check-in by on site?"
  //               : "Are you sure check-out by on site?", () {
  //         sendOnSiteQRCheckIn(data['checkin'], data['checkout'], qrCode,
  //                 data['bssid'], data['type'])
  //             .then((value) {
  //           if (data['checkin'] == '1') {
  //             if (data['arrivedOrLeaveTime']
  //                 .isAfter(data['arrivedOrLeaveTime'])) {
  //               Get.find<DashboardController>().checkInTimeMethod();
  //             }
  //           } else {
  //             if (data['arrivedOrLeaveTime']
  //                 .isBefore(data['arrivedOrLeaveTime'])) {
  //               Get.find<DashboardController>().checkOutTimeMethod();
  //             }
  //           }
  //         });
  //
  //         Get.back();
  //       }, qrViewController);
  //     }
  //   });
  // }

  Future<void> getWifiInfo() async {
    if (Platform.isIOS) {
      final info = NetworkInfo();
      final name = await info.getWifiName();
      final bssid = await info.getWifiBSSID();
      wifiName = name!;
      wifiBSSID = bssid!;
      update();
    } else {
      var status = await Permission.location.status;
      if (status.isRestricted || status.isDenied) {
        await Permission.location.request();
      } else {
        final info = NetworkInfo();
        final name = await info.getWifiName();
        final bssid = await info.getWifiBSSID();
        wifiName = name!;
        wifiBSSID = bssid!;
        update();
      }
    }
  }
}
