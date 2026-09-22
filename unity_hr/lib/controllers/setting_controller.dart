import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:unity_hr/helpers/constants.dart';
import 'package:unity_hr/helpers/global_functions.dart';
import 'package:unity_hr/helpers/network.dart';
import 'package:unity_hr/helpers/super_print.dart';
import 'package:unity_hr/models/assets.dart';
import 'package:unity_hr/models/increment.dart';
import 'package:unity_hr/models/order.dart';
import 'package:unity_hr/models/promotion.dart';
import 'package:unity_hr/models/resignation.dart';
import 'package:unity_hr/models/survey_module.dart';
import 'package:unity_hr/models/transfer.dart';
import 'package:unity_hr/models/warning.dart';

class SettingController extends GetxController {
  List<Training> trainingList = [];
  List<Warning> warningList = [];
  List<Increment> incrementList = [];
  List<Promotion> promotionList = [];
  List<Transfer> transferList = [];
  List<Resignation> resignationlist = [];
  List<Order> orderlist = [];

  List<Asset> assetList = [];
  bool isWarning = false;
  bool isTraining = false;
  bool isPromotion = false;
  bool isTransfer = false;
  bool isOrder = false;
  bool isResignation = false;
  bool isIncrement = false;
  bool isAsset = false;
  //Training
  Future<void> fetchTraining() async {
    trainingList.clear();
    isTraining = true;
    update();
    try {
      http.Response? response = await Network().getAllTraining();
      var result = jsonDecode(response!.body);
      //superPrint(response.statusCode);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = Training.fromJson(data);
          trainingList.add(list);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isTraining = false;
    update();
  }

  Future<void> fetchPromotions() async {
    promotionList.clear();
    isPromotion = true;
    update();
    try {
      http.Response? response = await Network().getAllPromotions();
      var result = jsonDecode(response!.body);
      //superPrint(response.statusCode);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = Promotion.fromJson(data);
          promotionList.add(list);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isPromotion = false;
    update();
  }

  Future<void> fetchTransfers() async {
    transferList.clear();
    isTransfer = true;
    update();
    try {
      http.Response? response = await Network().getAllTransfers();
      var result = jsonDecode(response!.body);
      //superPrint(response.statusCode);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = Transfer.fromJson(data);
          transferList.add(list);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isTransfer = false;
    update();
  }

  Future<void> fetchResignations() async {
    resignationlist.clear();
    isResignation = true;
    update();
    try {
      http.Response? response = await Network().getAllResignations();
      var result = jsonDecode(response!.body);
      //superPrint(response.statusCode);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = Resignation.fromJson(data);
          resignationlist.add(list);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isResignation = false;
    update();
  }

  Future<void> fetchOrders() async {
    orderlist.clear();
    isOrder = true;
    update();
    try {
      http.Response? response = await Network().getAllOrders();
      var result = jsonDecode(response!.body);
      //superPrint(response.statusCode);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = Order.fromJson(data);
          orderlist.add(list);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isOrder = false;
    update();
  }

  Future<void> fetchWarning() async {
    warningList.clear();
    isWarning = true;
    update();
    try {
      http.Response? response = await Network().getAllWarning();
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = Warning.fromJson(data);
          warningList.add(list);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isWarning = false;
    update();
  }

  //
  Future<void> fetchIncrement() async {
    incrementList.clear();
    isIncrement = true;
    update();
    try {
      http.Response? response = await Network().getAllIncrement();
      var result = jsonDecode(response!.body);
      tooManyRequest(response.statusCode);
      superPrint(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable iterable = result['data'];
        for (var data in iterable) {
          var list = Increment.fromJson(data);
          incrementList.add(list);
        }
      } else if (response.statusCode == 401) {
        validateLogout();
      } else if (response.statusCode != 429) {
        showAlert(result['message']);
      }
    } catch (e) {
      superPrint(e);
    }
    isIncrement = false;
    update();
  }

  //welfare
  Future<void> fetchAsset() async {
    assetList.clear();
    isAsset = true;
    update();
    http.Response? response = await Network().getAllAssets();
    var result = jsonDecode(response!.body);
    tooManyRequest(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable iterable = result['data'];
      for (var data in iterable) {
        var list = Asset.fromJson(data);
        assetList.add(list);
      }
    } else if (response.statusCode == 401) {
      validateLogout();
    } else if (response.statusCode != 429) {
      showAlert(result['message']);
    }
    isAsset = false;
    update();
  }
}
