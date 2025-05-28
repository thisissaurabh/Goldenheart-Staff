// ignore_for_file: must_be_immutable, prefer_const_constructors, avoid_print

import 'dart:developer';
import 'dart:io';
import 'package:astrowaypartner/constants/colorConst.dart';
import 'package:astrowaypartner/controllers/Authentication/login_controller.dart';
import 'package:astrowaypartner/controllers/Authentication/login_otp_controller.dart';
import 'package:astrowaypartner/controllers/Authentication/signup_controller.dart';

import 'package:astrowaypartner/views/HomeScreen/Drawer/Setting/privacy_policy_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Setting/term_and_condition_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sizer/sizer.dart';

import '../../utils/dimensions.dart';
import '../../utils/images.dart';
import '../../utils/textstyles.dart';
import '../../widgets/custom_button_widget.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/sizedboxes.dart';
import 'OtpScreens/login_otp_screen.dart';

final initialPhone = PhoneNumber(isoCode: "IN");

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final signupController = Get.put(SignupController());
  final loginController = Get.put(LoginController());
  final loginOtpController = Get.put(LoginOtpController());
  final _globalKey = GlobalKey<FormState>(); // Declare Global Form Key

  final _mobileNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        print('call on will pop');
        SystemNavigator.pop();
        return true;
      },
      child: SafeArea(
        child: Form(
          key: _globalKey,
          child: Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/ic_login_bg copy.png'),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              sizedBox40(),
                              Center(
                                child: Image.asset(
                                  Images.icLogo,
                                  height: 80,
                                ),
                              ),
                              sizedBox30(),
                              Container(
                                width: 180,
                                height: 0.5,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              sizedBox50(),
                              Center(
                                child: Text(
                                  'STAFF LOGIN',
                                  style: openSansBold.copyWith(
                                    fontSize: 27,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              // sizedBox12(),
                              Text(
                                'Enter your phone number to login',
                                textAlign: TextAlign.center,
                                style: openSansRegular.copyWith(
                                  color: Theme.of(context).dividerColor,
                                  fontSize: 14,
                                ),
                              ),
                              sizedBox20(),
                              GetBuilder<LoginController>(
                                builder: (loginController) {
                                  return Column(
                                    children: [
                                      CustomTextField(
                                        // fontSize: 16,
                                        maxLength: 10,
                                        isNumber: true,
                                        inputType: TextInputType.number,
                                        controller:
                                            loginOtpController.cMobileNumber,
                                        isPhone: true,
                                        hintText: "Mobile Number",
                                        validation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your Phone No';
                                          } else if (!RegExp(r'^\d{10}$')
                                              .hasMatch(value)) {
                                            return 'Please enter a valid 10-digit Phone No';
                                          }
                                          return null;
                                        },
                                      ),
                                      sizedBox10(),
                                      CustomButtonWidget(
                                        buttonText: 'Send OTP ',
                                        onPressed: () {
                                          if (_globalKey.currentState!.validate()) {
                                            loginController.sendAstroOTP(
                                                loginOtpController.cMobileNumber.text);
                                          }
                                        },
                                        suffixIcon: Icons.arrow_forward_outlined,
                                      ),
                                      Platform.isIOS ?
                                      Column(
                                        children: [
                                          const Text(
                                            'By logging in, you agree to our ',
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 13),
                                          ).tr(),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(() =>
                                                      TermAndConditionScreen());
                                                  // Navigate to Terms & Conditions
                                                },
                                                child: Text(
                                                  ' Terms & Conditions',
                                                  style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .dividerColor,
                                                  ),
                                                ).tr(),
                                              ),
                                              const Text(
                                                ' and ',
                                                style: TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                ),
                                              ).tr(),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(() =>
                                                  const PrivacyPolicyScreen());
                                                },
                                                child: Text(
                                                  ' Privacy Policy',
                                                  style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .dividerColor,
                                                  ),
                                                ).tr(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ) : SizedBox(),

                                      sizedBox40(),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  children: [
                    sizedBoxDefault(),
                    Platform.isAndroid ?
                    Column(
                      children: [
                        const Text(
                          'By logging in, you agree to our ',
                          style: TextStyle(
                              color: Colors.black, fontSize: 13),
                        ).tr(),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() =>
                                    TermAndConditionScreen());
                                // Navigate to Terms & Conditions
                              },
                              child: Text(
                                ' Terms & Conditions',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .dividerColor,
                                ),
                              ).tr(),
                            ),
                            const Text(
                              ' and ',
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ).tr(),
                            GestureDetector(
                              onTap: () {
                                Get.to(() =>
                                const PrivacyPolicyScreen());
                              },
                              child: Text(
                                ' Privacy Policy',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .dividerColor,
                                ),
                              ).tr(),
                            ),
                          ],
                        ),
                      ],
                    ) : SizedBox()

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
