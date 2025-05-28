// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:astrowaypartner/widgets/custom_snackbar.dart';
import 'package:astrowaypartner/widgets/loading_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/device_detail_model.dart';
import '../../services/apiHelper.dart';
import '../../utils/config.dart';
import '../../views/Authentication/OtpScreens/login_otp_screen.dart';
import '../../views/Authentication/login_screen.dart';

import '../../views/HomeScreen/home_screen.dart';
import '../HomeController/call_controller.dart';
import '../HomeController/chat_controller.dart';
import '../HomeController/live_astrologer_controller.dart';

import '../following_controller.dart';
import 'login_otp_controller.dart';

class LoginController extends GetxController {
  String screen = 'login_controller.dart';
  APIHelper apiHelper = APIHelper();
  String? errorText;
  // //Controller
  // final TextEditingController cMobileNumber = TextEditingController();
  bool validedPhone(TextEditingController phoneController) {
    // String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    String pattern =
        r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$';
    RegExp regExp = new RegExp(pattern);
    if (phoneController.text.length == 0) {
      errorText = 'Please enter mobile number';
      update();
      return false;
    } else if (!regExp.hasMatch(phoneController.text)) {
      errorText = 'Please enter valid mobile number';
      update();
      return false;
    } else {
      return true;
    }
  }

  //Login
  ChatController chatController = Get.find<ChatController>();
  CallController callController = Get.find<CallController>();

  FollowingController followingController = Get.find<FollowingController>();
  final liveAstrologerController = Get.find<LiveAstrologerController>();
  final loginOtpController = Get.put(LoginOtpController());

  String signupText = tr('By signin up you agree to our');
  String termsConditionText = tr('Terms and Conditionss');
  String andText = tr('and');
  String privacyPolicyText = tr('Privacy Policy');
  String notaAccountText = tr("Don't have an account?");
  var loaderVisibility = true;
  final urlTextContoller = TextEditingController();
  Map<String, dynamic>? dataResponse;

  String phoneOrEmail = '';
  String otp = '';
  bool isInitIos = false;
  final otplessFlutterPlugin = Otpless();
  final apihelper = APIHelper();

  String? phonenois;
  String? countrycodeis;
  int loginTypeis = 0;

  @override
  void onInit() async {
    await init();
    super.onInit();
  }

  init() {
    signupText = tr('By signin up you agree to our');
    termsConditionText = tr('Terms and Conditionss');
    andText = tr('and');
    privacyPolicyText = tr('Privacy Policy');
    notaAccountText = tr("Don't have an account?");

    if (Platform.isIOS && !isInitIos) {
      otplessFlutterPlugin.initHeadless(OtplessappId);
      otplessFlutterPlugin.setHeadlessCallback(
        (result) {
          onHeadlessResult(result, true);
        },
      );
    }
    if (Platform.isAndroid) {
      otplessFlutterPlugin.initHeadless(OtplessappId);
      otplessFlutterPlugin.enableOneTap(false);
      otplessFlutterPlugin.setHeadlessCallback(
        (result) {
          onHeadlessResult(result, false);
        },
      );
      debugPrint("init headless sdk is called for android");
    }
    update();
  }

  void onHeadlessResult(dynamic result, bool isphone) async {
    log('onHeadlessResult: $result');
    print('onHeadlessResult: $result');
    if (isphone) {
      dataResponse = result;
      if (result != null) {
        int statuscode = dataResponse!['statusCode'];
        log('loginscreen-onHeadlessResult statuscode: $statuscode');

        if (statuscode == 200) {
          String phoneNumber = loginOtpController.cMobileNumber.text;
          if (phoneNumber.isNotEmpty) {
            log('going to LoginOtpScreen: $statuscode');

            Get.offAll(() => LoginOtpScreen(
                  mobileNumber: phoneNumber,
                  countryCode: loginOtpController.countryCode,
                ));
          } else {
            log('failed to send otp error is $result');
          }
        } else {
          if (statuscode == 400) {
            global.showToast(message: 'Invalid otp ');
          }
          log('failed to send otp');
        }
      } else {
        log('failed to send otp result is null');
      }
    } else {
      if (result != null) {
        dataResponse = result;
        String status = dataResponse!['response']['status'].toString();
        String identity = dataResponse!['response']['identities'][0]
                ['identityType']
            .toString();
        String emailid = dataResponse!['response']['identities'][0]
                ['identityValue']
            .toString();
        log('email identity is $identity');
        log('email status is $status');
        if (status == "SUCCESS") {
          if (identity == "EMAIL") {
            loginAstrologer(email: emailid, phoneNumber: '');
          } else if (identity == "MOBILE") {
            await global.checkBody().then(
              (result) async {
                if (result) {
                  global.showOnlyLoaderDialog();
                  await apiHelper
                      .otpResponseOptless(dataResponse)
                      .then((phoneno) {
                    global.hideLoader();
                    log('phone is $phoneno');
                    if (phoneno != null) {
                      loginAstrologer(phoneNumber: phoneno, email: '');
                    } else {
                      log('onHeadlessResult phone no is null');
                    }
                  });
                }
              },
            );
          }
        } else {
          Get.snackbar("Error", "Please try again later");
        }
      } else {
        log('something went wrong while sending otp using onHeadlessResult');
      }
    }
  }

