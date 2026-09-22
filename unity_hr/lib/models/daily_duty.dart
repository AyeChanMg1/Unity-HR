class DailyDutyResponse {
  int? currentPage;
  List<DailyDutyData> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  DailyDutyResponse({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory DailyDutyResponse.fromJson(Map<String, dynamic> json) =>
      DailyDutyResponse(
        currentPage: json["current_page"],
        // Updated mapping to use DailyDutyData
        data: json["data"] == null
            ? []
            : List<DailyDutyData>.from(
                json["data"]!.map((x) => DailyDutyData.fromJson(x)),
              ),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );
}

class DailyDutyData {
  String id;
  String? employeeName;
  String? branchName;
  String? departmentName;
  String? positionName;
  int? totalTasks;
  String? doneTasks;
  String? approvedTasks;
  String? rejectedTasks;

  DailyDutyData({
    required this.id,
    this.employeeName,
    this.branchName,
    this.departmentName,
    this.positionName,
    this.totalTasks,
    this.doneTasks,
    this.approvedTasks,
    this.rejectedTasks,
  });

  factory DailyDutyData.fromJson(Map<String, dynamic> json) => DailyDutyData(
    id: json["id"],
    employeeName: json["employee_name"],
    branchName: json["branch_name"],
    departmentName: json["department_name"],
    positionName: json["position_name"],
    totalTasks: json["total_tasks"],
    doneTasks: json["done_tasks"],
    approvedTasks: json["approved_tasks"],
    rejectedTasks: json["rejected_tasks"],
  );
}

class DailyDutyDetails {
  String? employeeId;
  String? employeeName;
  String? branch;
  String? department;
  String? position;
  String? filterDate;
  int? percentage;
  DutySummary? summary;
  List<TaskData> tasks;

  DailyDutyDetails({
    this.employeeId,
    this.employeeName,
    this.branch,
    this.department,
    this.position,
    this.filterDate,
    this.percentage,
    this.summary,
    required this.tasks,
  });

  factory DailyDutyDetails.fromJson(Map<String, dynamic> json) =>
      DailyDutyDetails(
        employeeId: json["employee_id"],
        employeeName: json["employee_name"],
        branch: json["branch"] == null
            ? (json['branch_name'] ?? "--")
            : json['branch'],
        department: json["department"] == null
            ? (json['department_name'] ?? "--")
            : json['department'],
        position: json["position"] == null
            ? (json['position_name'] ?? "--")
            : json['position'],
        filterDate: json["filter_date"],
        percentage: json['percentage'] is int
            ? json['percentage']
            : int.tryParse(json['percentage'].toString()),
        summary: json["summary"] == null
            ? null
            : DutySummary.fromJson(json["summary"]),
        tasks: json["tasks"] == null
            ? []
            : List<TaskData>.from(
                json["tasks"]!.map((x) => TaskData.fromJson(x)),
              ),
      );
}

class DutySummary {
  int? totalTasks;
  int? doneTasks;
  int? approvedTasks;
  int? rejectedTasks;

  DutySummary({
    this.totalTasks,
    this.doneTasks,
    this.approvedTasks,
    this.rejectedTasks,
  });

  factory DutySummary.fromJson(Map<String, dynamic> json) => DutySummary(
    totalTasks: json["total_tasks"] ?? 0,
    doneTasks: json["done_tasks"] ?? 0,
    approvedTasks: json["approved_tasks"] ?? 0,
    rejectedTasks: json["rejected_tasks"] ?? 0,
  );
}

class TaskData {
  int? id;
  String? dutyId;
  String name;
  String description;
  String jobDate;
  String employeeId;
  String priority;
  String status;
  String requestStatus;
  String? remark;
  int? percentage;
  int? duration;
  String intervalStatus;
  int? substitute;
  String? subStatus;
  String? subName;
  String? subDesc;
  String? subReason;
  int? extend;
  String? extendStatus;
  String? extendReason;
  int? extendDays;
  String? img;

  TaskData({
    this.id,
    this.dutyId,
    required this.name,
    required this.description,
    required this.jobDate,
    required this.employeeId,
    required this.priority,
    required this.status,
    required this.requestStatus,
    this.remark,
    this.percentage,
    this.duration,
    required this.intervalStatus,
    this.substitute,
    this.subStatus,
    this.subName,
    this.subDesc,
    this.subReason,
    this.extend,
    this.extendStatus,
    this.extendReason,
    this.extendDays,
    this.img,
  });

  factory TaskData.fromJson(Map<String, dynamic> json) => TaskData(
    id: json["id"] ?? -1,
    dutyId: json["duty_id"] ?? "",
    name: json["name"],
    description: json["description"],
    jobDate: json["job_date"],
    employeeId: json["employee_id"],
    priority: json["priority"],
    status: json["status"],
    requestStatus: json["request_status"] ?? "pending",
    remark: json["remark"] ?? "-",
    percentage: json['percentage'] is int
        ? json['percentage']
        : int.tryParse(json['percentage'].toString()),
    duration: json['duration'] is int
        ? json['duration']
        : int.tryParse(json['duration'].toString()),
    intervalStatus: json["interval_status"] ?? "daily",
    substitute: json['substitute'] is int
        ? json['substitute']
        : int.tryParse(json['substitute'].toString()),
    subStatus: json['sub_status'] ?? "pending",
    subName: json['sub_name'] ?? "--",
    subDesc: json['sub_description'] ?? "--",
    subReason: json['sub_reason'] ?? "--",
    extend: json['extend'] is int
        ? json['extend']
        : int.tryParse(json['extend'].toString()),
    extendStatus: json['extend_status'] ?? "pending",
    extendReason: json['extend_reason'] ?? "--",
    extendDays: json['extend_days'] ?? 0,
    img: json['img'],
  );
}
