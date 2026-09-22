class DutyBranch {
  final String id;
  final String name;

  DutyBranch({required this.id, required this.name});

  /// From API JSON
  factory DutyBranch.fromJson(Map<String, dynamic> json) {
    return DutyBranch(id: json['id'] as String, name: json['name'] as String);
  }
}

class DutyDepartment {
  final String id;
  final String branchId;
  final String name;

  DutyDepartment({
    required this.id,
    required this.branchId,
    required this.name,
  });

  /// From API JSON
  factory DutyDepartment.fromJson(Map<String, dynamic> json) {
    return DutyDepartment(
      id: json['id'] as String,
      branchId: json['branch_id'] as String,
      name: json['name'] as String,
    );
  }
}

class DutyPosition {
  final String id;
  final String name;
  final String branchId;
  final String departmentId;

  DutyPosition({
    required this.id,
    required this.name,
    required this.branchId,
    required this.departmentId,
  });

  /// From API JSON
  factory DutyPosition.fromJson(Map<String, dynamic> json) {
    return DutyPosition(
      id: json['id'] as String,
      name: json['name'] as String,
      branchId: json['branch_id'] ?? "-",
      departmentId: json['department_id'] ?? "-",
    );
  }
}

class DutyEmployee {
  final String id;
  final String branchId;
  final String departmentId;
  final String positionId;
  final String name;
  final String empNo;

  DutyEmployee({
    required this.id,
    required this.branchId,
    required this.departmentId,
    required this.positionId,
    required this.name,
    required this.empNo,
  });

  /// From API JSON
  factory DutyEmployee.fromJson(Map<String, dynamic> json) {
    return DutyEmployee(
      id: json['id'] as String,
      branchId: json['branch_id'] as String,
      departmentId: json['department_id'] as String,
      positionId: json['position_id'] as String,
      name: json['name'] as String,
      empNo: json['employee_no'] ?? "-",
    );
  }
}

class DutyName {
  final int id;
  final String name;
  final String branchId;
  final String departmentId;
  final String positionId;

  DutyName({
    required this.id,
    required this.name,
    required this.branchId,
    required this.departmentId,
    required this.positionId,
  });

  /// From API JSON
  factory DutyName.fromJson(Map<String, dynamic> json) {
    return DutyName(
      id: json['id'] as int,
      name: json['name'] as String,
      branchId: json['branch_id'] as String,
      departmentId: json['department_id'] as String,
      positionId: json['position_id'] as String,
    );
  }
}

class Task {
  final int id;
  final int performanceManagementId;
  final String name;
  final String description;
  final String priority;
  final String? img;
  final String? timeFrom;
  final String? timeTo;
  final String? createdAt;
  final String? updatedAt;

