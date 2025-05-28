// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:astrowaypartner/constants/colorConst.dart';
import 'package:astrowaypartner/constants/messageConst.dart';
import 'package:astrowaypartner/controllers/Authentication/signup_controller.dart';
import 'package:astrowaypartner/theme/nativeTheme.dart';
import 'package:astrowaypartner/views/Authentication/login_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Setting/privacy_policy_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Setting/term_and_condition_screen.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:astrowaypartner/widgets/custom_app_bar.dart';
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;
import 'package:astrowaypartner/widgets/custom_app_bar.dart';
class SettingListScreen extends StatelessWidget {
  SettingListScreen({super.key});
  SignupController signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:  CustomApp(
          title: 'Settings',
          isBackButtonExist: true,
        ),
        // appBar: MyCustomAppBar(
        //   height: 80,
        //   backgroundColor: COLORS().primaryColor,
        //   title: const Text("Settings").tr(),
        // ),
        body: Column(
          children: [
            sizedBox10(),
            // GestureDetector(
            //   onTap: () {
            //     Get.to(() => TermAndConditionScreen());
            //   },
            //   child: SizedBox(
            //     width: MediaQuery.of(context).size.width,
            //     child: Card(
            //       elevation: 2,
            //       child: Padding(
            //         padding: const EdgeInsets.all(15.0),
            //         child: const Text(
            //           "Terms and Condition",
            //           style: TextStyle(
            //               color: Colors.black,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 16),
            //         ).tr(),
            //       ),
            //     ),
            //   ),
            // ),
            // GestureDetector(
            //   onTap: () {
            //     Get.to(() => const PrivacyPolicyScreen());
            //   },
            //   child: SizedBox(
            //     width: MediaQuery.of(context).size.width,
            //     child: Card(
            //       elevation: 2,
            //       child: Padding(
            //         padding: const EdgeInsets.all(15.0),
            //         child: const Text(
            //           "Privacy Policy",
            //           style: TextStyle(
            //               color: Colors.black,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 16),
            //         ).tr(),
            //       ),
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text("Are you sure you want to logout?").tr(),
                    content: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: primaryRedColor, // Set your desired background color here
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(MessageConstants.No).tr(),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: primaryGreenColor, // Set your desired background color here
                            ),
                            onPressed: () async {
                              // final loginController =
                              //     Get.put(LoginController());
                              // final LoginOtpController loginOtpController =
                              //     Get.put(LoginOtpController());
                              // loginOtpController.cMobileNumber.clear();
                              // await loginController.init();
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                await global.logoutUser(context);
                              });
                            },
                            child: const Text(MessageConstants.YES).tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        // const Icon(
                        //   Icons.logout,
                        //   color: Colors.black,
                        // ),
                        const Text(
                          "Logout my account",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ).tr(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text(
                            "Are you sure you want to delete this Account?")
                        .tr(),
                    content: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: primaryRedColor, // Set your desired background color here
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(MessageConstants.No).tr(),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: primaryGreenColor, // Set your desired background color here
                            ),
                            onPressed: () {
                              int id = global.user.id ?? 0;
                              debugPrint('user dlete id is $id');
                              if (id == 132) {
                                global.showToast(
                                    message:
                                        'Unable to delete testing account');
                                Get.back();
                              } else {
                                signupController.deleteAstrologer(id);

                                Get.offUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                             LoginScreen()),
                                    (route) => false);
                              }
                            },
                            child: const Text(MessageConstants.YES).tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        // Icon(
                        //   Icons.delete,
                        //   color: COLORS().errorColor,
                        // ),
                        Text(
                          "Delete my account",
                          style: TextStyle(
                              color: COLORS().errorColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ).tr(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
