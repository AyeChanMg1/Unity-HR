import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/meeting.dart';

class MeetingController extends GetxController {
  List<Meeting> meetingList = [];
  Meeting? meeting;
  bool isMeeting = false;
  bool isLoading = false;
  int page = 1;

  //fetch all meeting
  Future<void> fetchAllMeeting() async {
    isMeeting = true;
    meetingList.clear();
    update();
    http.Response? response = await Network().getAllMeeting();
    superPrint("Home ${response?.statusCode}");
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var i in iterable) {
        var data = Meeting.fromJson(i);
        meetingList.add(data);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      // showAlert(response.body);
    }
    isMeeting = false;
    update();
  }

  //getMeetingsByID
  Future<void> fetchMeetingsByID(String id) async {
    isLoading = true;
    update();
    http.Response? response = await Network().getMeetingsByID(id);
    superPrint(response?.body);
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = Meeting.fromJson(result['data']);
      meeting = Meeting(
        id: data.id,
        title: data.title,
        date: data.date,
        description: data.description,
        timeFrom: data.timeFrom,
        timeTo: data.timeTo,
        place: data.place,
      );
    } else if (response.statusCode == 401) {
      validateLogout();
      superPrint("Here");
    } else if (response.statusCode != 429) {
      showAlert(response.body);
    }
    isLoading = false;
    update();
  }
}
