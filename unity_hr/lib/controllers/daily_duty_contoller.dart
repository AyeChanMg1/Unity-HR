import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/daily_duty.dart';
import 'package:unity_hr/models/duty_assign.dart';

class DailyDutyController extends GetxController {
  int progress = 0;

  double approvalRate = 50.0;
  bool xBranches = false;
  List<DutyBranch> dutyBranches = [];
  String? branchId;
  String branchName = "Select Branch";

  bool xDepartments = false;
  List<DutyDepartment> dutyDepartments = [];
  String? departmentId;
  String departmentName = "Select Department";

  bool xPositions = false;
  List<DutyPosition> dutyPositions = [];
  String? positionId;
  String positionName = "Select Position";

  bool xEmployees = false;
  List<DutyEmployee> dutyEmployees = [];

  List<DailyDutyData> dailyDutyList = [];
  bool isLoadingList = false;
  int currentPage = 1;
  int lastPage = 1;
  int totalEntries = 0;

  List<DailyDutyData> workDoneEmpList = [];
  bool isWorkDone = false;
  DailyDutyDetails? workDoneTaskDetails;
  bool isWorkDoneDetails = false;

  // List Filter IDs (distinguished from creation IDs)
  String listBranchId = "all";
  String listDeptId = "all";
  String listEmpId = "all";

  // List Filter Display Names
  String listBranchName = "All Branches";
  String listDeptName = "All Departments";
  String listEmpName = "All Employees";

  DateTime filterDateTime = DateTime.now();
  DateTime workDoneDate = DateTime.now();

  DailyDutyDetails? dailyDutyDetails;
  bool isLoadingDetail = false;

  TextEditingController remarkTxtController = TextEditingController();
  final TextEditingController progressTxtController = TextEditingController();

  String formatDateTime() {
    return DateFormat("yyyy-MM-dd").format(filterDateTime);
  }

  String formatWorkDoneDateTime() {
    return DateFormat("yyyy-MM-dd").format(workDoneDate);
  }

  @override
  void onInit() {
    super.onInit();
    progress = 0;
    progressTxtController.text = progress.toString();
    fetchDailyDutyRequestList();
    fetchWorkDoneEmpList();
    branches();
    filterDepartments();
    filterDepartments();
  }

  void updateProgress(int value) {
    progress = value.clamp(0, 100);
    progressTxtController.text = progress.toString();
    update();
  }

  Future<void> fetchDailyDutyDetails(String id, String date) async {
    isLoadingDetail = true;
    update(['daily_duty_detail_view']);

    try {
      http.Response? response = await Network().getDailyDutyRequestDetails(
        id,
        date,
      );
      if (response != null && response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        // Map the "data" section of your provided JSON
        dailyDutyDetails = DailyDutyDetails.fromJson(decoded['data']);
      }
    } catch (e) {
      superPrint("Error fetching details: $e");
    }

    isLoadingDetail = false;
    update(['daily_duty_detail_view']);
  }

  Future<void> fetchWorkDoneDetails(String id, String date) async {
    isWorkDoneDetails = true;
    update(['work_done_detail_view']);

    try {
      http.Response? response = await Network().getWorkDoneTaskList(id, date);
      debugPrint(jsonDecode(response!.body)['data']);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        // Map the "data" section of your provided JSON
        workDoneTaskDetails = DailyDutyDetails.fromJson(decoded['data']);
      }
    } catch (e) {
      superPrint("Error fetching details: $e");
    }

