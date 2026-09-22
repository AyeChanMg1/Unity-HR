import 'package:unity_hr/models/overtime_history.dart';

class OverTimeResponse {
  String totalOverTime;
  String totalWorkingDayOT;
  String totalOffDayOT;
  List<OverTimeHistory> overtimeRequests;

  OverTimeResponse({
    required this.totalOverTime,
    required this.totalWorkingDayOT,
    required this.totalOffDayOT,
    required this.overtimeRequests,
  });

  factory OverTimeResponse.fromJson(Map<String, dynamic> json) {
    return OverTimeResponse(
      totalOverTime: json['total_overtime'].toString(),
      totalWorkingDayOT: json['total_working_day_ot'].toString(),
      totalOffDayOT: json['total_off_day_ot'].toString(),
      overtimeRequests: List.from(
        json['overtime_requests'],
      ).map((e) => OverTimeHistory.fromJson(e)).toList(),
    );
  }
}
