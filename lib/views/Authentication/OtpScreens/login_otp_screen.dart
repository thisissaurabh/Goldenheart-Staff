// ignore_for_file: must_be_immutable, avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:astrowaypartner/utils/dimensions.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Setting/privacy_policy_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Setting/term_and_condition_screen.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:astrowaypartner/services/apiHelper.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/widgets/custom_button_widget.dart';
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';
import '../../../controllers/Authentication/login_controller.dart';
import '../../../controllers/Authentication/login_otp_controller.dart';
import '../../../controllers/Authentication/signup_controller.dart';
import '../../../theme/nativeTheme.dart';
import '../../../utils/config.dart';
import '../../../utils/images.dart';
import 'package:astrowaypartner/utils/global.dart' as global;

import '../login_screen.dart';

class LoginOtpScreen extends StatefulWidget {
  String? mobileNumber;
  String? verificationId;
  String? countryCode;
  LoginOtpScreen({
    super.key,
    this.mobileNumber,
    this.verificationId,
    this.countryCode,
  });

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final loginOtpController = Get.find<LoginOtpController>();
  final loginController = Get.find<LoginController>();
  final signupController = Get.find<SignupController>();
  String phoneOrEmail = '';
  String otp = '';
  bool isInitIos = false;
  final otplessFlutterPlugin = Otpless();
  APIHelper apihelper = APIHelper();
  bool? solidEnable = false;
  TextEditingController pinEditingController = TextEditingController();
  late final FocusNode focusNode;

  final _globalKey = GlobalKey<FormState>(); // Declare Global Form Key

  @override
  void initState() {
    super.initState();
    startResendTimer(); // Start timer when the screen opens


    focusNode = FocusNode();
  }

  Timer? _resendTimer;
  int _secondsRemaining = 60;
  bool _isResendDisabled = true;

  void startResendTimer() {
    if (_resendTimer != null) {
      _resendTimer!.cancel();
    }

    setState(() {
      _isResendDisabled = true;
      _secondsRemaining = 60;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isResendDisabled = false;
        });
      }
    });
  }

  void resendOtp() {
    loginController.sendAstroOTP(loginOtpController.cMobileNumber.text);
    startResendTimer();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => LoginScreen());
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
                            image: AssetImage('assets/images/ic_login_bg copy.png'),
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
                              //  sizedBox40(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
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
                                  'OTP VERIFICATION',
                                  style: openSansBold.copyWith(
                                    fontSize: 27,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              // sizedBox12(),
                              Text(
                                'Please enter OTP shared on your mobile number',
                                textAlign: TextAlign.center,
                                style: openSansRegular.copyWith(
                                  color: Theme.of(context).dividerColor,
                                  fontSize: 14,
                                ),
                              ),
                              sizedBox30(),
                              GetBuilder<LoginController>(
                                builder: (loginController) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: PinCodeTextField(
                                          length: 6,
                                          appContext: context,
                                          keyboardType: TextInputType.number,
                                          animationType: AnimationType.slide,
                                          controller: pinEditingController,
                                          pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.box,
                                            fieldHeight: 45,
                                            fieldWidth: 45,
                                            borderWidth: 1,
                                            activeBorderWidth: 1,
                                            inactiveBorderWidth: 1,
                                            errorBorderWidth: 1,
                                            selectedBorderWidth: 1,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            selectedColor: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                            selectedFillColor: Colors.white,
                                            inactiveFillColor: Colors.white,
                                            inactiveColor:
                                                Theme.of(context).primaryColor,
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            activeFillColor: Colors.white,
                                          ),
                                          animationDuration:
                                              const Duration(milliseconds: 300),
                                          backgroundColor: Colors.transparent,
                                          enableActiveFill: true,
                                          validator: (value) {
                                            if (pinEditingController.text.length !=
                                                6) {
                                              return 'Please enter a valid 6-digit OTP';
                                            }
                                            return null;
                                          },
                                          beforeTextPaste: (text) => true,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: _isResendDisabled
                                            ? null
                                            : resendOtp,
                                        child: Text(
                                          _isResendDisabled
                                              ? 'Resend OTP in $_secondsRemaining sec'
                                              : 'Resend OTP',
                                          style: TextStyle(
                                            color: _isResendDisabled
                                                ? Colors.black
                                                : Theme.of(context)
                                                    .primaryColor,
                                          ),
                                        ),
                                      ),
                                      // sizedBox20(),
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
                                                                 Get.to(() => TermAndConditionScreen());
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
                                                      Get.to(() => const PrivacyPolicyScreen());
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
                    CustomButtonWidget(
                      buttonText: 'Verify OTP',
                      onPressed: () {
                        if (_globalKey.currentState!.validate()) {
                          loginController.verifyAstroOTP(
                              widget.mobileNumber.toString(),
                              pinEditingController.text);
                        }
                        // loginOtpController.update();
                      },
                    ),
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