  //! PHONE OTP
  Future<void> startHeadlesswithOtp(String phoneno, String countrycode) async {
    log('start sending otp $phoneno  and $countrycode');
    global.hideLoader();

    if (Platform.isIOS && !isInitIos) {
      isInitIos = true;
      debugPrint("init headless sdk is called for ios");
      return;
    }
    Map<String, dynamic> arg = {};
    arg["phone"] = phoneno;
    arg["countryCode"] = countrycode;
    log('arg is $arg');
    otplessFlutterPlugin.startHeadless((result) {
      onHeadlessResult(result, true);
    }, arg);
  }

  Future<void> startHeadlessWithSocialMedia(String loginType) async {
    log('channelType is $loginType');
    print('startHeadlessWithSocialMedia');
    otplessFlutterPlugin.setHeadlessCallback(
      (result) {
        onHeadlessResult(result, false);
      },
    );

    if (Platform.isIOS && !isInitIos) {
      log('Initializing headless SDK for iOS');
      otplessFlutterPlugin.initHeadless(OtplessappId);
      isInitIos = true;
      debugPrint("init headless sdk is called for ios");
      return;
    }
    Map<String, dynamic> arg = {'channelType': loginType}; //GMAIL
    log('Starting headless with arguments: $arg');
    otplessFlutterPlugin.startHeadless((result) {
      onHeadlessResult(result, false);
    }, arg);
  }

