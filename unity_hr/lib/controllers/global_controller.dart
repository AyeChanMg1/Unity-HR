import 'package:get/get.dart';
import 'package:unity_hr/controllers/check_in_out_controller.dart';
import 'package:unity_hr/controllers/dashboard_controller.dart';
import 'package:unity_hr/controllers/duty_controller.dart';
import 'package:unity_hr/controllers/employee_controller.dart';
import 'package:unity_hr/controllers/forgot_password_controller.dart';
import 'package:unity_hr/controllers/leave_form_controller.dart';
import 'package:unity_hr/controllers/leave_request_history_controller.dart';
import 'package:unity_hr/controllers/login_controller.dart';
import 'package:unity_hr/controllers/meeting_controller.dart';
import 'package:unity_hr/controllers/navbar_controller.dart';
import 'package:unity_hr/controllers/notification_controller.dart';
import 'package:unity_hr/controllers/outpass_controller.dart';
import 'package:unity_hr/controllers/overtime_controller.dart';
import 'package:unity_hr/controllers/policies_check_in_out_controller.dart';
import 'package:unity_hr/controllers/probation_assessment_score_controller.dart';
import 'package:unity_hr/controllers/profile_controller.dart';
import 'package:unity_hr/controllers/remote_check_in_controller.dart';
import 'package:unity_hr/controllers/resign_controller.dart';
import 'package:unity_hr/controllers/setting_controller.dart';
import 'package:unity_hr/controllers/survey_controller.dart';

class GlobalController extends GetxController {
  void initController() {
    Get.put(NavBarController());
    Get.put(DashboardController());
    Get.put(LoginController());
    Get.put(EmployeeController());
    Get.put(LeaveFormController());
    Get.put(OverTimeController());
    Get.put(ResignControler());
    Get.put(ProfileController());
    Get.put(ForgotPasswordController());
    Get.put(MeetingController());
    Get.put(RemoteCheckInController());
    Get.put(NotificationController());
    Get.put(CheckInOutController());
    Get.put(LeaveRequestHistoryController());
    Get.put(SettingController());
    Get.put(PoliciesCheckInOutController());
    Get.put(ProbationAssessmentScoreController());
    Get.put(DutyController());
    Get.put(SurveyController());
    Get.put(OutPassController());
  }
}
