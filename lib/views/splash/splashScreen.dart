// ignore_for_file: file_names

import 'package:astrowaypartner/constants/colorConst.dart';
import 'package:astrowaypartner/controllers/splashController.dart';
import 'package:astrowaypartner/utils/dimensions.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:astrowaypartner'
    '/utils/global.dart' as global;
// import 'package:sizer/sizer.dart';
import '../../utils/images.dart';
import '../BaseRoute/baseRoute.dart';

class SplashScreen extends BaseRoute {
  //a - analytics
  //o - observer
  SplashScreen({super.key, a, o});

  final customerController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          height:240,width: 240,
          Images.icLogo,
        ),
      ),
    );
  }
}