    isWorkDoneDetails = false;
    update(['work_done_detail_view']);
  }

  Future<void> fetchDailyDutyRequestList({int page = 1}) async {
    isLoadingList = true;
    update(['daily_duty_list']);

    final response = await Network().getDailyDutyRequestList(
      branchId: listBranchId,
      departmentId: listDeptId,
      employeeId: listEmpId,
      date: formatDateTime(),
      page: page,
    );

    if (response != null && response.statusCode == 200) {
      final resModel = DailyDutyResponse.fromJson(
        jsonDecode(response.body)['data'],
      );
      dailyDutyList = resModel.data;
      currentPage = resModel.currentPage ?? 1;
      lastPage = resModel.lastPage ?? 1;
      totalEntries = resModel.total ?? 0;
    }

    isLoadingList = false;
    update(['daily_duty_list']);
  }

  Future<void> fetchWorkDoneEmpList() async {
    isWorkDone = true;
    update(['work_done_list']);

    final response = await Network().getWorkDoneList(
      date: formatWorkDoneDateTime(),
    );

    if (response != null && response.statusCode == 200) {
      debugPrint(response.body);
      final resModel = DailyDutyResponse.fromJson(
        jsonDecode(response.body)['data'],
      );
      workDoneEmpList = resModel.data;
    }

    isWorkDone = false;
    update(['work_done_list']);
  }

  // --- Filter Selection Logic ---
  void selectBranchFilter(DutyBranch b) {
    listBranchId = b.id;
    listBranchName = b.name;

    // Reset dependent filters
    listDeptId = "all";
    listDeptName = "All Departments";
    listEmpId = "all";
    listEmpName = "All Employees";

    filterDepartments(); // Fetch depts for selected branch
    filterEmployees(); // Fetch emps for selected branch
    fetchDailyDutyRequestList(page: 1);
    update(['filter_dialog']);
  }

  void selectDeptFilter(DutyDepartment d) {
    listDeptId = d.id;
    listDeptName = d.name;

    listEmpId = "all";
    listEmpName = "All Employees";

    filterEmployees(); // Fetch emps for selected dept
    fetchDailyDutyRequestList(page: 1);
    update(['filter_dialog']);
  }

  void selectEmpFilter(DutyEmployee e) {
    listEmpId = e.id;
    listEmpName = e.name;
    fetchDailyDutyRequestList(page: 1);
    update(['filter_dialog']);
  }

  void selectDateFilter(DateTime d) {
    filterDateTime = d;
    fetchDailyDutyRequestList(page: 1);
    update(['filter_dialog']);
  }

  void selectWorkDoneDate(DateTime d) {
    workDoneDate = d;
    fetchWorkDoneEmpList();
    update();
  }

  Future<void> branches() async {
    xBranches = true;
    update(['branches', 'filter_dialog']);
    try {
      http.Response? response = await Network().getBranches();
      if (response != null && response.statusCode == 200) {
        var result = jsonDecode(response.body);
        dutyBranches.clear();
        dutyBranches.add(DutyBranch(id: "all", name: "All Branches"));
        for (var e in result['data']) {
          dutyBranches.add(DutyBranch.fromJson(e));
        }
      }
    } catch (e) {
      superPrint(e);
    }
    xBranches = false;
    update(['branches', 'filter_dialog']);
  }

  Future<void> filterDepartments() async {
    xDepartments = true;
    update(['filter_dialog']);
    try {
      http.Response? response = await Network().getDepartments(listBranchId);
      if (response != null && response.statusCode == 200) {
        var result = jsonDecode(response.body);
        dutyDepartments.clear();
        dutyDepartments.add(
          DutyDepartment(
            id: "all",
            branchId: listBranchId,
            name: "All Departments",
          ),
        );
        for (var e in result['data']) {
          dutyDepartments.add(DutyDepartment.fromJson(e));
        }
      }
    } catch (e) {
      superPrint(e);
    }
    xDepartments = false;
    update(['filter_dialog']);
  }

  Future<void> filterEmployees() async {
    xEmployees = true;
    update(['filter_dialog']);
    try {
      http.Response? response = await Network().getFilterEmployees(
        listBranchId,
        listDeptId,
      );
      if (response != null && response.statusCode == 200) {
        var result = jsonDecode(response.body);
        dutyEmployees.clear();
        dutyEmployees.add(
          DutyEmployee(
            id: "all",
            branchId: listBranchId,
            departmentId: listDeptId,
            positionId: "-",
            name: "All Employees",
            empNo: "-",
          ),
        );
        for (var e in result['data']) {
          dutyEmployees.add(DutyEmployee.fromJson(e));
        }
      }
    } catch (e) {
      superPrint(e);
    }
    xEmployees = false;
    update(['filter_dialog']);
  }

  Future<void> dailyDutyApproveRejectRequest(
    String id,
    String status,
    String remark,
    String empId,
    String date,
    // int taskDonePercentage,
  ) async {
    progress = int.tryParse(progressTxtController.text) ?? 0;
    progress = status == 'rejected' ? 0 : progress.clamp(0, 100);

    showLoadingAlert(message: "Requesting...");

    try {
      http.Response? response = await Network().dailyDutyApproveReject(
        id,
        status,
        remark,
        progress,
      );
      if (response != null && response.statusCode == 200) {
        await fetchDailyDutyDetails(empId, date);
        await fetchDailyDutyRequestList();
        Get.back();
        Get.back();
        // Get.snackbar(
        //     "Success", "${jsonDecode(response.body)['response']['message']}",
        //     snackPosition: SnackPosition.BOTTOM);
        AppToast.showSuccess(
          "${jsonDecode(response.body)['response']['message']}",
        );
      } else {
        // Get.snackbar(
        //     "Error", "Could not approve-reject duty. Please try again.");
        AppToast.showError("Could not approve-reject duty. Please try again.");
      }
    } catch (e) {
      superPrint("ApproveReject Error: $e");
    }
  }
}
