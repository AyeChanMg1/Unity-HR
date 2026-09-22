import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/duty_assign.dart';
import 'package:unity_hr/models/duty_request.dart';

class DutyAssignController extends GetxController {
  bool xDutyRequests = false;
  List<DutyRequest> dutyRequestList = [];

  bool xDutyRequestHistory = false;
  List<DutyRequest> dutyRequestHistoryList = [];

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

  bool xDutyName = false;
  List<DutyName> dutyNames = [];
  int? dutyNameId;
  String dutyNameLabel = "Select Duty Name";

  bool xTask = false;
  List<Task> tasks = [];

  bool isSubmitting = false;

  // --- List View Specific Variables ---

  // List<DutyData> dutyList = [];
  HODAssignEmpList? hodAssignEmpList;
  List<DutyModel> dutyList = [];
  // bool isLoadingList = false;
  bool isLoadingEmployeeList = false;
  bool isLoadingDutyList = false;
  int currentPage = 1;
  int lastPage = 1;
  int totalEntries = 0;

  int dutyCurrentPage = 1;
  int dutyLastPage = 1;
  int dutyTotalEntries = 0;

  // List Filter IDs (distinguished from creation IDs)
  String listBranchId = "all";
  String listDeptId = "all";
  String listEmpId = "all";

  // List Filter Display Names
  String listBranchName = "All Branches";
  String listDeptName = "All Departments";
  String listEmpName = "All Employees";

  AssignDutyDetailData? selectedDutyDetail;
  bool isLoadingDetail = false;

  @override
  void onInit() {
    super.onInit();
    // fetchHODAssignDutyList();
    // fetchHODAssignDutyEmpList();
    // Future.delayed(Duration.zero, () {
    //   // initial API calls
    // });
    fetchHODAssignDutyEmpList();
    branches();
    departments();
    positions();
    employees();
    filterDepartments();
    filterEmployees();
    dutyRequests();
    dutyRequestHistories(DateFormat("yyyy-MM-dd").format(DateTime.now()));
  }

  Future<void> fetchDutyDetails(String id) async {
    isLoadingDetail = true;
    selectedDutyDetail = null;
    update(['duty_detail_view']);

    try {
      http.Response? response = await Network().getHodDutyAssignDetails(id);
      if (response != null && response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        // Map the "data" section of your provided JSON
        selectedDutyDetail = AssignDutyDetailData.fromJson(decoded['data']);
      }
    } catch (e) {
      superPrint("Error fetching details: $e");
    } finally {
      isLoadingDetail = false;

      update(['duty_detail_view']);
    }

    // isLoadingDetail = false;
    // update(['duty_detail_view']);
  }

  // Future<void> fetchHODAssignDutyList({int page = 1}) async {
  //   isLoadingList = true;
  //   update(['duty_list']);

  //   final response = await Network().getHodDutyAssignList(
  //     branchId: listBranchId,
  //     departmentId: listDeptId,
  //     employeeId: listEmpId,
  //     dutyId: "all", // Passing "all" as duty filter is removed
  //     page: page,
  //   );

  //   if (response != null && response.statusCode == 200) {
  //     final resModel = DutyListResponse.fromJson(jsonDecode(response.body));
  //     dutyList = resModel.data ?? [];
  //     currentPage = resModel.meta?.currentPage ?? 1;
  //     lastPage = resModel.meta?.lastPage ?? 1;
  //     totalEntries = resModel.meta?.total ?? 0;
  //   }

  //   isLoadingList = false;
  //   update(['duty_list']);
  // }

  Future<void> fetchHODAssignDutyEmpList({int page = 1}) async {
    isLoadingEmployeeList = true;
    update(['employee_list']);

    final response = await Network().getHodDutyEmployeeList(
      branchId: listBranchId,
      departmentId: listDeptId,
      employeeId: listEmpId,
      dutyId: "all",
      page: page,
    );

    if (response != null && response.statusCode == 200) {
      final resModel = HODDutyEmpListResponse.fromJson(
        jsonDecode(response.body),
      );

      hodAssignEmpList = resModel.data;

      // pagination (IMPORTANT)
      currentPage = int.tryParse(resModel.data?.currentPage ?? "1") ?? 1;
      lastPage = resModel.data?.lastPage ?? currentPage; // if you add it later
    }

    isLoadingEmployeeList = false;
    update(['employee_list']);
  }

