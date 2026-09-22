import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/notification.dart';

class NotificationController extends GetxController {
  List<NotificationModel> notiList = [];
  List<NotificationModel> notiNewList = [];
  List<NotificationModel> notiOldList = [];
  List<NotificationModel> unreadNotiListLength = [];
  bool isNewNoti = false;
  bool isOldNoti = false;

  //All Noti
  Future<void> fetchAllNoti() async {
    unreadNotiListLength.clear();
    notiList.clear();
    notiNewList.clear();
    notiOldList.clear();
    update();
    isNewNoti = true;
    isOldNoti = true;
    update();
    try {
      http.Response? response = await Network().getAllNotification();
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = NotificationModel.fromJson(data);
          notiList.add(list);
        }

        for (var noti in notiList) {
          if (DateFormat('yyyy-MM-dd').format(DateTime.parse(noti.date)) ==
              DateFormat('yyyy-MM-dd').format(DateTime.now())) {
            notiNewList.add(noti);
          }
          if (DateFormat('yyyy-MM-dd').format(DateTime.parse(noti.date)) !=
              DateFormat('yyyy-MM-dd').format(DateTime.now())) {
            notiOldList.add(noti);
          }
          if (noti.isRead == '0') {
            unreadNotiListLength.add(noti);
          }
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        // showAlert(result['response']['message']);
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isNewNoti = false;
    isOldNoti = false;
    update();
  }

  //Read and unRead noti
  Future<void> fetchNotiRead(String id) async {
    try {
      http.Response? response = await Network().readNoti(id);
      jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchAllNoti();
      } else if (response.statusCode == 401) {
        validateLogout();
        superPrint("Here");
      }
    } catch (e) {
      superPrint(e);
    }
    update();
  }
}
