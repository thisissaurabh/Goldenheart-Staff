import 'dart:convert';
import 'dart:developer';

import 'package:astrowaypartner/models/user_model.dart';
import 'package:astrowaypartner/utils/global.dart' as global;
import 'package:astrowaypartner/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../services/apiHelper.dart';


class GoldenProfileController extends  GetxController implements GetxService {

    int fetchRecord = 10;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;

  List<CurrentUser?> astrologerList = [];
Future astrologerProfileById(bool isLazyLoading) async {
  debugPrint('=== CALLING astrologerProfileById ===');

  try {
    startIndex = astrologerList.isNotEmpty ? astrologerList.length : 0;
    print("Start Index: $startIndex");

    if (!isLazyLoading) {
      isDataLoaded = false;
    }

    // Checking body conditions before making API call
    global.checkBody().then((result) {
      print("checkBody() Result: $result");

      if (result) {
        global.showOnlyLoaderDialog();
        int id = global.user.id ?? 0;
        print("User ID: $id");
        print("Fetching Records: $fetchRecord");

        apiHelper.getAstrologerProfile(id, startIndex, fetchRecord).then((result) {
          global.hideLoader();
          print("=== RESPONSE FROM API ===");
          print("Status: ${result.status}");
          print("Message: ${result.message}");
          print("Record List Length: ${result.recordList.length}");

          if (result.status == "200") {
            astrologerList.addAll(result.recordList);
            update();
            log("astrologerProfileById-> ${result.recordList}");
            print("Updated List Length: ${astrologerList.length}");

            if (result.recordList.isEmpty || result.recordList.length < fetchRecord) {
              isMoreDataAvailable = false;
              isAllDataLoaded = true;
              print("No More Data Available");
            }
          } else {
            global.showToast(message: result.message.toString());
            print("API Error: ${result.message}");
          }
          update();
        }).catchError((error) {
          print("API Call Error: $error");
        });
      }
    }).catchError((error) {
      print("checkBody() Error: $error");
    });
  } catch (e) {
    print('Exception in astrologerProfileById(): $e');
  }
}



}

