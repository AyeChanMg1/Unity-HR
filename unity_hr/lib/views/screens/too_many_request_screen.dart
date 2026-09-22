import 'package:flutter/material.dart';

class TooManyRequestScreen extends StatelessWidget {
  const TooManyRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox();
    // return SuperScaffold(
    //   topColor: color1,
    //   botColor: color1,
    //   child: WillPopScope(
    //     onWillPop: () async => false,
    //     child: Scaffold(
    //       backgroundColor: Colors.white,
    //       bottomNavigationBar: buildButtomNavBar(),
    //       body: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Center(
    //             child: SizedBox(
    //               width: screenWidth * 0.6,
    //               height: screenWidth * 0.6,
    //               child: Lottie.asset(
    //                 'assets/lottie/lostConnection.json',
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //           ),
    //           const SizedBox(height: 23),
    //           const Text(
    //             "Oops!",
    //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    //           ),
    //           const SizedBox(height: 23),
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 30),
    //             child: Text(
    //               "Something went wrong.",
    //               style: TextStyle(
    //                 fontSize: 13,
    //                 fontWeight: FontWeight.w600,
    //                 color: const Color(0xFF5F5F5F).withOpacity(0.5),
    //               ),
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 30),
    //             child: Text(
    //               "Please try again later.",
    //               style: TextStyle(
    //                 fontSize: 13,
    //                 fontWeight: FontWeight.w600,
    //                 color: const Color(0xFF5F5F5F).withOpacity(0.5),
    //               ),
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //           const SizedBox(height: 30),
    //           GestureDetector(
    //             onTap: () {
    //               Get.find<LoginController>().checkServerTooManyRequset().then((
    //                 value,
    //               ) async {
    //                 if (value) {
    //                   Get.back();
    //                 } else {
    //                   bool connectionResult =
    //                       await InternetConnectionChecker().hasConnection;
    //                   if (!connectionResult) {
    //                     showAlert("Please check internet connection");
    //                   } else {
    //                     showAlert('Too Many Request');
    //                   }
    //                 }
    //               });
    //             },
    //             child: Container(
    //               width: screenWidth * 0.4,
    //               alignment: Alignment.center,
    //               padding: const EdgeInsets.symmetric(vertical: 10),
    //               decoration: BoxDecoration(
    //                 color: color1,
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               child: Text(
    //                 'Try Again'.tr,
    //                 style: const TextStyle(
    //                   fontWeight: FontWeight.w600,
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
