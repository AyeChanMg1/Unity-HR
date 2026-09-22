import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/views/screens/login_screen.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPinputController = TextEditingController();
  TextEditingController txtNewPasswordController = TextEditingController();
  TextEditingController txtConfirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool xNew = false;
  bool xConfirm = false;
  bool xForgot = false;

  //forgotPassword
  // void sendEmail() async {
  //   isLoading = true;
  //   update();
  //   http.Response? response = await Network().email(txtEmailController.text);
  //   superPrint(response?.statusCode, title: 'forgot password');
  //   tooManyRequest(response?.statusCode ?? 429);
  //   if (response?.statusCode == 200 || response?.statusCode == 201) {
  //     Get.to(() => const OTPScreen());
  //   } else if (response?.statusCode == 400) {
  //     showAlert(jsonDecode(response!.body)['response']['message']['email'][0]);
  //   } else if (response?.statusCode == 401) {
  //     validateLogout();
  //   } else if (response?.statusCode != 429) {
  //     showAlert(response!.body);
  //   }
  //   isLoading = false;
  //   update();
  // }

  Future<void> forgotPassword() async {
    xForgot = true;
    update();
    http.Response? response = await Network().forgotPs(
      txtPinputController.text,
      txtNewPasswordController.text,
      txtConfirmPasswordController.text,
    );
    superPrint(response?.statusCode, title: 'login');
    tooManyRequest(response?.statusCode ?? 429);
    if (response?.statusCode == 200 || response?.statusCode == 201) {
      clearAllData();
      Get.to(() => const LoginScreen());
    } else if (response?.statusCode == 400) {
      if (jsonDecode(response!.body)['response']['message']['code'][0] ==
          'The selected code is invalid.') {
        showAlert("The selected code is invalid.");
      } else if (jsonDecode(
            response.body,
          )['response']['message']['password'][0] ==
          "The password confirmation does not match.") {
        showAlert("The password confirmation does not match.");
      } else {
        showAlert(response.body);
      }

      // showAlert(jsonDecode(response!.body)['response']['message']['code'][0]);
    } else if (response?.statusCode == 401) {
      validateLogout();
    } else if (response?.statusCode != 429) {
      showAlert("Username and password is invalid! ");
    }
    xForgot = false;
    update();
  }

  void toggleVisiblity() {
    xNew = !xNew;
    update();
  }

  void toggleConfirmVisiblity() {
    xConfirm = !xConfirm;
    update();
  }

  void clearAllData() {
    txtEmailController.clear();
    txtConfirmPasswordController.clear();
    txtNewPasswordController.clear();
    txtPinputController.clear();
  }

  void pinputLength(dynamic value) {
    txtPinputController.text = value;
    update();
  }
}
