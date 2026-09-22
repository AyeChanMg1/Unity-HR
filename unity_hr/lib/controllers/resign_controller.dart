import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:unity_hr/controllers/leave_form_controller.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/reform_person.dart';
import 'package:unity_hr/models/request_person.dart';
import 'package:unity_hr/models/resign_detail.dart';
import 'package:unity_hr/models/resign_images.dart';
import 'package:unity_hr/models/resign_last_request.dart';
import 'package:unity_hr/models/resign_request.dart';
import 'package:unity_hr/models/resignation.dart';
import 'dashboard_controller.dart';

class ResignControler extends GetxController {
  TextEditingController txtSubjectController = TextEditingController();
  TextEditingController txtReasonController = TextEditingController();
  TextEditingController txtRequestController = TextEditingController();
  TextEditingController txtReformController = TextEditingController();
  TextEditingController txtRemarkController = TextEditingController();
  String selectedValue = 'Super Admin';
  DateTime selectedDate = DateTime.now();
  String duration = 'Choose Resign Date';
  bool isResign = false;
  bool isEmergency = false;
  bool isResignRequest = false;
  String emergency = '0';
  var leaveCtrl = Get.find<LeaveFormController>();
  bool isApproval = false;
  List<ResignRequest> resignRequestList = [];
  ResignDetail? resignDetail;
  bool isResignDetails = false;
  String monthType = DateFormat('MMMM').format(DateTime.now());
  String monthNum = DateFormat('MM').format(DateTime.now());
  String yearType = DateFormat('yyyy').format(DateTime.now());
  String resignHistoryDate = DateFormat("MMMM - yyyy").format(DateTime.now());

  List<String> yearList = [];
  List<ResignRequest> resignRequestHistoryList = [];
  bool isYear = false;
  bool isResignHistory = false;
  // reform request person
  List<RequestPerson> requestPersonList = [];
  List<RequestPerson> searchRequestList = [];
  List<RequestPerson> dynamicRequestPersonList = [];
  List<String> multiRequestID = [];

  List<ReformPerson> reformPersonList = [];
  List<ReformPerson> searchReformList = [];
  List<ReformPerson> dynamicReformPersonList = [];
  List<String> multiReformID = [];

  bool isReform = false;
  bool isRequest = false;
  bool isSearching = false;

  Resignation? selectedResignation;
  bool editResign = false;
  final RxList<File> selectedImages = <File>[].obs;
  final RxList<String> selectedImagesBase64 = <String>[].obs;
  final ImagePicker _picker = ImagePicker();
  List<ResignImages> attachedImages = [];

  void updateSelectedResignation(Resignation resignation) {
    selectedResignation = resignation;
    editResign = true;
    update();
  }

  void setSelectedResignationInfoForUpdate() {
    txtSubjectController.text = selectedResignation?.subject ?? '';
    duration = selectedResignation?.date ?? '';
    txtReasonController.text = selectedResignation?.reason ?? '';
    setSelectedRequestPersonForEdit(selectedResignation?.requestPerson ?? []);
    setSelectedReformPersonForEdit(selectedResignation?.informPerson ?? []);
    setAttachedImages(list: selectedResignation?.resignImages ?? []);

    // isEmergency = =selectedResignation?.is_emergency == '1' ? true : false
    update();
  }

  Future<void> setAttachedImages({required List<ResignImages> list}) async {
    attachedImages = list;
    final result = await convertResignImagesToBase64(list);
    selectedImagesBase64.assignAll(result);
    update();
  }

  Future<List<String>> convertResignImagesToBase64(
    List<ResignImages> leaveImages,
  ) async {
    List<String> base64List = [];

    for (var img in leaveImages) {
      if (img.url != null && img.url!.isNotEmpty) {
        final base64 = await _imageUrlToBase64(img.url!);
        if (base64 != null) {
          base64List.add(base64);
        }
      }
    }

    return base64List;
  }

