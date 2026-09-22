import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:unity_hr/controllers/navbar_controller.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/leave_detail.dart';
import 'package:unity_hr/models/leave_history.dart';
import 'package:unity_hr/models/leave_type.dart';
import 'package:unity_hr/models/reform_person.dart';
import 'package:unity_hr/models/request_person.dart';

import 'dashboard_controller.dart';
import 'leave_request_history_controller.dart';

class LeaveFormController extends GetxController {
  TextEditingController txtReasonController = TextEditingController();
  TextEditingController txtRemarkController = TextEditingController();
  String monthType = DateFormat('MMMM').format(DateTime.now());
  String leaveDate = DateFormat("MMMM - yyyy").format(DateTime.now());
  List<LeaveHistory> leaveHistoryList = [];
  String dateFrom = dobFormat(
    DateTime(DateTime.now().year, DateTime.now().month, 1),
  );
  String dateTo = dobFormat(
    DateTime(DateTime.now().year, DateTime.now().month + 1, 1),
  );

  //date range
  DateTimeRange selectedDate = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime.now(),
  );
  String duration = 'Choose Date';
  List<DateTime?> dateRange = [DateTime.now()];
  String startDate = "";
  String endDate = '';
  //radio button
  int selectedRadio = 0;
  String radioValue = '';
  //leave
  List<LeaveType> leaveTypeList = [];
  List<LeaveType> approveLeaveTypeList = [];
  String leaveType = '';
  String leaveTypeID = "";
  String leaveID = "";

  // reform request person
  List<RequestPerson> requestPersonList = [];
  List<RequestPerson> searchRequestList = [];
  List<RequestPerson> dynamicRequestPersonList = [];
  List<String> multiRequestID = [];

  List<ReformPerson> reformPersonList = [];
  List<ReformPerson> searchReformList = [];
  List<ReformPerson> dynamicReformPersonList = [];
  List<String> multiReformID = [];

  bool isLeaveType = false;
  bool isRequest = false;
  bool isReform = false;
  bool isLeaveRequest = false;
  bool isLeaveHistory = false;
  bool isSearching = false;
  bool isVisible = true;

  String? annualRemain = "0",
      annualAllow = "0",
      casualRemain = "0",
      casualAllow = "0";

  bool isApproval = false;
  List selectedRequestPersonIndex = [];

  // Leave Image
  List<LeaveImages> attachedImages = [];

  //Leave Request Detail
  EmployeeLeaveRequestDetail? detailsLeave;
  bool isDetail = false;
  final RxList<File> selectedImages = <File>[].obs;
  RxList<String> selectedImagesBase64 = <String>[].obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.clear();
      selectedImagesBase64.clear();

      // Process images sequentially to avoid race conditions
      for (int i = 0; i < images.length; i++) {
        try {
          File file = File(images[i].path);

          // Compress the file if needed
          File compressedFile = await _compressImage(file);

          // Convert to Base64
          final bytes = await compressedFile.readAsBytes();
          final base64Image = base64Encode(bytes);

          // Add to lists only after successful processing
          selectedImages.add(compressedFile);
          selectedImagesBase64.add(base64Image);

          superPrint('Image ${i + 1}/${images.length} processed successfully');
        } catch (e) {
          superPrint('Error processing image ${i + 1}: $e');
        }
      }

      superPrint('Total images selected: ${selectedImages.length}');
      superPrint('Total base64 images: ${selectedImagesBase64.length}');
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      selectedImagesBase64.removeAt(index); // keep in sync
    }
  }

  void removeImageForUpdate(int index) {
    if (index >= 0 && index < attachedImages.length) {
      attachedImages.removeAt(index);
      selectedImagesBase64.removeAt(index); // keep in sync
    }
    update();
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

  // Leave Type DropDown Value Update
  void leaveTypeDropDown(String type, int index) {
    leaveType = type;
    leaveTypeID = leaveTypeList[index].id;
    superPrint(leaveTypeID, title: "LeaveTypeID");
    update();
  }

  //Month
  void monthTypeDropDown(String type) {
    monthType = type;
    update();
  }

  void visiblity() {
    isVisible = !isVisible;
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

  // Leave Date Value Update
  // Future<void> selectDate(BuildContext context) async {
  //   final DateTimeRange? picked = await showDateRangePicker(
  //     context: context,
  //     currentDate: DateTime.now(),
  //     firstDate: DateTime(
  //       DateTime.now().year,
  //       DateTime.now().month,
  //       DateTime.now().day,
  //     ),
  //     lastDate: DateTime(
  //       DateTime.now().year,
  //       DateTime.now().month + 11,
  //     ),
  //   );

  //   if (picked != null && picked != selectedDate) {
  //     //superPrint(picked, title: "Date Range");
  //     selectedDate = picked;
  //     DateTime start = selectedDate.start;
  //     DateTime end = selectedDate.end;
  //     duration = "${dobFormat(start)} to ${dobFormat(end)}";
  //     startDate = dobFormat(start);
  //     endDate = dobFormat(end);
  //     superPrint(startDate.runtimeType);
  //   }
  //   update();
  // }
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      _selectedStartDate = args.value.startDate;
      _selectedEndDate = args.value.endDate ?? args.value.startDate;
      startDate = dobFormat(_selectedStartDate);
      endDate = dobFormat(_selectedEndDate);
      duration =
          '${dobFormat(_selectedStartDate)} to ${dobFormat(_selectedEndDate)}';
    }
    superPrint(duration);
    update();
  }

  Future<void> selectDate(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        DateRangePickerView currentView = DateRangePickerView.month;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: screenWidth,
                height: screenHeight * 0.45,
                child: SfDateRangePicker(
                  selectionShape: DateRangePickerSelectionShape.circle,
                  view: currentView,
                  onViewChanged: (DateRangePickerViewChangedArgs args) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (currentView != args.view) {
                        setState(() {
                          currentView = args.view;
                        });
                      }
                    });
                  },
                  cellBuilder:
                      (
                        BuildContext context,
                        DateRangePickerCellDetails cellDetails,
                      ) {
                        String text;

                        switch (currentView) {
                          case DateRangePickerView.month:
                            text = cellDetails.date.day.toString();
                            break;

                          case DateRangePickerView.year:
                            text = DateFormat.MMM().format(cellDetails.date);
                            break;

                          case DateRangePickerView.decade:
                            text = cellDetails.date.year.toString();
                            break;

                          case DateRangePickerView.century:
                            text = cellDetails.date.year.toString();
                            break;
                        }
                        final bool isDisabled =
                            cellDetails.date.isBefore(
                              DateTime.now().subtract(
                                const Duration(days: 365),
                              ),
                            ) ||
                            cellDetails.date.isAfter(
                              DateTime.now().add(const Duration(days: 365)),
                            );

                        return Container(
                          width: cellDetails.bounds.width,
                          height: cellDetails.bounds.height,
                          alignment: Alignment.center,
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 15,
                              color: isDisabled ? Colors.grey : Colors.black,
                            ),
                          ),
                        );
                      },
                  selectionMode: DateRangePickerSelectionMode.range,
                  // initialSelectedRange: PickerDateRange(
                  //   _selectedStartDate,
                  //   _selectedEndDate,
                  // ),
                  onSelectionChanged: onSelectionChanged,
                  selectionTextStyle: const TextStyle(color: Colors.white),
                  rangeTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  minDate: DateTime.now().subtract(const Duration(days: 365)),
                  maxDate: DateTime.now().add(const Duration(days: 365)),
                  confirmText: 'OK',
                  cancelText: 'Cancel',
                  showActionButtons: true,
                  onCancel: () {
                    Navigator.pop(context);
                  },
                  onSubmit: (value) {
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        );
      },
    );
    // showCustomDateRangePicker(
    //   context,
    //   dismissible: true,
    //   minimumDate: DateTime.now().subtract(const Duration(days: 30)),
    //   maximumDate: DateTime.now().add(const Duration(days: 30)),
    //   backgroundColor: Colors.white,
    //   startDate: DateTime.now(),
    //   endDate: DateTime.now(),
    //   primaryColor: color1,
    //   onApplyClick: (start, end) {
    //     startDate = dobFormat(start);
    //     endDate = dobFormat(end);
    //     duration = "${dobFormat(start)} to ${dobFormat(end)}";
    //     update();
    //   },
    //   onCancelClick: () {
    //     endDate = '';
    //     startDate = '';
    //   },
    // );
    update();
  }

  // Future selectDate(BuildContext context) async {
  //   return Get.dialog(Container(
  //     width: 100,
  //     height: 100,
  //     child: SfDateRangePicker(
  //         onSelectionChanged: onSelectionChanged,
  //         selectionMode: DateRangePickerSelectionMode.range,

  //         // initialSelectedRange: PickerDateRange(
  //         //   _selectedStartDate,
  //         //   _selectedEndDate,
  //         // ),
  //         minDate: DateTime.now().subtract(const Duration(days: 365)),
  //         maxDate: DateTime.now().add(const Duration(days: 365)),
  //         confirmText: 'OK',
  //         cancelText: 'Cancel',
  //         showActionButtons: true,
  //         onCancel: () {
  //           Get.back();
  //         },
  //         onSubmit: (_) {
  //           Get.back();
  //         }),
  //   ));

  //   // showCustomDateRangePicker(
  //   //   context,
  //   //   dismissible: true,
  //   //   minimumDate: DateTime.now().subtract(const Duration(days: 30)),
  //   //   maximumDate: DateTime.now().add(const Duration(days: 30)),
  //   //   backgroundColor: Colors.white,
  //   //   startDate: DateTime.now(),
  //   //   endDate: DateTime.now(),
  //   //   primaryColor: color1,
  //   //   onApplyClick: (start, end) {
  //   //     startDate = dobFormat(start);
  //   //     endDate = dobFormat(end);
  //   //     duration = "${dobFormat(start)} to ${dobFormat(end)}";
  //   //     update();
  //   //   },
  //   //   onCancelClick: () {
  //   //     endDate = '';
  //   //     startDate = '';
  //   //   },
  //   // );
  //   update();
  // }

  //Leave Request Type Update Radio Button
  void setSelectedRadio(int value) {
    selectedRadio = value;
    if (value == 1) {
      radioValue = 'full';
    } else if (value == 2) {
      radioValue = 'morning_half';
    } else if (value == 3) {
      radioValue = 'evening_half';
    }
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

  //Leave Type
  Future<void> fetchAllLeaveType() async {
    leaveTypeList.clear();
    isLeaveType = true;
    update();
    http.Response? response = await Network().getAllLeaveType();
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var data in iterable) {
        var list = LeaveType.fromJson(data);
        leaveTypeList.add(list);
      }
      leaveType = leaveTypeList.first.title;
      leaveTypeID = leaveTypeList.first.id;
      // superPrint(leaveTypeID, title: "Leave Type ID");
      // var annualIndex =
      //     leaveTypeList.indexWhere((leave) => leave.title == 'Annual Leave');
      // var casualIndex =
      //     leaveTypeList.indexWhere((leave) => leave.title == 'Casual Leave');
      // annualRemain = leaveTypeList[annualIndex].remainingDay;
      // annualAllow = leaveTypeList[annualIndex].allowDay;
      // casualRemain = leaveTypeList[casualIndex].remainingDay;
      // casualAllow = leaveTypeList[casualIndex].allowDay;
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode == 500) {
      showAlert(result['response']['message']);
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    isLeaveType = false;
    update();
  }

  Future<dynamic> showLeaveTypeDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.only(
            top: screenHeight * 0.2,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizedBox(
            width: screenWidth * 0.95,
            height: screenHeight * 0.4,
            child: ListView(
              children: leaveTypeList
                  .where((e) => double.parse(e.remainingDay) > 0)
                  .map((leave) {
                    return Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              leaveType = leave.title;
                              leaveTypeID = leave.id;
                              update();
                              Get.back();
                              superPrint(leaveType);
                              superPrint(leaveTypeID);
                            },
                            child: Container(
                              width: screenWidth * 0.7,
                              height: 30,
                              alignment: Alignment.centerLeft,
                              color: Colors.transparent,
                              child: Text(leave.title),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showLeaveDetailsDialog(
                                context,
                                leave.description,
                              );
                            },
                            child: const Icon(
                              CupertinoIcons.info_circle,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Future<Future<dynamic>> showApproveLeaveTypeDialog(
    BuildContext context,
    String empId,
  ) async {
    approveLeaveTypeList.clear();
    update();
    http.Response? response = await Network().getLeaveTypeByEmployeeID(empId);
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var data in iterable) {
        var list = LeaveType.fromJson(data);
        approveLeaveTypeList.add(list);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    return showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.only(
            top: screenHeight * 0.2,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizedBox(
            width: screenWidth * 0.95,
            height: screenHeight * 0.4,
            child: ListView(
              children: approveLeaveTypeList
                  .where((e) => double.parse(e.remainingDay) > 0)
                  .map((leave) {
                    return Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              leaveType = leave.title;
                              leaveTypeID = leave.id;
                              update();
                              Get.back();
                              superPrint(leaveType);
                              superPrint(leaveTypeID);
                            },
                            child: Container(
                              width: screenWidth * 0.7,
                              height: 30,
                              alignment: Alignment.centerLeft,
                              color: Colors.transparent,
                              child: Text(leave.title),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showLeaveDetailsDialog(
                                context,
                                leave.description,
                              );
                            },
                            child: const Icon(
                              CupertinoIcons.info_circle,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> showLeaveDetailsDialog(
    BuildContext context,
    String description,
  ) {
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.only(
            top: screenHeight * 0.3,
            right: 20,
            left: 0,
            bottom: 0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.55,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withValues(alpha: 0.2)),
            ),
            padding: const EdgeInsets.only(
              left: 20,
              top: 10,
              bottom: 10,
              right: 10,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              child: Text(description),
            ),
          ),
        );
      },
    );
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
        // multiRequestPerson.add(list.name);
      }
      // selectedValue = requestPersonList.first.name;
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
        // multiReformPerson.add(list.name);
      }
      //reformSelectedValue = reformPersonList.first.name;
      update();
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    isReform = false;
    update();
  }

  void clearLeaveFormData() {
    duration = 'Choose Date';
    multiReformID.clear();
    multiRequestID.clear();
    dynamicReformPersonList.clear();
    dynamicRequestPersonList.clear();
    startDate = '';
    endDate = '';
    selectedRadio = 0;
    radioValue = '';
    leaveTypeID = '';
    leaveType = '';
    txtReasonController.clear();
    selectedImages.clear();
    selectedImagesBase64.clear();
  }

  //Leave Request
  Future<void> postLeaveRequestForm() async {
    isLeaveRequest = true;
    update();
    try {
      superPrint(leaveTypeID);
      superPrint('Sending ${selectedImagesBase64.length} images to API');
      superPrint(
        'Images base64 lengths: ${selectedImagesBase64.map((img) => img.length).toList()}',
      );

      http.Response? response = await Network().leaveFormRequest(
        leaveTypeID,
        startDate,
        endDate,
        radioValue,
        multiRequestID,
        multiReformID,
        txtReasonController.text,
        selectedImagesBase64.toList(),
      ); // Convert RxList to List
      superPrint(response?.statusCode, title: "Status Code");
      superPrint(response?.body);
      tooManyRequest(response?.statusCode ?? 429);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        selectedImages.value = [];
        selectedImagesBase64.value = [];
        fetchLeaveHistory(dateFrom, dateTo);
        Get.find<NavBarController>().indexWidgets[1];
        fetchAllLeaveType();
        showSuccessAlert('Request Sent!', () {
          clearLeaveFormData();
          Get.back();
          Get.back();
        });
        update();
      } else if (response?.statusCode == 400 || response?.statusCode == 500) {
        showAlert(jsonDecode(response!.body)['response']['message']);
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode != 429) {
        showAlert(jsonDecode(response!.body)['message']);
      }
    } catch (e) {
      isLeaveRequest = false;
      superPrint(e);
    }
    isLeaveRequest = false;
    update();
  }

  Future<void> postEditLeaveRequestForm() async {
    isLeaveRequest = true;
    update();
    try {
      superPrint(leaveTypeID);
      http.Response? response = await Network().editleaveFormRequest(
        leaveID,
        leaveTypeID,
        startDate,
        endDate,
        radioValue,
        multiRequestID,
        multiReformID,
        txtReasonController.text,
        selectedImagesBase64.toList(),
      ); // Convert RxList to List
      superPrint(response?.statusCode, title: "Status Code");
      superPrint(response?.body);
      tooManyRequest(response?.statusCode ?? 429);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        selectedImages.value = [];
        fetchLeaveHistory(dateFrom, dateTo);
        Get.find<NavBarController>().indexWidgets[1];
        fetchAllLeaveType();
        showSuccessAlert('Edit Request Sent!', () {
          clearLeaveFormData();
          fetchLeaveDetails(leaveID);
          Get.back();
          Get.back();
        });
        update();
      } else if (response?.statusCode == 400) {
        showAlert(jsonDecode(response!.body)['response']['message']);
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode != 429) {
        showAlert(jsonDecode(response!.body)['response']['message']);
      }
    } catch (e) {
      isLeaveRequest = false;
      superPrint(e);
    }
    isLeaveRequest = false;
    update();
  }

  //Leave History
  Future<void> fetchLeaveHistory(String from, String to) async {
    leaveHistoryList.clear();
    isLeaveHistory = true;
    update();
    try {
      //superPrint('$from $to', title: 'Date Format');
      http.Response? response = await Network().getLeaveHistory(from, to);
      var result = jsonDecode(response!.body);

      superPrint('result $result');
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = LeaveHistory.fromJson(data);
          leaveHistoryList.add(list);
          superPrint('---- hello ${list.id}');
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['response']['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isLeaveHistory = false;
    update();
  }

  /*
  Detail Leave Request Employee
*/
  Future<void> fetchLeaveDetails(String leaveID) async {
    isDetail = true;
    update();
    try {
      http.Response? response = await Network().getEmployeeLeaveDetailByID(
        leaveID,
      );
      var result = jsonDecode(response!.body);
      superPrint('result ${result['data']}');
      superPrint(
        'leave request image ${result['data']['leave_request_images']}',
      );
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['data'] != null) {
          var data = EmployeeLeaveRequestDetail.fromJson(result['data']);
          leaveType = data.leaveType;
          setAttachedImages(list: data.leaveImages ?? []);
          detailsLeave = EmployeeLeaveRequestDetail(
            id: data.id,
            employeeId: data.employeeId,
            name: data.name,
            position: data.position,
            department: data.department,
            image: data.image,
            leaveType: data.leaveType,
            leaveTypeID: data.leaveTypeID,
            dateFrom: data.dateFrom,
            dateTo: data.dateTo,
            status: data.status,
            duration: data.duration,
            reason: data.reason,
            remark: data.remark,
            requestpersonlist: data.requestpersonlist,
            leaveImages: data.leaveImages ?? [],
            informToPerson: data.informToPerson,
          );
        }
        update();
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['response']['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isDetail = false;
    update();
  }

  Future<void> setAttachedImages({required List<LeaveImages> list}) async {
    attachedImages = list;
    final result = await convertLeaveImagesToBase64(list);
    selectedImagesBase64.assignAll(result);
    update();
  }

  Future<List<String>> convertLeaveImagesToBase64(
    List<LeaveImages> leaveImages,
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

  //Approvel and Reject Leave
  void postLeaveRequestApproveReject(
    String approval,
    String rejection,
    String id,
    String leaveTypeID,
  ) async {
    isApproval = true;
    update();
    try {
      http.Response? response = await Network().approveRejectLeaveRequest(
        approval,
        rejection,
        txtRemarkController.text,
        id,
        leaveTypeID,
      );
      superPrint(response?.statusCode, title: "Status Code");
      superPrint(response?.body);
      tooManyRequest(response?.statusCode ?? 429);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        Get.find<LeaveRequestHistoryController>().fetchAllLeaveRequest();
        Get.find<DashboardController>().fetchAttendanceCount();
        txtRemarkController.clear();
        showSuccessAlert(jsonDecode(response!.body)['response']['message'], () {
          Get.back();
          Get.back();
        });
        update();
      } else if (response?.statusCode == 401) {
        validateLogout();
      } else if (response?.statusCode != 429) {
        showAlert(jsonDecode(response!.body)['response']['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isApproval = false;
    update();
  }
}