  Future<void> fetchHODAssignEmpDutyList(String id, {int page = 1}) async {
    isLoadingDutyList = true;
    update(['duty_list']);
    dutyList.clear();
    final response = await Network().getHodAssignDutyEmpDetail(id, page: page);

    if (response != null && response.statusCode == 200) {
      final resModel = DutyListResponse.fromJson(jsonDecode(response.body));

      dutyList = resModel.data?.duties?.data ?? [];

      dutyCurrentPage = resModel.data?.duties?.currentPage ?? 1;
      dutyLastPage = resModel.data?.duties?.lastPage ?? 1;
      dutyTotalEntries = resModel.data?.duties?.total ?? 0;

      debugPrint(dutyList.length.toString());
    }

    isLoadingDutyList = false;
    update(['duty_list']);
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
    // fetchHODAssignDutyList(page: 1);
    fetchHODAssignDutyEmpList(page: 1);
    update(['filter_dialog']);
  }

  void selectDeptFilter(DutyDepartment d) {
    listDeptId = d.id;
    listDeptName = d.name;

    listEmpId = "all";
    listEmpName = "All Employees";

    filterEmployees(); // Fetch emps for selected dept
    // fetchHODAssignDutyList(page: 1);
    fetchHODAssignDutyEmpList(page: 1);
    update(['filter_dialog']);
  }

  void selectEmpFilter(DutyEmployee e) {
    listEmpId = e.id;
    listEmpName = e.name;
    // fetchHODAssignDutyList(page: 1);
    fetchHODAssignDutyEmpList(page: 1);
    update(['filter_dialog']);
  }

