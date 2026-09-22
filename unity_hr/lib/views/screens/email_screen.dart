import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unity_hr/controllers/forgot_password_controller.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/views/widgets/super_scaffold.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      topColor: color1,
      botColor: color1,
      child: Scaffold(
        body: Stack(
          children: [
            // Positioned(
            //   top: -20,
            //   right: -120,
            //   child: Container(
            //     width: screenWidth,
            //     height: 90,
            //     alignment: Alignment.topRight,
            //     child: SvgPicture.asset('assets/images/top.svg'),
            //   ),
            // ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    alignment: Alignment.centerLeft,
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: screenWidth * 0.6,
                  child: Image.asset('assets/logo/logo.png', height: 200),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: buildForgotPasswordWidget(),
                ),
              ],
            ),
            if (MediaQuery.of(context).viewInsets.bottom != 0) Container(),
            // if (MediaQuery.of(context).viewInsets.bottom == 0)
            //   Positioned(
            //     bottom: -10,
            //     child: SizedBox(
            //       width: screenWidth,
            //       height: 90,
            //       child: SvgPicture.asset('assets/images/bottom.svg'),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Widget buildForgotPasswordWidget() {
    return GetBuilder<ForgotPasswordController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Reset ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: color1,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, 2),
                  child: const Text("your password"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            /*
            Email TextField
          */
            const Text(
              'Email',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: TextField(
                controller: controller.txtEmailController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: color1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  hintText: "Enter Email",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withValues(alpha: 0.2),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            /*
            Get Code
          */
            GestureDetector(
              // onTap: controller.isLoading
              //     ? null
              //     : () {
              //         FocusManager.instance.primaryFocus?.unfocus();
              //         if (controller.txtEmailController.text.isNotEmpty) {
              //           controller.sendEmail();
              //         } else {
              //           showAlert("Please fill correct email");
              //         }
              //       },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color1,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: controller.isLoading
                    ? const Center(
                        child: CupertinoActivityIndicator(color: Colors.white),
                      )
                    : const Text(
                        "Send Reset Code",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
