import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:unity_hr/models/company.dart';
import 'package:unity_hr/models/user.dart';

double screenWidth = 0;
double screenHeight = 0;

Company? companyName;
String baseURL = "";
String localBaseURL = "http://192.168.100.77:8000/";
String apiToken = "";
String isApprovalPerson = "";

Color color1 = const Color(0xff25518f);
Color color2 = const Color(0xffea7f03);
Color color3 = const Color(0xFFFFFFFF);

UserInfo userInfo = UserInfo(
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
  workSchedule: WorkSchedule(
    shiftTitle: '',
    workingHourFrom: '',
    workingHourTo: '',
    halfTime: '',
  ),
);

Widget topPadding(BuildContext context, {Color color = Colors.white}) {
  return Container(
    color: color,
    height: MediaQuery.of(context).viewPadding.top,
  );
}

Widget botPadding(BuildContext context, {Color color = Colors.white}) {
  return Container(
    color: color,
    height: MediaQuery.of(context).viewPadding.bottom,
  );
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = (color.r * 255.0).round().clamp(0, 255),
      g = (color.g * 255.0).round().clamp(0, 255),
      b = (color.b * 255.0).round().clamp(0, 255);

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.toARGB32(), swatch);
}

class AppToast {
  static void showSuccess(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 18,
      backgroundColor: Colors.green.shade600,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static void showError(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 18,
      backgroundColor: Colors.red.shade600,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }
}

void showAlert(String message, {Color color = Colors.black}) {
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
        height: screenHeight * 0.18,
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
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: screenWidth * 0.3,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: color1),
                  // color: Colors.red,
                ),
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: color1,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void showSuccessAlert(
  String message,
  VoidCallback onPressed, {
  Color color = Colors.black,
}) {
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
        height: screenHeight * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 3),
            const Icon(CupertinoIcons.check_mark_circled, size: 35),
            const SizedBox(height: 3),
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
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            GestureDetector(
              onTap: onPressed,
              child: Container(
                width: screenWidth * 0.3,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
            const SizedBox(height: 3),
          ],
        ),
      ),
    ),
  );
}

void showLoadingAlert({String message = "Loading..."}) {
  showDialog(
    context: Get.context!,
    barrierColor: Colors.black.withValues(alpha: 0.2),
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: CupertinoActivityIndicator(radius: 15, color: color1),
            ),
            const SizedBox(height: 15),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