  void showBottomMessage(String title, String message, {bool isError = true}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError
          ? Colors.red.withValues(alpha: 0.9)
          : Colors.black.withValues(alpha: 0.8),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  // --- API FETCH METHODS ---
  Future<void> dutyRequests() async {
    xDutyRequests = true;
    update(['duty_requests']);
    dutyRequestList.clear();
    try {
      http.Response? response = await Network().getDutyApproveRejectList();
      if (response != null && response.statusCode == 200) {
        var result = jsonDecode(response.body);
        for (var e in result['data']['dutyTasks']) {
          dutyRequestList.add(DutyRequest.fromJson(e));
        }
      }
    } catch (e) {
      superPrint(e);
    }
    xDutyRequests = false;
    update(['duty_requests']);
  }

  Future<void> dutyRequestHistories(String date) async {
    xDutyRequestHistory = true;
    update(['duty_request_history']);
    dutyRequestHistoryList.clear();
    try {
      http.Response? response = await Network().getDutyApproveRejectHistoryList(
        date,
      );
      if (response != null && response.statusCode == 200) {
        var result = jsonDecode(response.body);
        for (var e in result['data']['dutyTasks']) {
          dutyRequestHistoryList.add(DutyRequest.fromJson(e));
        }
      }
    } catch (e) {
      superPrint(e);
    }
    xDutyRequestHistory = false;
    update(['duty_request_history']);
  }

  Future<void> branches() async {
    xBranches = true;
    update(['branches', 'filter_dialog']);
    try {
      http.Response? response = await Network().getBranches();
      if (response != null && response.statusCode == 200) {
        var result = jsonDecode(response.body);
        dutyBranches.clear();
        // dutyBranches.add(DutyBranch(id: "all", name: "All Branches"));
        for (var e in result['data']) {
          dutyBranches.add(DutyBranch.fromJson(e));
        }

        if (dutyBranches.isNotEmpty) {
          branchId = dutyBranches.first.id;
          branchName = dutyBranches.first.name;
          departments();
        }
      }
    } catch (e) {
      superPrint(e);
    }
    xBranches = false;
    update(['branches', 'filter_dialog']);
  }

  Future<void> departments() async {
    if (branchId == null) return;
    xDepartments = true;
    update(['departments']);
    try {
      http.Response? response = await Network().getDepartments(branchId!);
      if (response != null && response.statusCode == 200) {
        var result = jsonDecode(response.body);
        dutyDepartments.clear();
        // dutyDepartments.add(DutyDepartment(id: "all", branchId: branchId!, name: "All Departments"));
        for (var e in result['data']) {
          dutyDepartments.add(DutyDepartment.fromJson(e));
        }

        if (dutyDepartments.isNotEmpty) {
          departmentId = dutyDepartments.first.id;
          departmentName = dutyDepartments.first.name;
          positions();
        }
      }
    } catch (e) {
      superPrint(e);
    }
    xDepartments = false;
    update(['departments']);
  }

  Future<void> positions() async {
    xPositions = true;
    update(['positions']);
    try {
      http.Response? response = await Network().getPositions();
      if (response != null && response.statusCode == 200) {
        var result = jsonDecode(response.body);
        dutyPositions.clear();
        for (var e in result['data']) {
          dutyPositions.add(DutyPosition.fromJson(e));
        }

        if (dutyPositions.isNotEmpty) {
          positionId = dutyPositions.first.id;
          positionName = dutyPositions.first.name;
          employees();
        }
      }
    } catch (e) {
      superPrint(e);
    }
    xPositions = false;
    update(['positions']);
  }

  Future<void> employees() async {
    if (positionId == null) return;
    xEmployees = true;
    update(['employees']);
    try {
      http.Response? response = await Network().getEmployees(positionId!);
      if (response != null && response.statusCode == 200) {
        var result = jsonDecode(response.body);
        dutyEmployees.clear();
        for (var e in result['data']) {
          dutyEmployees.add(DutyEmployee.fromJson(e));
        }
      }
    } catch (e) {
      superPrint(e);
    }
    xEmployees = false;
    update(['employees']);
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

  Future<void> getDutyNames() async {
    if (positionId == null) return;
    xDutyName = true;
    update(['dutyNames']);
    try {
      http.Response? response = await Network().getPerformanceTasksByPosition(
        positionId!,
      );
      if (response != null && response.statusCode == 200) {
        var result = jsonDecode(response.body);
        dutyNames.clear();
        for (var e in result['data']) {
          dutyNames.add(DutyName.fromJson(e));
        }
      }
    } catch (e) {
      superPrint(e);
    }
    xDutyName = false;
    update(['dutyNames']);
  }

  Future<void> getTasks() async {
    if (dutyNameId == null) return;
    xTask = true;
    update(['tasks']);
    try {
      http.Response? response = await Network().getPerformanceTasksByPmId(
        dutyNameId!,
      );
      if (response != null && response.statusCode == 200) {
        var result = jsonDecode(response.body);
        tasks.clear();
        for (var e in result['data']) {
          tasks.add(Task.fromJson(e));
        }
      }
    } catch (e) {
      superPrint(e);
    }
    xTask = false;
    update(['tasks']);
  }

  // --- SUBMIT METHOD ---
  Future<void> createDutyAssign({
    required bool isSpecial,
    required DateTime from,
    required DateTime to,
    required List<DutyEmployee> emps,
    // required List<int> taskIds,
    required List<Map<String, dynamic>> manualInputs,
  }) async {
    isSubmitting = true;
    update(['submit_btn']);

    try {
      final df = DateFormat('dd-MM-yyyy');
      Map<String, dynamic> body = {
        "branch_id": branchId ?? "all",
        "department_id": departmentId ?? "all",
        "position_id": positionId,
        "employees": emps.map((e) => e.id).toList(),
        "from_date": df.format(from),
        "to_date": df.format(to),
        "inputs": manualInputs
            .map(
              (e) => {
                "name": e["name"],
                "priority": (e["priority"] ?? "normal").toLowerCase(),
                "description": e["desc"] ?? "",
              },
            )
            .toList(),
      };

      if (isSpecial) {
        body["interval_status"] = "interval";
        body["selected_tasks"] = "[]"; // Backend requires string empty array
      } else {
        body["performance_management_id"] = dutyNameId.toString();
        // body["selected_tasks"] = jsonEncode(taskIds); // e.sync "[2]"
        final selectedTasks = tasks.map((e) => e.id).toList();

        body["selected_tasks"] = jsonEncode(selectedTasks);

        debugPrint("selectedTasks : $selectedTasks");
      }

      http.Response? response = await Network().postDutyAssign(body);

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        // Get.back();
        // fetchHODAssignDutyList(page: 1);
        fetchHODAssignDutyEmpList(page: 1);
        // showBottomMessage("Success", "Duty Assigned Successfully",
        //     isError: false);
        AppToast.showSuccess('Duty Assigned Successfully');
      } else {
        var errorResult = jsonDecode(response!.body);
        // showBottomMessage(
        //     "Error", errorResult['message'] ?? "Failed to create duty");
        AppToast.showError(errorResult['message'] ?? "Failed to create duty");
      }
    } catch (e) {
      //   showBottomMessage("Error", "Server Connection Error");

      AppToast.showError("Server Connection Error");
    }

    isSubmitting = false;
    update(['submit_btn']);
  }

  Future<void> updateDutyAssign({
    required String dutyId,
    required bool isSpecial,
    required DateTime from,
    required DateTime to,
    required List<DutyEmployee> emps,
    required List<int> taskIds,
    required List<Map<String, dynamic>> manualInputs,
    required String empID,
  }) async {
    isSubmitting = true;
    update(['submit_btn']);
    update(['duty_list']);

    try {
      // 1. Format Dates: PHP validation demands d-m-Y
      final df = DateFormat('dd-MM-yyyy');

      // 2. Prepare Inputs as a MAP
      // We use a Map so the keys (IDs) are sent to PHP.
      // PHP: foreach ($data['inputs'] as $taskId => $taskData)
      Map<String, dynamic> inputsMap = {};

      for (var item in manualInputs) {
        // If it's a new task (no ID or temp ID), generate a unique string key that won't match a DB UUID.
        // If it's an existing task, use its actual ID.
        String key = (item['id'] != "-1")
            ? item['id']!
            : "new_${DateTime.now().microsecondsSinceEpoch}";

        inputsMap[key] = {
          "name": item["name"],
          "priority": (item["priority"] ?? "normal").toLowerCase(),
          "description": item["desc"] ?? "",
          // Default job_date to Start Date if missing (PHP needs Y-m-d format usually for storage)
          "job_date": item["job_date"]?.isNotEmpty == true
              ? item["job_date"]
              : DateFormat('yyyy-MM-dd').format(from),
          "employee_id":
              item["employee_id"] ?? (emps.isNotEmpty ? emps.first.id : null),
        };
      }

      // 3. Construct the Body
      Map<String, dynamic> body = {
        "branch_id": branchId ?? "all",
        "department_id": departmentId ?? "all",
        "position_id": positionId,
        "employees": emps.map((e) => e.id).toList(), // ["uuid1", "uuid2"]
        "from_date": df.format(from), // 20-01-2026
        "to_date": df.format(to),
        "inputs": inputsMap, // Sent as Object, not Array
        "interval_status": isSpecial ? "interval" : "normal",
      };

      // Legacy support for the 'selected_tasks' field if your backend still checks it
      if (!isSpecial) {
        body["performance_management_id"] = dutyNameId.toString();
      }

      http.Response? response = await Network().updateHodDutyAssign(
        dutyId,
        body,
      );

      // 5. Handle Response
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        Get.back(); // Close Dialog
        fetchDutyDetails(dutyId);
        // fetchHODAssignDutyList(); // Refresh Data
        fetchHODAssignDutyEmpList(); // Refresh Data
        fetchHODAssignEmpDutyList(empID); // Refresh Data
        // showBottomMessage("Success", "Duty Updated Successfully",
        //     isError: false);
        AppToast.showSuccess("Duty Updated Successfully");
      } else {
        String msg = "Failed to update duty";
        if (response != null && response.body.isNotEmpty) {
          try {
            var errorResult = jsonDecode(response.body);
            msg = errorResult['message'] ?? msg;
            // Handle Laravel Validation Errors (422)
            if (errorResult['errors'] != null) {
              msg = errorResult['errors'].values.first[0];
            }
          } catch (_) {}
        }
        // showBottomMessage("Error", msg);
        AppToast.showError(msg);
      }
    } catch (e) {
      superPrint(e.toString());
      // showBottomMessage("Error", "Server Connection Error");
      AppToast.showError("Server Connection Error");
    }

    isSubmitting = false;
    update(['submit_btn']);
    update(['duty_list']);
  }

