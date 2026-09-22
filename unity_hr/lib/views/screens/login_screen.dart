import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unity_hr/controllers/forgot_password_controller.dart';
import 'package:unity_hr/controllers/login_controller.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/models/company.dart';
import 'package:unity_hr/views/screens/email_screen.dart';
import 'package:unity_hr/views/screens/first_screen.dart';
import 'package:unity_hr/views/widgets/super_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _initializeData();
    Get.find<LoginController>().showModal = true;
    companyName?.name = '';
  }

  Future<void> _initializeData() async {
    await Get.find<LoginController>().getCompanies();
    await Get.find<LoginController>().getDeviceInformation();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   controller = AnimationController(
  //       duration: const Duration(milliseconds: 2000), vsync: this);
  //   animation = Tween(begin: 0.0, end: 1.0).animate(controller!)
  //     ..addListener(() {
  //       setState(() {
  //         controller?.forward();
  //         // the state that has changed here is the animation object’s value
  //       });
  //     });
  //   controller?.repeat();
  // }

  // @override
  // void dispose() {
  //   controller!.stop();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    setScreenSize(context);
    return SuperScaffold(
      topColor: color1,
      botColor: color1,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
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
              GetBuilder<LoginController>(
                builder: (controller) {
                  return ListView(
                    children: [
                      SizedBox(height: screenHeight * 0.09),
                      SizedBox(
                        height: 150,
                        child: Image.asset('assets/logo/logo.png'),
                      ),
                      const SizedBox(height: 10),
                      controller.showModal == true
                          ? showCompanyDialog(controller)
                          : buildLoginBodyWidget(controller),
                    ],
                  );
                },
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
      ),
    );
  }

  Widget buildLoginBodyWidget(LoginController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: color1,
                ),
              ),
              Transform.translate(
                offset: const Offset(0, 2),
                child: const Text(" to your account"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Email or UserName', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 10),
          buildEmailNameTextFieldWidget(
            controller.txtEmailController,
            'Enter Email or UserName',
          ),
          // buildEachTextFieldWidget(
          //   controller.txtEmailController,
          //   'Enter Email or UserName',
          // ),
          const SizedBox(height: 10),
          const Text('Password', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 10),
          buildEachTextFieldWidget(
            controller.txtPasswordController,
            iconVisible: true,
            'Enter Password',
          ),
          const SizedBox(height: 8),
          /*
                  Forgot Password
                */
          GestureDetector(
            onTap: () {
              Get.find<ForgotPasswordController>().clearAllData();
              Get.to(() => const EmailScreen());
            },
            child: Container(
              height: 45,
              alignment: Alignment.centerRight,
              color: Colors.transparent,
              child: Text(
                "Forgot Password?",
                style: TextStyle(color: color1, fontSize: 12),
              ),
            ),
          ),
          /*
              Login
            */
          GestureDetector(
            onTap: () {
              Get.offAll(() => const FirstScreen());
            },
            // onTap: controller.xLogin
            //     ? null
            //     : () async {
            //         controller.getDeviceInformation();
            //         if (controller.txtEmailController.text.isNotEmpty &&
            //             controller.txtPasswordController.text.isNotEmpty) {
            //           showLoadingDialog();
            //           await Future.delayed(const Duration(seconds: 1));
            //           controller.login();
            //         } else if (controller.txtEmailController.text.isEmpty) {
            //           showAlert("Please fill email or username");
            //         } else if (controller.txtPasswordController.text.isEmpty) {
            //           showAlert("Please fill correct password");
            //         } else {
            //           showAlert("Please fill valid username and password");
            //         }
            //       },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEachTextFieldWidget(
    TextEditingController controller,
    String hintText, {
    bool iconVisible = false,
  }) {
    return TextField(
      obscureText: Get.find<LoginController>().xVisible ? true : false,
      controller: controller,
      cursorColor: color1,
      decoration: InputDecoration(
        suffixIcon: GetBuilder<LoginController>(
          builder: (ctrl) {
            return GestureDetector(
              onTap: () {
                ctrl.toggleVisiblity();
              },
              child: ctrl.xVisible
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
            );
          },
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.black.withValues(alpha: 0.2),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

Widget buildEmailNameTextFieldWidget(
  TextEditingController controller,
  String hintText,
) {
  return TextField(
    obscureText: false,
    controller: controller,
    cursorColor: color1,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 14,
        color: Colors.black.withValues(alpha: 0.2),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

void showLoadingDialog() {
  showDialog(
    context: Get.context!,
    barrierColor: Colors.black.withValues(alpha: 0.2),
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      // backgroundColor: const Color(0xFFFFE463),
      insetPadding: const EdgeInsets.symmetric(horizontal: 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      content: Container(
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please wait for a moment",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 3),
            LinearProgressIndicator(
              backgroundColor: color1.withValues(alpha: 0.1),
            ),
          ],
        ),
      ),
    ),
  );
}

Center showCompanyDialog(LoginController controller) {
  return Center(
    child: SizedBox(
      width: screenWidth * 0.9,
      height: screenHeight * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select your company",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: color1,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        Get.find<LoginController>().getCompanies();
                      },
                      icon: Icon(CupertinoIcons.refresh, color: color1),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: buildEmailNameTextFieldWidget(
                          controller.txtselectcompanyController,
                          'Enter SubDomain',
                        ),
                      ),
                      SizedBox(width: 1),
                      Text('.cityhr.com.mm', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 45),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: screenWidth,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.txtselectcompanyController.text.isEmpty) {
                    showAlert("Please fill company name");
                  } else {
                    final Company company = controller.companyList
                        .cast<Company>()
                        .firstWhere(
                          (company) =>
                              company.domain
                                  .replaceAll(' ', '')
                                  .toLowerCase() ==
                              controller.txtselectcompanyController.text
                                  .toString()
                                  .replaceAll(' ', '')
                                  .toLowerCase(),
                          orElse: () => Company(name: '-', domain: '-'),
                        );
                    if (company.domain != '-') {
                      controller.updateCompanyName(
                        Company(name: company.name, domain: company.domain),
                      );
                    } else {
                      showAlert("company name is not found");
                    }
                  }
                },
                child: const Text("Continue"),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
