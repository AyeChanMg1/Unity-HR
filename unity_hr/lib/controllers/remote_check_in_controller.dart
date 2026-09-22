import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_watermark/image_watermark.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:unity_hr/controllers/dashboard_controller.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/check_gps.dart';

class RemoteCheckInController extends GetxController {
  TextEditingController txtReasonController = TextEditingController();
  TextEditingController txtAddressController = TextEditingController();
  TextEditingController lateReasonController = TextEditingController();
  Uint8List lateImage = Uint8List(0);
  //late LatLng currentLocation;
  LatLng currentLocation = const LatLng(
    16.8409,
    96.1735,
  ); // Default: Yangon, Myanmar
  bool isLocationLoading = false;
  bool isGPS = false;
  bool isRemote = false;
  bool isOnSite = false;
  CheckGPS? checkGPS;
  double radius = 0.00;
  bool gpsValid = false;
  LatLng branchLocation = const LatLng(16.8460461, 96.1228999);
  double branchRadius = 0.00;
  double currentRadius = 0.00;

  Future<String> getUserLocation() async {
    try {
      isLocationLoading = true;
      update();

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
        // desiredAccuracy: LocationAccuracy.high,
      );

      // Retrieve latitude and longitude
      double latitude = position.latitude;
      double longitude = position.longitude;

      currentLocation = LatLng(latitude, longitude);
      //superPrint(currentLocation);
      isLocationLoading = false;
      update();
    } catch (e) {
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
      return e.toString();
    }
    return '';
  }

  //Check GPS in Mobile
  Future<void> checkGPSValid() async {
    // gpsValid = false;
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      // desiredAccuracy: LocationAccuracy.best,
    );
    double latitude = position.latitude;
    double longitude = position.longitude;

    currentLocation = LatLng(latitude, longitude);
    double distanceInMeters = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      branchLocation.latitude,
      branchLocation.longitude,
    );

    if (distanceInMeters <= branchRadius + 100.00) {
      gpsValid = true;
      currentRadius = distanceInMeters;
      update();
    } else {
      gpsValid = false;
      currentRadius = distanceInMeters;
      update();
    }
  }

  //get branch location
  Future<void> getBranchLocation() async {
    isLocationLoading = true;
    update();
    http.Response? response = await Network().getBranchLocation();
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = result['data'][0];
      branchLocation = LatLng(
        double.parse(data['latitude'].toString()),
        double.parse(data['longitude'].toString()),
      );
      branchRadius = double.parse(data['radius'].toString());
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(response.body);
    }
    isLocationLoading = false;
    update();
  }

  //Check GPS CheckIn Validity
  Future<void> checkGPSCheckIn() async {
    isGPS = true;
    update();
    try {
      http.Response? response = await Network().checkGPS(
        currentLocation.latitude.toString(),
        currentLocation.longitude.toString(),
      );
      //superPrint(response?.statusCode, title: 'GPS');
      tooManyRequest(response?.statusCode ?? 429);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        var result = jsonDecode(response!.body);
        checkGPS = CheckGPS(
          radius: result['data']['radius'],
          validity: result['data']['validity'],
        );
        update();
        //superPrint("Check GPS......... ${checkGPS!.validity}");
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode != 429) {
        showAlert(response!.body.toString());
      }
    } catch (e) {
      superPrint(e);
    }
    isGPS = false;
    update();
  }

  Future<void> sendRemoteCheckIn(
    String checkin,
    String checkout,
    String lateReason,
  ) async {
    isRemote = true;
    update();
    http.Response? response = await Network().remoteCheckIn(
      checkin,
      checkout,
      currentLocation.latitude.toString(),
      currentLocation.longitude.toString(),
      currentRadius.toString(),
      '1',
      txtReasonController.text,
      txtAddressController.text,
      lateImage,
      lateReason,
    );
    // superPrint(response?.statusCode, title: 'GPS');
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    superPrint(result);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.find<DashboardController>().fetchHomeReport();
      Get.find<RemoteCheckInController>().checkGPSCheckIn();
      clearRemoteCheckInOut();
      Get.back();
      showAlert(result['response']['message']);
      update();
    } else if (response.statusCode == 401) {
      validateLogout();
      isRemote = false;
      update();
    } else if (response.statusCode != 429) {
      showAlert(result['response']['message']);
      isRemote = false;
      update();
    }
    isRemote = false;
    update();
  }

  Future<Uint8List> addWatermark(File image) async {
    LatLng currentLocation =
        Get.find<RemoteCheckInController>().currentLocation;
    String location =
        "Latitude - ${currentLocation.latitude}\nLongitude - ${currentLocation.longitude}";
    update();
    final DateTime timeAmsterdamTZ = DateTime.now();
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
    final watermarkedImgBytes = await ImageWatermark.addTextWatermark(
      imgBytes: imageBytes,
      watermarkText:
          "${DateFormat("dd MMM yyyy\nhh:mm a").format(timeAmsterdamTZ)}\n$location",
      color: Colors.white,
      dstX: 40,
      dstY: 40,
    );
    return watermarkedImgBytes;
  }

  Future<void> sendOnSiteCheckIn(
    String checkin,
    String checkout,
    reason,
  ) async {
    isOnSite = true;
    update();
    http.Response? response = await Network().remoteCheckIn(
      checkin,
      checkout,
      currentLocation.latitude.toString(),
      currentLocation.longitude.toString(),
      currentRadius.toString(),
      '0',
      txtReasonController.text,
      txtAddressController.text,
      lateImage,
      reason,
    );
    var result = jsonDecode(response!.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.find<DashboardController>().fetchHomeReport();
      Get.find<RemoteCheckInController>().checkGPSCheckIn();
      showAlert(result['response']['message']);
      update();
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['response']['message']);
    }
    isOnSite = false;
    update();
  }

  void clearRemoteCheckInOut() {
    txtAddressController.clear();
    txtReasonController.clear();
  }
}