  Future<void> deleteHodDutyAssign(String dutyId, String empId) async {
    showLoadingAlert(message: "Deleting...");
    update(['duty_list']);

    try {
      http.Response? response = await Network().deleteHodDutyAssign(dutyId);
      if (response != null && response.statusCode == 200) {
        await fetchHODAssignDutyEmpList();
        await fetchHODAssignEmpDutyList(empId);
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        Future.delayed(const Duration(milliseconds: 200), () {
          if (Get.context != null) {
            // Get.snackbar(
            //   "Success",
            //   "Duty deleted successfully",
            //   snackPosition: SnackPosition.BOTTOM,
            // );
            AppToast.showSuccess('Duty deleted successfully');
          }
        });
      } else {
        // Get.snackbar("Error", "Could not delete task. Please try again.");
        AppToast.showError("Could not delete task. Please try again.");
      }
    } catch (e) {
      Get.back();
      superPrint("Delete UI Error: $e");
    } finally {
      update(['duty_list']);
    }
  }

  Future<void> dutyAssignApproveRejectRequest(
    String id,
    String requestType,
    String isApproval,
    String isRejection,
    String? remark,
  ) async {
    showLoadingAlert(message: "Requesting...");

    try {
      http.Response? response = await Network().dutyAssignApproveRejectRequest(
        id,
        requestType,
        isApproval,
        isRejection,
        remark,
      );
      if (response != null && response.statusCode == 200) {
        await dutyRequests();
        Get.back();
        Get.back();
        // Get.snackbar("Success", "${jsonDecode(response.body)['message']}",
        //     snackPosition: SnackPosition.BOTTOM);
        AppToast.showSuccess("${jsonDecode(response.body)['message']}");
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
