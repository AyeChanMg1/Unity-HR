import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/survey_module.dart';

class SurveyController extends GetxController {
  bool xSurvey = false;
  List<SurveyModule> surveyList = [];

  List<SurveyModule> surveyDetailsList = [];
  var remarkController = TextEditingController();

  List answer = [];

  bool xUpdate = false;

  void chooseAnswer(int qid, int aid) {
    // Check if the question already exists in the list
    bool found = false;
    for (var e in answer) {
      if (e['question'] == qid) {
        // Update the answer for the existing question
        e['answer'] = aid;
        found = true;
        break;
      }
    }

    // If the question was not found, add a new entry
    if (!found) {
      answer.add({'question': qid, 'answer': aid});
    }

    update(); // Call update to refresh the UI
  }

  bool checkAnswer(int qid, int aid) {
    // Check if the question exists in the list and the answer matches
    return answer.any((e) => e['question'] == qid && e['answer'] == aid);
  }

  Future<void> surveys() async {
    xSurvey = true;
    surveyList.clear();
    update();
    try {
      http.Response? response = await Network().surveyList();
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = result['data'];
        for (var e in res) {
          SurveyModule surveyModule = SurveyModule.fromJson(e);
          surveyList.add(surveyModule);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xSurvey = false;
    update();
  }

  Future<void> surveyDetails(int id) async {
    xSurvey = true;
    surveyDetailsList.clear();
    update();
    try {
      http.Response? response = await Network().surveyDetails(id);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = result['data'];
        for (var e in res) {
          SurveyModule surveyModule = SurveyModule.fromJson(e);
          surveyDetailsList.add(surveyModule);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xSurvey = false;
    update();
  }

  Future<void> updateAnswer(dynamic data, int id) async {
    xUpdate = true;
    update();
    try {
      var params = {
        'id': id.toString(),
        'remark': remarkController.text.trim(),
        'answer': jsonEncode(data),
      };
      http.Response? response = await Network().updateAnswer(params);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        surveyDetails(id);
        surveys();
        answer.clear();
        Get.back();
        showAlert("Success");
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    xUpdate = false;
    update();
  }
}