  void removeImageForUpdate(int index) {
    if (index >= 0 && index < attachedImages.length) {
      attachedImages.removeAt(index);
      selectedImagesBase64.removeAt(index); // keep in sync
    }
    update();
  }

  Future<String?> _imageUrlToBase64(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return base64Encode(response.bodyBytes);
      }
    } catch (e) {
      debugPrint("Error converting $url to Base64: $e");
    }
    return null;
  }

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.clear();
      selectedImagesBase64.clear();

      for (var xfile in images) {
        File file = File(xfile.path);

        // Compress the file if needed
        File compressedFile = await _compressImage(file);

        selectedImages.add(compressedFile);

        // Convert to Base64
        final bytes = await compressedFile.readAsBytes();
        final base64Image = base64Encode(bytes);
        selectedImagesBase64.add(base64Image);
      }
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      selectedImagesBase64.removeAt(index); // keep in sync
    }
  }

  Future<File> _compressImage(File file) async {
    int maxSizeInBytes = 5 * 1024 * 1024; // 5MB
    File resultFile = file;

    int quality = 90;
    while (resultFile.lengthSync() > maxSizeInBytes && quality > 10) {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        "${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}",
      );

      final compressedXFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
      );

      if (compressedXFile != null) {
        resultFile = File(compressedXFile.path); // Convert XFile → File
      }
      quality -= 10; // Reduce quality gradually
    }

    return resultFile;
  }

  //DropDown Search Action
  List<ResignLastRequest> resignLastRequestList = [];
  void selectedRequestUser(String selectedUser) {
    selectedValue = selectedUser;
    update();
  }

  // Month Type DropDown Value Update
  void monthTypeDropDown(String type) {
    monthType = type;
    update();
  }

  void changeMonthNumber(String num) {
    monthNum = num;
    update();
  }

  // Year Type DropDown Value Update
  void yearTypeDropDown(String type) {
    yearType = type;
    update();
  }

  void toggleIsEmergency() {
    isEmergency = !isEmergency;
    if (isEmergency == true) {
      emergency = "1";
    } else {
      emergency = "0";
    }
    update();
  }

  //Year
  Future<void> fetchYears() async {
    yearList.clear();
    isYear = true;
    update();
    http.Response? response = await Network().getYear();
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var list in iterable) {
        yearList.add(list);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    isYear = false;
    update();
  }

  // Leave Date Value Update
  Future<void> selectDate(BuildContext context, String joinDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.parse(joinDate),
      lastDate: DateTime(
        DateTime.now().year + 1,
        DateTime.now().month + 8,
        DateTime.now().day,
      ),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      duration = dobFormat(selectedDate);
    }
    update();
  }

  //getAllResignRequestPerson
  Future<void> fetchAllResignRequestPerson() async {
    resignLastRequestList.clear();
    http.Response? response = await Network().getAllResignRequestPerson();
    // superPrint(response?.statusCode);
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (result['data'] != null) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = ResignLastRequest.formJson(data);
          resignLastRequestList.add(list);
        }
      }
      // selectedValue = requestPersonList.first.name;
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }

    update();
  }

  //Resign Request
  Future<void> postResignRequest() async {
    isResign = true;
    update();
    try {
      http.Response? response = await Network().resignFormRequest(
        txtSubjectController.text,
        duration,
        multiRequestID,
        multiReformID,
        txtReasonController.text,
        emergency,
        selectedImagesBase64,
      );
      superPrint('resign response ${response?.body}');
      superPrint('resign response status code  ${response?.statusCode}');
      tooManyRequest(response?.statusCode ?? 429);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        selectedImages.value = [];
        selectedImagesBase64.value = [];
        showSuccessAlert('Request Sent!', () {
          clearRedignFormData();
          Get.back();
          Get.back();
        });
        update();
      } else if (response?.statusCode == 400) {
        showAlert(jsonDecode(response!.body)['message']['date'][0]);
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode != 429) {
        showAlert(jsonDecode(response!.body)['message']);
      }
    } catch (e) {
      isResign = false;
      superPrint(e);
    }
    isResign = false;
    update();
  }

  Future<void> updateResignRequest() async {
    isResign = true;
    update();
    try {
      http.Response? response = await Network().updateResignFormRequest(
        txtSubjectController.text,
        duration,
        multiRequestID,
        multiReformID,
        txtReasonController.text,
        emergency,
        selectedImagesBase64,
        selectedResignation?.id ?? '',
      );
      superPrint('resign response ${response?.body}');
      superPrint('resign response status code  ${response?.statusCode}');
      tooManyRequest(response?.statusCode ?? 429);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        selectedImages.value = [];
        selectedImagesBase64.value = [];
        showSuccessAlert('Request Sent!', () {
          clearRedignFormData();
          Get.back();
          Get.back();
          Get.back();
        });
        update();
      } else if (response?.statusCode == 400) {
        showAlert(jsonDecode(response!.body)['message']['date'][0]);
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode != 429) {
        showAlert(jsonDecode(response!.body)['message']);
      }
    } catch (e) {
      isResign = false;
      superPrint(e);
    }
    isResign = false;
    update();
  }

  void clearRedignFormData() {
    txtSubjectController.clear();
    txtReasonController.clear();
    isEmergency = false;
    emergency = '0';
    selectedDate = DateTime.now();
    duration = 'Choose Resign Date';
    multiRequestID.clear();
    multiReformID.clear();
    dynamicReformPersonList.clear();
    dynamicRequestPersonList.clear();
    editResign = false;
    selectedImages.clear();
    attachedImages.clear();
    selectedImagesBase64.clear();
  }

  //View Resign request
  Future<void> fetchResignRequest() async {
    resignRequestList.clear();
    isResignRequest = true;
    update();
    try {
      http.Response? response = await Network().getResignRequest();
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = ResignRequest.fromJson(data);
          resignRequestList.add(list);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isResignRequest = false;
    update();
  }

  //fetch resign by id
  Future<void> fetchResignByID(String id) async {
    isResignDetails = true;
    update();
    try {
      superPrint(id, title: 'OT Details ID');
      http.Response? response = await Network().getResignByID(id);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = ResignDetail.fromJson(result['data']);
        superPrint('iddddddd $id');
        superPrint('hellllo resign detail ${result['data']}');
        resignDetail = ResignDetail(
          id: data.id,
          name: data.name,
          image: data.image,
          position: data.position,
          department: data.department,
          date: data.date,
          status: data.status,
          reason: data.reason,
          remark: data.remark,
          subject: data.subject,
          resignImages: data.resignImages,
        );
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['response']['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isResignDetails = false;
    update();
  }

  //Approvel and Reject OverTime
  Future<void> postResignRequestApproveReject(
    String approval,
    String rejection,
    String id,
  ) async {
    isApproval = true;
    update();
    try {
      http.Response? response = await Network().approveRejectResignRequest(
        approval,
        rejection,
        txtRemarkController.text,
        id,
      );
      tooManyRequest(response?.statusCode ?? 429);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        //Get.back();
        fetchResignRequest();
        Get.find<DashboardController>().fetchAttendanceCount();
        txtRemarkController.clear();
        showSuccessAlert(jsonDecode(response!.body)['response']['message'], () {
          Get.back();
          Get.back();
        });
        update();
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode == 403) {
        showAlert(jsonDecode(response!.body)['response']['message']);
      } else if (response?.statusCode != 429) {
        showAlert(response!.body);
      }
    } catch (e) {
      superPrint(e.toString());
    }
    isApproval = false;
    update();
  }

  //search resign month and year
  Future<void> searchResignRequestByMonthYear(String year, String month) async {
    resignRequestHistoryList.clear();
    isResignHistory = true;
    superPrint(monthNum, title: "Month Number");
    update();
    http.Response? response = await Network().getAllResignRequestHistory(
      year,
      month,
    );
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var i in iterable) {
        var data = ResignRequest.fromJson(i);
        resignRequestHistoryList.add(data);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(response.body);
    }
    isResignHistory = false;
    update();
  }

  void clearResignHistory() {
    monthType = DateFormat('MMMM').format(DateTime.now());
    monthNum = DateFormat('MM').format(DateTime.now());
    yearType = DateFormat('yyyy').format(DateTime.now());
    yearList.clear();
  }

  Future<void> fetchAllRequestPerson() async {
    requestPersonList.clear();
    searchRequestList.clear();
    isRequest = true;
    update();
    http.Response? response = await Network().getAllRequestPerson();
    // superPrint(response?.statusCode);
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var data in iterable) {
        var list = RequestPerson.fromJson(data);
        requestPersonList.add(list);
        searchRequestList.add(list);
      }
      update();
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    isRequest = false;
    update();
  }

  Future<void> fetchAllReformPerson() async {
    reformPersonList.clear();
    searchReformList.clear();
    isReform = true;
    update();

    http.Response? response = await Network().getAllReformPerson();
    // superPrint(response?.statusCode);
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var data in iterable) {
        var list = ReformPerson.fromJson(data);
        reformPersonList.add(list);
        searchReformList.add(list);
      }

      update();
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    isReform = false;
    update();
  }

  void onReformChange(String query) {
    isSearching = true;
    update();
    searchReformList.clear();
    if (query.trim().isNotEmpty) {
      for (var eachPerson in reformPersonList) {
        if (eachPerson.name.trim().toLowerCase().contains(
          query.trim().toLowerCase(),
        )) {
          searchReformList.add(eachPerson);
        }
      }
    } else {
      for (var element in reformPersonList) {
        searchReformList.add(element);
      }
    }
    isSearching = false;
    update();
  }

  //reform person id
  void setSelectedReformPerson(ReformPerson personList) {
    if (dynamicReformPersonList.isNotEmpty) {
      var index = dynamicReformPersonList.indexWhere(
        (element) => element.id == personList.id,
      );
      if (index == -1) {
        dynamicReformPersonList.add(personList);
        multiReformID.add(personList.id);
      }
    } else {
      dynamicReformPersonList.add(personList);
      multiReformID.add(personList.id);
    }

    update();
  }

  void setSelectedReformPersonForEdit(List<ReformPerson> list) {
    dynamicReformPersonList.addAll(list);
    multiReformID.addAll(list.map((e) => e.id));
    update();
  }

  void setSelectedRequestPersonForEdit(List<RequestPerson> list) {
    dynamicRequestPersonList.addAll(list);
    multiRequestID.addAll(list.map((e) => e.id));
    update();
  }

  void onChange(String query) {
    isSearching = true;
    update();
    searchRequestList.clear();
    if (query.trim().isNotEmpty) {
      for (var eachPerson in requestPersonList) {
        if (eachPerson.name.trim().toLowerCase().contains(
          query.trim().toLowerCase(),
        )) {
          searchRequestList.add(eachPerson);
        }
      }
    } else {
      for (var element in requestPersonList) {
        searchRequestList.add(element);
      }
    }
    isSearching = false;
    update();
  }

  //Request person id
  void setSelectedRequestPerson(RequestPerson personList) {
    if (dynamicRequestPersonList.isNotEmpty) {
      var index = dynamicRequestPersonList.indexWhere(
        (element) => element.id == personList.id,
      );
      if (index == -1) {
        dynamicRequestPersonList.add(personList);
        multiRequestID.add(personList.id);
      }
    } else {
      dynamicRequestPersonList.add(personList);
      multiRequestID.add(personList.id);
    }
    superPrint(multiRequestID, title: "New Request Person id");
    update();
  }
}