  Task({
    required this.id,
    required this.performanceManagementId,
    required this.name,
    required this.description,
    required this.priority,
    this.img,
    this.timeFrom,
    this.timeTo,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      performanceManagementId: json['performance_management_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? '',
      img: json['img'],
      timeFrom: json['time_from'],
      timeTo: json['time_to'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class DutyListResponse {
  ResponseModel? response;
  DutyWrapper? data;

  DutyListResponse({this.response, this.data});

  factory DutyListResponse.fromJson(Map<String, dynamic> json) {
    return DutyListResponse(
      response: json['response'] != null
          ? ResponseModel.fromJson(json['response'])
          : null,
      data: json['data'] != null ? DutyWrapper.fromJson(json['data']) : null,
    );
  }
}

class ResponseModel {
  String? status;
  String? message;

  ResponseModel({this.status, this.message});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(status: json['status'], message: json['message']);
  }
}

class DutyWrapper {
  DutyPagination? duties;

  DutyWrapper({this.duties});

  factory DutyWrapper.fromJson(Map<String, dynamic> json) {
    return DutyWrapper(
      duties: json['duties'] != null
          ? DutyPagination.fromJson(json['duties'])
          : null,
    );
  }
}

class DutyPagination {
  int? currentPage;
  int? lastPage;
  int? total;

  List<DutyModel>? data;

  DutyPagination({this.currentPage, this.lastPage, this.total, this.data});

  factory DutyPagination.fromJson(Map<String, dynamic> json) {
    return DutyPagination(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      total: json['total'],
      data: json['data'] != null
          ? List<DutyModel>.from(json['data'].map((e) => DutyModel.fromJson(e)))
          : [],
    );
  }
}

class DutyModel {
  String? id;
  String? branchId;
  String? departmentId;
  String? sectionId;
  String? positionId;
  String? performanceManagementId;
  String? name;
  String? fromDate;
  String? toDate;
  int? createdBy;
  int? updatedBy;
  String? status;
  String? branchName;
  String? deptName;
  String? performanceManagementName;
  int? doneTask;
  int? approvedTask;
  int? rejectedTask;
  int? taskCount;
  String? createdAt;
  String? updatedAt;

  DutyModel({
    this.id,
    this.branchId,
    this.departmentId,
    this.sectionId,
    this.positionId,
    this.performanceManagementId,
    this.name,
    this.fromDate,
    this.toDate,
    this.createdBy,
    this.updatedBy,
    this.status,
    this.branchName,
    this.deptName,
    this.performanceManagementName,
    this.doneTask,
    this.approvedTask,
    this.rejectedTask,
    this.taskCount,
    this.createdAt,
    this.updatedAt,
  });

  factory DutyModel.fromJson(Map<String, dynamic> json) {
    return DutyModel(
      id: json['id'],
      branchId: json['branch_id'],
      departmentId: json['department_id'],
      sectionId: json['section_id'],
      positionId: json['position_id'],
      performanceManagementId: json['performance_management_id'],
      name: json['name'],
      fromDate: json['from_date'],
      toDate: json['to_date'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      status: json['status'],
      branchName: json['branch_name'],
      deptName: json['department_name'],
      performanceManagementName: json['performance_management_name'],
      doneTask: json['done_tasks'],
      approvedTask: json['approved_tasks'],
      rejectedTask: json['rejected_tasks'],
      taskCount: json['tasks_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class HODDutyEmpListResponse {
  bool? status;
  String? message;
  HODAssignEmpList? data;

  HODDutyEmpListResponse({this.status, this.message, this.data});

  factory HODDutyEmpListResponse.fromJson(Map<String, dynamic> json) {
    return HODDutyEmpListResponse(
      status: json["response"]?["status"] == "success",
      message: json["response"]?["message"],
      data: json["data"] != null
          ? HODAssignEmpList.fromJson(json["data"])
          : null,
    );
  }
}

class HODAssignEmpList {
  String currentPage;
  int? lastPage;
  List<HODAssignEmpData>? data;

  HODAssignEmpList({required this.currentPage, this.lastPage, this.data});

  factory HODAssignEmpList.fromJson(Map<String, dynamic> json) =>
      HODAssignEmpList(
        currentPage: json['current_page'].toString(),
        lastPage: json['last_page'],
        data: json["data"] == null
            ? []
            : List<HODAssignEmpData>.from(
                json["data"].map((x) => HODAssignEmpData.fromJson(x)),
              ),
      );
}

class HODAssignEmpData {
  String empID;
  String? empName;
  String? branchName;
  String? departName;
  String? positionName;
  int? totalDuties;

  HODAssignEmpData({
    required this.empID,
    this.empName,
    this.branchName,
    this.departName,
    this.positionName,
    this.totalDuties,
  });

  factory HODAssignEmpData.fromJson(Map<String, dynamic> json) =>
      HODAssignEmpData(
        empID: json['id'],
        empName: json["employee_name"],
        branchName: json["branch_name"],
        departName: json["department_name"],
        positionName: json["position_name"],
        totalDuties: json["total_duties"],
      );
}

class AssignDutyDetailData {
  final String id;
  final String branchId;
  final String departmentId;
  final String positionId;
  final int pmId;
  final List<AssignDutyTask> dutyTasks;
  final List<AssignDutyEmployeeInfo> employees;
  final double progress;
  final String fromDate;
  final String toDate;
  final String branchName;
  final String departmentName;
  final String positionName;
  final String pmName;

  AssignDutyDetailData({
    required this.id,
    required this.branchId,
    required this.departmentId,
    required this.positionId,
    required this.pmId,
    required this.dutyTasks,
    required this.employees,
    required this.progress,
    required this.fromDate,
    required this.toDate,
    required this.branchName,
    required this.departmentName,
    required this.positionName,
    required this.pmName,
  });

  factory AssignDutyDetailData.fromJson(Map<String, dynamic> json) {
    List<AssignDutyEmployeeInfo> employeeList = (json['dutyEmployees'] as List)
        .map((e) => AssignDutyEmployeeInfo.fromJson(e))
        .toList();

    Map<String, dynamic> empLookup = {
      for (var e in json['dutyEmployees']) e['id'].toString(): e,
    };

    return AssignDutyDetailData(
      id: json['duty']['id'],
      branchId: json['duty']['branch_id'],
      departmentId: json['duty']['department_id'],
      positionId: json['duty']['position_id'],
      pmId: json['duty']['performance_management_id'] == null
          ? -1
          : int.parse(json['duty']['performance_management_id'].toString()),
      fromDate: json['duty']['from_date'] ?? "",
      toDate: json['duty']['to_date'] ?? "",
      progress: (json['dutyProgress'] ?? 0.0).toDouble(),
      employees: employeeList,
      dutyTasks: (json['duty']['duty_tasks'] as List).map((taskJson) {
        String empId = taskJson['employee_id'].toString();
        var empInfo = empLookup[empId];

        return AssignDutyTask.fromJson(
          taskJson,
          empName: empInfo != null ? empInfo['name'] : "Unknown",
          empNo: empInfo != null ? empInfo['employee_no'] : "-",
        );
      }).toList(),
      branchName: json['duty']['branch_name'] ?? '-',
      departmentName: json['duty']['department_name'] ?? '-',
      positionName: json['duty']['position_name'] ?? '-',
      pmName: json['duty']['performance_management_name'] ?? '-',
    );
  }
}

class AssignDutyEmployeeInfo {
  final String id;
  final String name;
  final String empNo;
  final String branchId;
  final String departmentId;
  final String positionId;

  AssignDutyEmployeeInfo({
    required this.id,
    required this.name,
    required this.empNo,
    required this.branchId,
    required this.departmentId,
    required this.positionId,
  });

  factory AssignDutyEmployeeInfo.fromJson(Map<String, dynamic> json) =>
      AssignDutyEmployeeInfo(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        empNo: json['employee_no'] ?? '',
        branchId: json['branch_id'] ?? '',
        departmentId: json['department_id'] ?? '',
        positionId: json['position_id'],
      );
}

class AssignDutyTask {
  final int id;
  final String dutyId;
  final String employeeId;
  final String name;
  final String priority;
  final String status;
  final String requestStatus;
  final String? remark;
  final String date;
  final String description;
  final String? timeFrom;
  final String? timeTo;
  final String? subName;
  final String? subReason;
  final String? subStatus;
  final String? subDesc;
  final String intervalStatus;
  final bool extend;
  final String extendStatus;
  final String extendReason;
  final int extendDays;
  final int? duration;
  final bool substitute;
  final String? img;
  final String employeeName;
  final String employeeNo;

  AssignDutyTask({
    required this.id,
    required this.dutyId,
    required this.employeeId,
    required this.name,
    required this.priority,
    required this.status,
    required this.requestStatus,
    this.remark,
    required this.date,
    required this.description,
    this.timeFrom,
    this.timeTo,
    this.subName,
    this.subReason,
    this.subStatus,
    this.subDesc,
    required this.intervalStatus,
    required this.extend,
    required this.extendStatus,
    required this.extendReason,
    required this.extendDays,
    this.duration,
    required this.substitute,
    this.img,
    required this.employeeName,
    required this.employeeNo,
  });

  factory AssignDutyTask.fromJson(
    Map<String, dynamic> json, {
    String empName = "Unknown",
    String empNo = "-",
  }) {
    return AssignDutyTask(
      id: json['id'] ?? 0,
      dutyId: json['duty_id'] ?? "",
      employeeId: json['employee_id'] ?? "",
      name: json['name'] ?? "-",
      priority: json['priority'] ?? "normal",
      status: json['status'] ?? "to_do",
      requestStatus: json['request_status'] ?? "pending",
      remark: json['remark'] ?? "-",
      date: json['job_date'] ?? "-",
      description: json['description'] ?? "-",
      timeFrom: json['time_from'] ?? "",
      timeTo: json['time_to'] ?? "",
      subName: json['sub_name'] ?? "-",
      subReason: json['sub_reason'] ?? "-",
      subStatus: json['sub_status'] ?? "-",
      subDesc: json['sub_description'] ?? "-",
      intervalStatus: json['interval_status'] ?? "daily",
      extend: json['extend'] == 1 ? true : false,
      duration: json['duration'] is int
          ? json['duration']
          : int.tryParse(json['duration'].toString()),
      extendStatus: json['extend_status'] ?? "pending",
      extendReason: json['extend_reason'] ?? "",
      extendDays: json['extend_days'] ?? 0,
      substitute: json['substitute'] == 1 ? true : false,
      img: json['img'] ?? "",
      employeeName: empName,
      employeeNo: empNo,
    );
  }
}
