import 'package:astrowaypartner/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String? message, {bool isError = true}) {
  Fluttertoast.showToast(
    msg: message ?? "",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: isError ? Colors.white : Colors.white,
    // backgroundColor: isError ? Colors.red : Colors.green,
    textColor: Colors.black,
    fontSize: 16.0,
    timeInSecForIosWeb: 3,
  );
}

customGetSnackbar(
  String? message1,
  String? message2, {
  bool isError = true,
}) {
  return Get.snackbar(
    message1!,
    message2!,
    backgroundColor: Colors.white,
    colorText: primaryColor,
  );
}