  Future loginAstrologer({String? phoneNumber, String? email}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog();
          global.getDeviceData();
          DeviceInfoLoginModel deviceInfoLoginModel = DeviceInfoLoginModel(
            appId: "2",
            appVersion: global.appVersion,
            deviceId: global.deviceId,
            deviceManufacturer: global.deviceManufacturer,
            deviceModel: global.deviceModel,
            // fcmToken: global.fcmToken,
            deviceLocation: "",
          );

          await apiHelper
              .login(phoneNumber, email, deviceInfoLoginModel)
              .then((result) async {
            if (result.status == "200") {
              global.user = result.recordList;
              await global.sp!
                  .setString('currentUser', json.encode(global.user.toJson()));
              log('GLOBALLY SET VALUE ${global.user}');
              log('isverified  ${global.user.isVerified}');
              print('success');
              await global.getCurrentUserId();
              await chatController.getChatList(false);
              await callController.getCallList(true);

              await followingController.followingList(false);
              FutureBuilder(
                future: liveAstrologerController.endLiveSession(true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      debugPrint('error ${snapshot.error}');
                    }
                    debugPrint('Live Session Ended Successfully');
                    return const SizedBox();
                  } else {
                    return const SizedBox();
                  }
                },
              );
              global.hideLoader();
              await Get.to(() => const HomeScreen());
            } else if (result.status == "400") {
              global.showToast(message: result.message.toString());
              print('statuscode400 ${result.message.toString()}');
              global.hideLoader();
              Get.offAll(() => LoginScreen());
            } else {
              global.showToast(message: result.message.toString());
              print('statuscode${result.status}');
              global.hideLoader();
              await Get.offAll(() => LoginScreen());
            }
          });
        } else {
          global.showToast(message: 'No network connection!');
        }
      });
      update();
    } catch (e) {
      print('Exception - $screen - loginAstrologer(): ' + e.toString());
    }
  }

  Future<void> sendLoginOTP(String phoneNumber, String countryCode) async {
    log('full phone no is $countryCode $phoneNumber');
    try {
      await global.checkBody().then((result) {
        if (result) {
          global.showOnlyLoaderDialog();
          global.hideLoader();
          Get.to(() => LoginOtpScreen(
                mobileNumber: phoneNumber,
                countryCode: countryCode,
              ));
          log('Login Screen -> code sent');
        }
      });
    } on Exception catch (e) {
      String errorMessage = 'An error occurred, please try again later.';
      if (e is FirebaseAuthException) {
        String errorCode = e.code;
        switch (errorCode) {
          case 'invalid-verification-code':
            errorMessage = 'The verification code entered is incorrect.';
            break;
          case 'invalid-verification-id':
            errorMessage = 'The verification ID is invalid.';
            break;
          case 'invalid-phone-number':
            errorMessage = 'The phone number is invalid.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many requests, please try again later.';
            break;
          default:
            errorMessage =
                'An unexpected error occurred, please try again later.';
        }
        global.showToast(
          message: errorMessage,
        );
        debugPrint("Exception - $screen - sendLoginOTP():" + errorMessage);
      }
    }
    // catch (e) {
    //   print("Exception - $screen - sendLoginOTP():" + e.toString());
    // }
  }

  Future<void> sendAstroOTP(String mobileNo) async {
    LoadingDialog.showLoading();
    update();

    final Uri url = Uri.parse('$baseUrl/send-astro-otp?mobile=$mobileNo');
    print("Request URL: $url");

    // Headers
    var headers = {
      'Cookie':
          'PHPSESSID=6uop0tossjr2kqgpie3fg6l3on; XSRF-TOKEN=eyJpdiI6Ijd6bWJjWUphWHBkUVpFN1VwdFl3QWc9PSIsInZhbHVlIjoiZ1M0eER3bnJpZjc0R3VQbzlKVWNNdWFNci9sY0NMRStpTEVXL3BjRm5VcFQwdFlCWWxOaTAzL3VTcGMxNWNJZzluSHN0RUE3bjVwWXE0eEpvT2Z3WkRVVk44ekhaekQ0TnpvOXE5bmRsOG4xUjJJUlVzZlFpN3llWjBITGo4VzEiLCJtYWMiOiI4OWQ0OWE1MjQ1YTZkYWZjNDY4ZTc3OTA1Mjc5ZjZhODQ2MWZhYTdiOTRjMTE0NWIxNDk5MzIyZDIwMGJkZTE3IiwidGFnIjoiIn0%3D; astrokalp_session=eyJpdiI6IjhjQmVSc2Ewam5CdVhobzhZZnV3Q0E9PSIsInZhbHVlIjoiczIwSjNQcko1RVd0REg5QzlpaTc4SUwzdXh0RDF2YUVxT3FTY2tITXgrY04rVjlvYlFTdnVHb1pVYmFDc05hRXZWYy9NVVBVU01VRTByRXFZY05pd3B2NmpYb081Q3NnQTd1enllZTBOTDA0M1RkNm5hNzJWeGFPUThxOUZCd0EiLCJtYWMiOiIyMGVhODBhOGYzN2JmZDNmZDZjZTkxYTFlNWFiYmExYTEwNjdmOGE5YWNmMmJjZmEwYmM2MjRiNDFkYjY3YWViIiwidGFnIjoiIn0%3D'
    };
    print("Request Headers: $headers");
    try {
      var request = http.Request('POST', url);
      request.headers.addAll(headers);
      print("Sending request...");
      // Send the request
      http.StreamedResponse response = await request.send();

      print("Response Status Code: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      // Convert response to string
      String responseString = await response.stream.bytesToString();
      print("Response Body: $responseString");
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(responseString);

        showCustomSnackBar("OTP: ${decodedResponse['otp']}");
        await Get.to(() => LoginOtpScreen(
            mobileNumber: loginOtpController.cMobileNumber.text));
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }

  Future<void> verifyAstroOTP(String mobileNumber, String otp) async {
    global.showOnlyLoaderDialog();
    update();

    final Uri url = Uri.parse('${baseUrl}/verify-astro-otp');

    var headers = {
      'Cookie':
          'PHPSESSID=6uop0tossjr2kqgpie3fg6l3on; XSRF-TOKEN=eyJpdiI6Ijd6bWJjWUphWHBkUVpFN1VwdFl3QWc9PSIsInZhbHVlIjo...'
    };

    try {
      var request = http.MultipartRequest('POST', url);

      request.fields.addAll({
        'mobile': mobileNumber,
        'otp': otp,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseString);

        if (decodedResponse['success'] != null) {
          var user = decodedResponse['user'];
          int logintype = user['recordList']['logintype'];

          // Save logintype globally
          print('Print Login Type ${logintype}');
          await UserSession.saveLoginType(logintype);

          // Ensure data is loaded after saving
          await UserSession.loadSession();

          await loginAstrologer(phoneNumber: mobileNumber, email: '');
        }
      } else if (response.statusCode == 404) {
        await Get.to(() => LoginScreen());
      } else {
        String errorResponse = await response.stream.bytesToString();
        print("Error response code: ${response.statusCode}");
        print("Raw error response: $errorResponse");

        try {
          final decodedError = json.decode(errorResponse);
          String errorMessage = decodedError['error'] ?? "Something went wrong";
          showCustomSnackBar(errorMessage);
        } catch (e) {
          print("Failed to decode error response: $e");
          showCustomSnackBar("Unexpected error occurred");
        }
        // String errorResponse = await response.stream.bytesToString();
        // final decodedError = json.decode(errorResponse);
        // String errorMessage = decodedError['error'] ?? "Something went wrong";

        // showCustomSnackBar(errorMessage);
      }
    } catch (e) {
      print("Exception occurred: $e");
    } finally {
      global.hideLoader();
      update();
    }
  }

// Future<void> verifyAstroOTP(String mobileNumber, String otp) async {
//   global.showOnlyLoaderDialog();
//   update();
//   print("Loader displayed...");

//   final Uri url = Uri.parse('${baseUrl}/verify-astro-otp');
//   print("API URL: $url");

//   // Headers
//   var headers = {
//     'Cookie':
//     'PHPSESSID=6uop0tossjr2kqgpie3fg6l3on; XSRF-TOKEN=eyJpdiI6Ijd6bWJjWUphWHBkUVpFN1VwdFl3QWc9PSIsInZhbHVlIjoiZ1M0eER3bnJpZjc0R3VQbzlKVWNNdWFNci9sY0NMRStpTEVXL3BjRm5VcFQwdFlCWWxOaTAzL3VTcGMxNWNJZzluSHN0RUE3bjVwWXE0eEpvT2Z3WkRVVk44ekhaekQ0TnpvOXE5bmRsOG4xUjJJUlVzZlFpN3llWjBITGo4VzEiLCJtYWMiOiI4OWQ0OWE1MjQ1YTZkYWZjNDY4ZTc3OTA1Mjc5ZjZhODQ2MWZhYTdiOTRjMTE0NWIxNDk5MzIyZDIwMGJkZTE3IiwidGFnIjoiIn0%3D; astrokalp_session=eyJpdiI6IjhjQmVSc2Ewam5CdVhobzhZZnV3Q0E9PSIsInZhbHVlIjoiczIwSjNQcko1RVd0REg5QzlpaTc4SUwzdXh0RDF2YUVxT3FTY2tITXgrY04rVjlvYlFTdnVHb1pVYmFDc05hRXZWYy9NVVBVU01VRTByRXFZY05pd3B2NmpYb081Q3NnQTd1enllZTBOTDA0M1RkNm5hNzJWeGFPUThxOUZCd0EiLCJtYWMiOiIyMGVhODBhOGYzN2JmZDNmZDZjZTkxYTFlNWFiYmExYTEwNjdmOGE5YWNmMmJjZmEwYmM2MjRiNDFkYjY3YWViIiwidGFnIjoiIn0%3D'
//   };
//   print("Headers: $headers");

//   try {
//     // Create multipart request
//     var request = http.MultipartRequest('POST', url);
//     print("Request created...");

//     // Add fields
//     request.fields.addAll({
//       'mobile': mobileNumber,
//       'otp': otp,
//     });
//     print("Fields added: mobile=$mobileNumber, otp=$otp");

//     // Add headers
//     request.headers.addAll(headers);
//     print("Headers added to request");

//     // Send the request
//     http.StreamedResponse response = await request.send();
//     print("Request sent, awaiting response...");

//     // Handle response
//     if (response.statusCode == 200) {
//       print("Response received: ${response.statusCode}");

//       String responseString = await response.stream.bytesToString();
//       print("Response body: $responseString");

//       final decodedResponse = json.decode(responseString);
//       print("Decoded response: $decodedResponse");

//       if (decodedResponse['success'] != null) {
//         print("Success: ${decodedResponse['success']}");

//         // Extract user details
//         var user = decodedResponse['user'];
//         var astro = decodedResponse['astro'];
//         await    loginAstrologer(phoneNumber: mobileNumber, email: '');

//       } else {
//         print("Response received but 'success' key not found.");
//       }
//     } else if (response.statusCode == 404) {
//       // Handle case when astrologer is not found (status 404)
//       print("Astrologer not found (status 404)");
//     await  Get.to(() => SignupScreen(phoneNo: mobileNumber, userId: ''));
//     } else {
//       print("Error: ${response.reasonPhrase}");
//       showCustomSnackBar('Invalid Otp. Please try again');

//     }
//   } catch (e) {
//     // Handle any exception
//     print("Exception occurred: $e");
//   }  finally {
//           global.hideLoader();
//          update();

//   }
//   // inally {

//   // }
// }

  Future<void> launchURL(BuildContext context, String _url) async {
    final Uri url = Uri.parse(_url);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Show an error message if the URL cannot be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open the Terms and Conditions page.'),
        ),
      );
    }
  }

  // Future<void> verifyAstroOTP(String mobileNumber, String otp) async {
  //   global.showOnlyLoaderDialog();
  //   update();
  //   print("Loader displayed...");

  //   final Uri url = Uri.parse('https://lab6.invoidea.in/astrokalp/api/verify-astro-otp');
  //   print("API URL: $url");

  //   // Headers
  //   var headers = {
  //     'Cookie':
  //     'PHPSESSID=6uop0tossjr2kqgpie3fg6l3on; XSRF-TOKEN=eyJpdiI6Ijd6bWJjWUphWHBkUVpFN1VwdFl3QWc9PSIsInZhbHVlIjoiZ1M0eER3bnJpZjc0R3VQbzlKVWNNdWFNci9sY0NMRStpTEVXL3BjRm5VcFQwdFlCWWxOaTAzL3VTcGMxNWNJZzluSHN0RUE3bjVwWXE0eEpvT2Z3WkRVVk44ekhaekQ0TnpvOXE5bmRsOG4xUjJJUlVzZlFpN3llWjBITGo4VzEiLCJtYWMiOiI4OWQ0OWE1MjQ1YTZkYWZjNDY4ZTc3OTA1Mjc5ZjZhODQ2MWZhYTdiOTRjMTE0NWIxNDk5MzIyZDIwMGJkZTE3IiwidGFnIjoiIn0%3D; astrokalp_session=eyJpdiI6IjhjQmVSc2Ewam5CdVhobzhZZnV3Q0E9PSIsInZhbHVlIjoiczIwSjNQcko1RVd0REg5QzlpaTc4SUwzdXh0RDF2YUVxT3FTY2tITXgrY04rVjlvYlFTdnVHb1pVYmFDc05hRXZWYy9NVVBVU01VRTByRXFZY05pd3B2NmpYb081Q3NnQTd1enllZTBOTDA0M1RkNm5hNzJWeGFPUThxOUZCd0EiLCJtYWMiOiIyMGVhODBhOGYzN2JmZDNmZDZjZTkxYTFlNWFiYmExYTEwNjdmOGE5YWNmMmJjZmEwYmM2MjRiNDFkYjY3YWViIiwidGFnIjoiIn0%3D'
  //   };
  //   print("Headers: $headers");

  //   try {
  //     // Create multipart request
  //     var request = http.MultipartRequest('POST', url);
  //     print("Request created...");

  //     // Add fields
  //     request.fields.addAll({
  //       'mobile': mobileNumber,
  //       'otp': otp,
  //     });
  //     print("Fields added: mobile=$mobileNumber, otp=$otp");

  //     // Add headers
  //     request.headers.addAll(headers);
  //     print("Headers added to request");

  //     // Send the request
  //     http.StreamedResponse response = await request.send();
  //     print("Request sent, awaiting response...");

  //     // Handle response
  //     if (response.statusCode == 200) {
  //       print("Response received: ${response.statusCode}");

  //       String responseString = await response.stream.bytesToString();
  //       print("Response body: $responseString");

  //       final decodedResponse = json.decode(responseString);
  //       print("Decoded response: $decodedResponse");

  //       if (decodedResponse['success'] != null) {
  //         print("Success: ${decodedResponse['success']}");

  //         // Extract user details
  //         var user = decodedResponse['user'];
  //         var astro = decodedResponse['astro'];

  //         // print("User: $user");
  //         // print("Token: ${user['token']}");
  //         // print("Token Type: ${user['token_type']}");
  //         // print("User ID: ${user['recordList']['id']}");
  //         // print("astro status : $astro");

  //         if(astro == 0) {
  //           Get.to(() => SignupScreen(phoneNo: mobileNumber,
  //             userId: "${user['recordList']['id']}",));
  //         } else {
  //           loginAstrologer(phoneNumber: mobileNumber, email: '');
  //         }
  //       } else {
  //         print("Response received but 'success' key not found.");
  //       }
  //     } else {
  //       print("Error: ${response.reasonPhrase}");
  //     }
  //   } catch (e) {
  //     // global.hideLoader();
  //     // update();
  //     print("Exception occurred: $e");
  //   }
  // }

  final String pagesLink = '';

  Future<void> fetchPagesLink(String pagetype) async {
    var headers = {
      'Cookie':
          'PHPSESSID=2a93fjavlc85gg1hnaphi0u8ab; XSRF-TOKEN=eyJpdiI6Inc5ODhDT09DbXU3dEc1Qk5uVkNEamc9PSIsInZhbHVlIjoieHJ1WkJ3NlFTTkRwUEZCTzhuUXhTeERHNDNDWG03VjNHV1lreElYMWcrMmxrSCt1Q3hKb3lpSnhVQjV2RFJ0NDYyRXRKdlJPaDU4a0doY2lTK24vMWVEbDNINFRhVGM3bTFVWU1ObVB1WmV3ekFFNzRHUVNyWHBIay8yMFZBSFMiLCJtYWMiOiJiNjU1NzgyNGZjYzc4OGQ1ODM1ZDYyYThkZDRhNzliNDBkODRkNzQ4NTgxNDI3ZDVhZDNjMDZiN2IzZjUyMTkzIiwidGFnIjoiIn0%3D; sagetalkz_session=eyJpdiI6IlhHeEpudDcyTHZTYXpWMEtZdTVsVWc9PSIsInZhbHVlIjoiNzg1YXN3dC9CaDh1cTN1Sjc1TlRrTWVRRmdCek12MWNOZW9PVzZrVk5ZZXp2dkkydmVVazVrQkhyc2RwL28yOVhMcmZYMHlac0lCdE9YVFg1MzA4OFRZaFkrNzV6cGc4SFRzM1VDc3ZEMUdmbWhGelJsSGVxUkk1YWtIbjBJV0siLCJtYWMiOiIyOTc4NjJmMjEzYzI4N2U0OGJlMzY0ZjIxMWRkZjE2ZTg1YmEzZmUzOWY3MGFlZDVmZGE3MDIyNGY0ZDA1NThmIiwidGFnIjoiIn0%3D'
    };

    var request = http.MultipartRequest('POST',
        Uri.parse('https://lab7.invoidea.in/goldenheart/api/$pagetype'));

    request.headers.addAll(headers);

    try {
      print('Sending request to: ${request.url}');
      print('Headers: ${request.headers}');

      // Send the request and get the response
      http.StreamedResponse response = await request.send();

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');

        // Assuming the response body is in JSON format
        var data = jsonDecode(responseBody);
        print('Decoded response data: $data');

        // Save the URL from the response to pagesLink
        String fetchedLink = data['response'];
        print('Fetched link: $fetchedLink');
      } else {
        // If there's an error, print the reason phrase
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Catch and print any exception
      print('An error occurred: $e');
    }
  }
}

class UserSession {
  static int? logintype;

  // Load logintype from SharedPreferences
  static Future<void> loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logintype = prefs.getInt('logintype');
    print('Loaded Login Type: $logintype');
  }

  // Save logintype to SharedPreferences
  static Future<void> saveLoginType(int type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('logintype', type);
    logintype = type;
    print('Saved Login Type: $logintype');
  }
}
