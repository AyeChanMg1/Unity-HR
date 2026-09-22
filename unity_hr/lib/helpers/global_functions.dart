import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/models/probation_assessment_score.dart';
import 'package:unity_hr/views/screens/too_many_request_screen.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

Map<String, dynamic> calculateProbationAssessmentScores(
  ProbationAssessmentScore p,
) {
  bool status = false;
  int totalScore = p.formData?.scoreTo ?? 0 * p.scoreValue.length;
  int score = 0;
  for (var e in p.scoreValue) {
    score += int.parse(e.value);
  }
  double result = (score / totalScore) * 100;
  if (result >= (p.formData!.percentage ?? 0)) {
    status = true;
  }
  var data = {'status': status, 'result_percent': result.toStringAsFixed(2)};
  return data;
}

Map<String, dynamic> checkProbationStatus(ProbationAssessmentScore p) {
  var color = [Colors.orange, Colors.red, color1, Colors.blue];
  var value = ['pending', 'fail', 'pass', 'processing'];
  Color c = Colors.orange;
  String v = 'pending';
  for (var e in value) {
    if (e.toLowerCase() == p.resultStatus?.toLowerCase()) {
      c = color[value.indexOf(e)];
      v = e;
    }
  }
  var data = {'color': c, 'value': v.toUpperCase()};
  return data;
}

Map<String, dynamic> checkProbationApproveStatus(ProbationAssessmentScore p) {
  var color = [Colors.orange, color1, Colors.red, Colors.blue];
  var value = ['pending', 'approved', 'rejected', 'processing'];
  Color c = Colors.orange;
  String v = 'pending';
  for (var e in value) {
    if (e.toLowerCase() == p.status.toLowerCase()) {
      c = color[value.indexOf(e)];
      v = e;
    }
  }
  var data = {'color': c, 'value': v.toUpperCase()};
  return data;
}

ScorePolicy calculateScore(ProbationAssessmentScore p, int score) {
  ScorePolicy sp = p.scorePolicies.first;
  for (var e in p.scorePolicies) {
    if (score >= e.scoreFrom && score <= e.scoreTo) {
      sp = e;
    }
  }
  return sp;
}

Color hexToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor'; // Add alpha value if missing
  }
  return Color(int.parse(hexColor, radix: 16));
}

double gridRatio(int widthDiv) {
  double result =
      ((screenWidth / 2) / ((screenHeight - kToolbarHeight - 24) / 10));
  return result;
}

//Monday,March 27,2023
String formatDate(DateTime date) {
  String formattedDate = DateFormat('dd MMM yyyy').format(date);
  //DateFormat('dd MMMM yyyy').format(date);yMMMEd()
  return formattedDate;
}

//Mar 27,2023
String dob(DateTime selectedDate) {
  String formattedDate = DateFormat.yMMMd().format(selectedDate);
  return formattedDate;
}

//2000-03-11
String dobFormat(DateTime selectedDobDate) {
  String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDobDate);
  return formattedDate;
}

// outpass form mm-dd-yyyy
String outPassDateFormat(DateTime selectedDobDate) {
  String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDobDate);
  return formattedDate;
}

//13 Mar 2023 11:46 am
String notiDateFormat(String date) {
  String formattedDate = DateFormat(
    'yyyy-MM-dd  hh:mm a',
  ).format(DateFormat('yyyy-MM-dd hh:mm').parse(date));
  return formattedDate;
}

//Change AM PM format
String formattedAMPM(String date) {
  String formattedDate = DateFormat(
    'hh:mm a',
  ).format(DateFormat("HH:mm:ss").parse(date));
  return formattedDate;
}

String formattedAMPM1(String date) {
  String formattedDate = "";

  try {
    formattedDate = DateFormat(
      'hh:mm a',
    ).format(DateFormat("h:m:s").parse(date));
  } catch (e) {
    // Exception handling code
    formattedDate = "--";
  }

  return formattedDate;
}

//01 May
String dayMonthFormatted(String date) {
  String formattedDate = DateFormat(
    'dd MMMM',
  ).format(DateFormat('yyyy-MM-dd').parse(date));
  return formattedDate;
}

//16 Apr 2023
String otRequestDate(String date) {
  String formatted = DateFormat(
    'dd MMM yyyy',
  ).format(DateFormat('yyyy-MM-dd').parse(date));
  return formatted;
}

void setScreenSize(BuildContext context) {
  // screenWidth = Get.width;
  // screenHeight = Get.height;
  screenWidth = MediaQuery.sizeOf(context).width;
  screenHeight = MediaQuery.sizeOf(context).height;
}

String capitalize(String value) {
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

String comma(double amount) {
  NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '',
  );
  String formattedAmount = currencyFormat.format(amount);
  return formattedAmount;
}

Map<String, String> month = {
  "January": '01',
  "February": '02',
  "March": '03',
  "April": '04',
  "May": '05',
  "June": '06',
  "July": '07',
  "August": '08',
  "September": '09',
  "October": '10',
  "November": '11',
  "December": '12',
};

void getVersionCode() async {
  //PackageInfo packageInfo = await PackageInfo.fromPlatform();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String versionCode = packageInfo.buildNumber;
  String versionName = packageInfo.version;
  log('versionName code: $versionName');
  log('Version code: $versionCode');
}

void tooManyRequest(int statusCode) {
  //superPrint("Too Many Request ..............$statusCode");
  if (statusCode == 429) {
    Get.to(() => const TooManyRequestScreen());
  }
}

bool? isValid;
Future<bool> isUrlValid(String url) async {
  isValid = await canLaunchUrl(Uri.parse(url));
  return isValid!;
}

void showOnSiteCheckInCheckOutAlert(String title, VoidCallback onPressed) {
  showDialog(
    context: Get.context!,
    barrierColor: Colors.black.withValues(alpha: 0.2),
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white60,
      // backgroundColor: const Color(0xFFFFE463),
      contentPadding: const EdgeInsets.only(left: 8, right: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      content: Container(
        height: screenHeight * 0.19,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: screenWidth,
              // height: screenHeight * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                //color: Colors.amberAccent,
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: screenWidth * 0.3,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color1),
                      // color: Colors.red,
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: color1,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onPressed,
                  child: Container(
                    width: screenWidth * 0.3,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color1),
                      color: color1,
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void showOnSiteQRCheckInCheckOutAlert(
  String title,
  VoidCallback onPressed,
  MobileScannerController? qrController,
) {
  showDialog(
    context: Get.context!,
    barrierColor: Colors.black.withValues(alpha: 0.2),
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white60,
      // backgroundColor: const Color(0xFFFFE463),
      contentPadding: const EdgeInsets.only(left: 8, right: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      content: Container(
        height: screenHeight * 0.19,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: screenWidth,
              // height: screenHeight * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                //color: Colors.amberAccent,
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    //qrController.start();
                    //controller.resumeCamera();
                  },
                  child: Container(
                    width: screenWidth * 0.3,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color1),
                      // color: Colors.red,
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: color1,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onPressed,
                  child: Container(
                    width: screenWidth * 0.3,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color1),
                      color: color1,
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<bool> checkTimeZone() async {
  bool result = false;
  final TimezoneInfo currentTimeZone = await FlutterTimezone.getLocalTimezone();
  if (currentTimeZone.identifier == "Asia/Rangoon" ||
      currentTimeZone.identifier == "Asia/Yangon") {
    result = true;
  } else {
    Fluttertoast.showToast(
      msg: "Please check device timezone automatically or not in setting!",
    );
  }
  return result;
}
