// ignore_for_file: must_be_immutable

import 'package:astrowaypartner/controllers/Authentication/login_controller.dart';
import 'package:astrowaypartner/controllers/Authentication/signup_controller.dart';
import 'package:astrowaypartner/controllers/HomeController/call_controller.dart';
import 'package:astrowaypartner/controllers/HomeController/chatAvailabilityScreen.dart';
import 'package:astrowaypartner/controllers/callAvailability_controller.dart';
import 'package:astrowaypartner/controllers/chatAvailability_controller.dart';
import 'package:astrowaypartner/controllers/goldenheart/profile_controller.dart';
import 'package:astrowaypartner/controllers/splashController.dart';
import 'package:astrowaypartner/theme/nativeTheme.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Setting/privacy_policy_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Setting/term_and_condition_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Wallet/Wallet_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/customer_review_screen.dart';

import 'package:astrowaypartner/views/HomeScreen/call/callAvailabilityScreen.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;

import 'package:url_launcher/url_launcher.dart';

import '../../controllers/HomeController/chatAvailabilityScreen.dart';
import '../../controllers/HomeController/wallet_controller.dart';
import '../HomeScreen/Profile/edit_profile_screen.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({super.key});

  SignupController signupController = Get.find<SignupController>();
  final SplashController splashController = Get.find<SplashController>();
  CallController callController = Get.put(CallController());
  WalletController walletController = Get.find<WalletController>();
  ChatAvailabilityController chatAvailabilityController =
      Get.find<ChatAvailabilityController>();
  CallAvailabilityController callAvailabilityController =
      Get.find<CallAvailabilityController>();
  SignupController profileControl = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileControl.astrologerProfileById(false);
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomApp(title: 'Account'),
        body: SingleChildScrollView(
          child: GetBuilder<GoldenProfileController>(
              builder: (golderProfileControl) {
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () async {
                      Get.to(() => EditProfileScreen());
                      // bool isLogin = await global.isLogin();
                      // if (isLogin) {
                      //   global.showOnlyLoaderDialog(context);
                      //   await splashController.getCurrentUserData();
                      //   global.hideLoader();

                      // }
                    },
                    child: _drawerItem(
                        icon: Icons.chat_outlined,
                        title: 'Profile Setting',
                        tap: () async {
                          Get.to(() => EditProfileScreen());
                          // bool isLogin = await global.isLogin();
                          // if (isLogin) {
                          //   global.showOnlyLoaderDialog(context);
                          //   await splashController.getCurrentUserData();
                          //   global.hideLoader();
                          //   Get.to(() => EditUserProfile());
                          // }
                        })),
                divider(),
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      Get.to(() => CustomeReviewScreen());
                    },
                    child: _drawerItem(
                        icon: Icons.history,
                        title: 'Reviews',
                        tap: () async {
                          Get.to(() => CustomeReviewScreen());
                          // }
                        })),
                divider(),
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      // bool isLogin = await global.isLogin();
                      // if (isLogin) {
                      walletController.getAmountList();
                      Get.to(() => WalletScreen());
                      // }
                    },
                    child: _drawerItem(
                        icon: Icons.history,
                        title: 'Wallet',
                        tap: () async {
                          // bool isLogin = await global.isLogin();
                          // if (isLogin) {
                          walletController.getAmountList();
                          Get.to(() => WalletScreen());
                          // }
                        })),
                divider(),
                UserSession.logintype == 1
                    ? _drawerItem(
                        icon: Icons.history,
                        title: 'Chat Availiblity',
                        tap: () async {
                          chatAvailabilityController.chatStatusName =
                              global.user.chatStatus;
                          global.user;
                          if (global.user.chatWaitTime != null) {
                            String formattedTime = DateFormat('HH:mm')
                                .format(global.user.chatWaitTime!);
                            chatAvailabilityController.waitTime.text =
                                formattedTime;
                            chatAvailabilityController.timeOfDay2 = TimeOfDay(
                                hour: global.user.chatWaitTime!.hour,
                                minute: global.user.chatWaitTime!.minute);
                          }
                          if (global.user.chatStatus == "Online") {
                            chatAvailabilityController.chatType = 1;
                            chatAvailabilityController.showAvailableTime = true;
                          } else if (global.user.chatStatus == "Offline") {
                            chatAvailabilityController.chatType = 2;
                            chatAvailabilityController.showAvailableTime = true;
                          } else {
                            chatAvailabilityController.chatType = 3;
                            chatAvailabilityController.showAvailableTime =
                                false;
                          }
                          chatAvailabilityController.update();
                          Get.to(() => ChatAvailabilityScreen());

                          //  Get.to(() => AvailabiltyScreen());
                          // }
                        })
                    : const SizedBox(),
                UserSession.logintype == 1 ? divider() : const SizedBox(),
                _drawerItem(
                    icon: Icons.history,
                    title: UserSession.logintype == 1
                        ? 'Audio Call Availibility'
                        : 'Video Call Availibility',
                    tap: () async {
                      callAvailabilityController.callStatusName =
                          global.user.callStatus;
                      if (global.user.callWaitTime != null) {
                        String formattedTime = DateFormat('HH:mm')
                            .format(global.user.callWaitTime!);
                        callAvailabilityController.waitTime.text =
                            formattedTime;
                        callAvailabilityController.timeOfDay2 = TimeOfDay(
                            hour: global.user.callWaitTime!.hour,
                            minute: global.user.callWaitTime!.minute);
                      }
                      if (global.user.callStatus == "Online") {
                        callAvailabilityController.callType = 1;
                        callAvailabilityController.showAvailableTime = true;
                      } else if (global.user.callStatus == "Offline") {
                        callAvailabilityController.callType = 2;
                        callAvailabilityController.showAvailableTime = true;
                      } else {
                        callAvailabilityController.callType = 3;
                        callAvailabilityController.showAvailableTime = false;
                      }
                      callAvailabilityController.update();
                      Get.to(() => CallAvailabilityScreen());

                      //  Get.to(() => AvailabiltyScreen());
                      // }
                    }),

                // GestureDetector(
                //     behavior: HitTestBehavior.translucent,
                //     onTap: () async {
                //        await signupController.astrologerProfileById(false);
                //                   signupController.update();
                //                   Get.to(() => AvailabiltyScreen());
                //        Get.to(() => AvailabiltyScreen());
                //       // }
                //     },
                //     child: _drawerItem(
                //         icon: Icons.history,
                //         title: 'Chat Availiblity',
                //         tap: () async {
                //            chatAvailabilityController.chatStatusName =
                //                       global.user.chatStatus;
                //                   global.user;
                //                   if (global.user.chatWaitTime != null) {
                //                     String formattedTime = DateFormat('HH:mm')
                //                         .format(global.user.chatWaitTime!);
                //                     chatAvailabilityController.waitTime.text =
                //                         formattedTime;
                //                     chatAvailabilityController.timeOfDay2 = TimeOfDay(
                //                         hour: global.user.chatWaitTime!.hour,
                //                         minute: global.user.chatWaitTime!.minute);
                //                   }
                //                   if (global.user.chatStatus == "Online") {
                //                     chatAvailabilityController.chatType = 1;
                //                     chatAvailabilityController.showAvailableTime =
                //                         true;
                //                   } else if (global.user.chatStatus == "Offline") {
                //                     chatAvailabilityController.chatType = 2;
                //                     chatAvailabilityController.showAvailableTime =
                //                         true;
                //                   } else {
                //                     chatAvailabilityController.chatType = 3;
                //                     chatAvailabilityController.showAvailableTime =
                //                         false;
                //                   }
                //                   chatAvailabilityController.update();
                //                   Get.to(() => ChatAvailabilityScreen());

                //       //  Get.to(() => AvailabiltyScreen());
                //           // }
                //         })),

                divider(),
                GestureDetector(
                  onTap: () async {
                    Get.to(() => const PrivacyPolicyScreen());

                    //  Get.off(() => LoginScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(children: [
                      Text(
                        "Privacy Policy",
                        style: openSansRegular.copyWith(fontSize: 14),
                      ).tr(),
                    ]),
                  ),
                ),

                divider(),

                GestureDetector(
                  onTap: () async {
                    Get.to(() => TermAndConditionScreen());
                    //  Get.off(() => LoginScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(children: [
                      Text(
                        "Terms & Conditions",
                        style: openSansRegular.copyWith(fontSize: 14),
                      ).tr(),
                    ]),
                  ),
                ),
                //      divider(),
                // GestureDetector(
                //   onTap: () async {
                //     // bool isLogin = await global.isLogin();
                //     // if (isLogin) {
                //     //   CustomerSupportController customerSupportController =
                //     //       Get.find<CustomerSupportController>();
                //     //   AstrologerAssistantController
                //     //       astrologerAssistantController =
                //     //       Get.find<AstrologerAssistantController>();
                //     //   global.showOnlyLoaderDialog(context);
                //     //   await customerSupportController.getCustomerTickets();
                //     //   astrologerAssistantController
                //     //       .getChatWithAstrologerAssisteant();
                //     //   global.hideLoader();
                //     //   Get.to(() => const CustomerSupportChat());
                //     // }
                //     //  Get.off(() => LoginScreen());
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(13.0),
                //     child: Row(children: [

                //       Text(
                //         "Complaint center",
                //         style: openSansRegular.copyWith(fontSize: 14),
                //       ).tr(),
                //     ]),
                //   ),
                // ),
                divider(),
                GestureDetector(
                  onTap: () async {
                    Get.dialog(
                      AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          "Are you sure you want to logout",
                          style: Get.textTheme.titleMedium,
                        ).tr(),
                        content: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('No').tr(),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 4,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      primaryGreenColor, // Change background color
                                  foregroundColor: Colors
                                      .white, // Change text color), // Optional: Customize padding
                                ),
                                onPressed: () {
                                  // HistoryController historyController =
                                  //     Get.find<HistoryController>();
                                  // historyController.chatHistoryList.clear();
                                  // historyController.astroMallHistoryList
                                  //     .clear();
                                  // historyController.reportHistoryList.clear();
                                  // historyController.callHistoryList.clear();
                                  // historyController.paymentLogsList.clear();
                                  // historyController.walletTransactionList
                                  //     .clear();
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) async {
                                    await global.logoutUser(context);
                                  });
                                },
                                child: const Text('YES').tr(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    //  Get.off(() => LoginScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(children: [
                      Text(
                        "Logout",
                        style: openSansRegular.copyWith(fontSize: 14),
                      ).tr(),
                    ]),
                  ),
                ),
                divider(),
                GestureDetector(
                  onTap: () async {
                    Get.dialog(
                      AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          "Are you sure you want to delete your account",
                          style: Get.textTheme.titleMedium,
                        ).tr(),
                        content: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('No').tr(),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 4,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  primaryGreenColor, // Change background color
                                  foregroundColor: Colors
                                      .white, // Change text color), // Optional: Customize padding
                                ),
                                onPressed: () {

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) async {
                                  signupController.deleteStaff(global.user.userId.toString());
                                  });
                                },
                                child: const Text('YES').tr(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    //  Get.off(() => LoginScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(children: [
                      Text(
                        "Delete Account",
                        style: openSansRegular.copyWith(fontSize: 14,color: redColor),
                      ).tr(),
                    ]),
                  ),
                ),
                sizedBox20(),
              ],
            );
          }),
        ),
      ),
    );
  }

  Padding divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        color: Colors.black.withOpacity(0.10),
        thickness: 0.6,
      ),
    );
  }

  Widget _drawerItem(
      {required IconData icon,
      required String title,
      required Function() tap}) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: GestureDetector(
        onTap: tap,
        child: Row(children: [
          // Icon(
          //   icon,
          //   color: primaryBrownColor,
          //   size: 18,
          // ),
          // const SizedBox(
          //   width: 15,
          // ),
          Text(
            title,
            style: openSansRegular.copyWith(fontSize: 14),
          ).tr(),
        ]),
      ),
    );
  }

  Future<void> _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
