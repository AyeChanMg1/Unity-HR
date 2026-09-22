import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_hr/controllers/dashboard_controller.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/policy_book.dart';
import 'package:unity_hr/models/user.dart';
import 'package:unity_hr/models/welfare.dart';

class ProfileController extends GetxController {
  TextEditingController txtNameController = TextEditingController();
  TextEditingController txtPhoneController = TextEditingController();
  TextEditingController txtAddressController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String duration = "";
  int selectedRadio = 1;
  bool isProfile = false;
  bool isWelfare = false;
  final _picker = ImagePicker();
  File imageFile = File("");
  bool isUpdate = false;

  //
  List<Welfare> welfareList = [];
  List<PolicyBookList> plcBookList = [];
  PolicyBookDetail? plcBookDetail;

  // Date of birth Value Update
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      duration = dobFormat(selectedDate);
      superPrint(duration, title: "Date of birth");
    }
    update();
  }

  //Gender Update Radio Button
  void setSelectedRadio(int value) {
    selectedRadio = value;
    superPrint(selectedRadio, title: "gender");
    update();
  }

  Future<void> fetchProfile() async {
    isProfile = true;
    try {
      http.Response? response = await Network().getProfile();
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userInfo', jsonEncode(result['data']));
        userInfo = UserInfo.fromJson(result['data']);
        Get.find<DashboardController>().updateWorkTimesFromUserInfo();
        //superPrint('user info ===> $userInfo');
        update();
      } else if (response.statusCode == 401) {
        validateLogout();
      } else {
        showAlert(result['message']);
      }
      isProfile = false;
      update();
    } catch (e) {
      superPrint(e.toString());
    }
  }

  //welfare
  Future<void> fetchWelfare() async {
    welfareList.clear();
    isWelfare = true;
    update();
    http.Response? response = await Network().getAllWelfare();
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var data in iterable) {
        var list = Welfare.fromJson(data);
        welfareList.add(list);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    isWelfare = false;
    update();
  }

  Future<void> openImagePicker() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    if (pickedImage != null) {
      //CroppedFile? croppedFile = await cropImage(pickedImage);
      //if (croppedFile != null) {
      // imageFile = File(croppedFile.path);
      imageFile = File(pickedImage.path);
    }
    //}
    update();
  }

  Future<CroppedFile?> cropImage(XFile image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      // aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: color1,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );
    return croppedFile;
  }

  //Update Profile

  Future<dynamic> updateProfile() async {
    isUpdate = true;
    update();
    Map<String, String> body = {
      "name": txtNameController.text.isEmpty
          ? userInfo.name
          : txtNameController.text,
      "date_of_birth": duration.isEmpty ? userInfo.dob : duration,
      'phone': txtPhoneController.text.isEmpty
          ? userInfo.phone
          : txtPhoneController.text,
      'gender': selectedRadio.toString().isEmpty
          ? userInfo.gender
          : selectedRadio.toString(),
      'current_address': txtAddressController.text.isEmpty
          ? userInfo.address
          : txtAddressController.text,
    };
    // string to uri
    var uri = Uri.parse("${baseURL}api/v1/update-profile");

    // create multipart request
    var request = http.MultipartRequest("POST", uri);
    if (imageFile.path != '') {
      var stream = http.ByteStream(imageFile.openRead().cast<List<int>>());
      var length = await imageFile.length();
      // multipart that takes file
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: basename(imageFile.path),
      );

      // add file to multipart
      request.files.add(multipartFile);
    }
    // add file to multipart
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $apiToken',
    });
    request.fields.addAll(body);

    // send
    var response = await request.send();

    //listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      superPrint(response.statusCode, title: "Image Upload");
      if (response.statusCode == 200 || response.statusCode == 201) {
        //  Get.back();
        fetchProfile();
        showSuccessAlert("You have successfully updated profile.", () {
          Get.back();
          Get.back();
        });
      } else if (response.statusCode == 400) {
        showAlert(value);
      } else {
        showAlert(value);
      }
    });
    isUpdate = false;
    update();
  }

  //policy book list
  Future<void> fetchPolicyBookList() async {
    plcBookList.clear();
    update();
    http.Response? response = await Network().policyBookList();
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var data in iterable) {
        var list = PolicyBookList.fromJson(data);
        plcBookList.add(list);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    update();
  }

  //policy book detail
  Future<void> fetchPolicyBookDetail(String id) async {
    plcBookDetail = null;
    http.Response? response = await Network().policyBookDetail(id);
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      plcBookDetail = PolicyBookDetail.fromJson(result['data']);
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    update();
  }
}
