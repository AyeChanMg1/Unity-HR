import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/probation_assessment_score.dart';

class ProbationAssessmentScoreController extends GetxController {
  bool isProbationAssessmentScore = false;
  List<ProbationAssessmentScore> probationList = [];
  List<ScoreValue> scoreValueList = [];
  bool isCalculateResult = false;
  String resultStatus = "";
  double resultPercentage = 0.00;
  int approveId = 0;
  String approveName = "";
  bool sendToEmp = false;

  Future<void> updateSendToEmp() async {
    sendToEmp = !sendToEmp;
    update();
  }

  Future<void> fetchProbationById(String id) async {
    probationList.clear();
    scoreValueList.clear();
    resultStatus = "";
    resultPercentage = 0.00;
    approveId = 0;
    approveName = "";
    sendToEmp = false;
    isProbationAssessmentScore = true;
    update();
    try {
      http.Response? response = await Network().getProbationById(id);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = result['data'];
        probationList.add(ProbationAssessmentScore.fromJson(res));
        for (var e in probationList.first.scoreValue) {
          scoreValueList.add(e);
        }
        approveName = probationList.first.judges!.first.name;
        approveId = probationList.first.judges!.first.id;
        resultPercentage = probationList.first.resultPercentage ?? 0.00;
        resultStatus = probationList.first.resultStatus == "pending"
            ? "fail"
            : probationList.first.resultStatus ?? '';
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isProbationAssessmentScore = false;
    update();
  }

  Future<void> calculateResult(String id) async {
    isCalculateResult = true;
    update();
    try {
      Map<String, dynamic> scores = {};
      for (var e in scoreValueList) {
        scores[e.inputId.toString()] = int.parse(e.value.toString());
      }
      http.Response? response = await Network().calculateResult(scores, id);
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = result['data'];
        resultPercentage = double.parse(
          res['result_percentage'].toStringAsFixed(2).toString(),
        );
        resultStatus = res['result_status'].toString();
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isCalculateResult = false;
    update();
  }

  Future<void> updateAssessmentScore(String id) async {
    isProbationAssessmentScore = true;
    update();
    try {
      Map<String, dynamic> scores = {};
      for (var e in scoreValueList) {
        scores[e.inputId.toString()] = int.parse(e.value.toString());
      }
      http.Response? response = await Network().updateAssessmentScore(
        scores,
        id,
        resultPercentage,
        [approveId],
      );
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchProbationById(id);
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isProbationAssessmentScore = false;
    update();
  }

  Future<void> approveRejectProbation(String id, String status) async {
    isProbationAssessmentScore = true;
    update();
    try {
      http.Response? response = await Network().approveRejectProbation(
        id,
        status,
        sendToEmp,
      );
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchProbationById(id);
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isProbationAssessmentScore = false;
    update();
  }

  Future<dynamic> showApprovePeopleDialog(BuildContext context) {
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
              children: probationList.first.judges!.map((approve) {
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
                          approveId = approve.id;
                          approveName = approve.name;
                          update();
                          Get.back();
                        },
                        child: Container(
                          width: screenWidth * 0.7,
                          height: 30,
                          alignment: Alignment.centerLeft,
                          color: Colors.transparent,
                          child: Text(approve.name),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void changeScore(ScoreValue sv, int index) {
    if (index >= 0 && index < scoreValueList.length) {
      scoreValueList[index] = sv;
      update();
    } else {
      debugPrint('Index out of range');
    }
  }
}
