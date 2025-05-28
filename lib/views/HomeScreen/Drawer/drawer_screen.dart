// ignore_for_file: must_be_immutable


import 'package:astrowaypartner/controllers/Authentication/login_controller.dart';
import 'package:astrowaypartner/controllers/Authentication/signup_controller.dart';
import 'package:astrowaypartner/controllers/HomeController/home_controller.dart';
import 'package:astrowaypartner/controllers/HomeController/wallet_controller.dart';
import 'package:astrowaypartner/controllers/app_review_controller.dart';
import 'package:astrowaypartner/controllers/customerReview_controller.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Setting/page.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Setting/privacy_policy_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Setting/term_and_condition_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Setting/setting_list_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Wallet/Wallet_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/customer_review_screen.dart';

import 'package:astrowaypartner/widgets/custom_decorated_controller.dart';
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;
import 'package:sizer/sizer.dart';

import '../../../theme/nativeTheme.dart';
import '../../../utils/config.dart';
import '../../../utils/images.dart';
import '../../../widgets/custom_network_image.dart';

import '../Profile/follower_list_screen.dart';


class DrawerScreen extends StatelessWidget {
  DrawerScreen({super.key});

  CustomerReviewController customerReviewController =
      Get.find<CustomerReviewController>();
  SignupController signupController = Get.find<SignupController>();
  HomeController homeController = Get.find<HomeController>();
  WalletController walletController = Get.find<WalletController>();
  AppReviewController appReviewController = Get.find<AppReviewController>();
  final LoginController loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBox20(),
              // Center(
              //   child: Text(
              //           'MENU',
              //           style: openSansMedium.copyWith(
              //               color: Theme.of(context).dividerColor),
              //         ),
              // ),
              // Row(
              //     children: [
              //       // IconButton(
              //       //     onPressed: () {
              //       //       // Get.back();
              //       //     },
              //       //     icon: Icon(
              //       //       Icons.arrow_back,
              //       //       size: 24,
              //       //       color: Theme.of(context).highlightColor,
              //       //     )),
              //       Text(
              //         'MENU',
              //         style: openSansMedium.copyWith(
              //             color: Theme.of(context).dividerColor),
              //       )
              //     ],
              //   ),
                   Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomDecoratedContainer(
                    verticalPadding: 16,
                    horizontalPadding: 16,
                    color: Theme.of(context).primaryColor.withOpacity(0.10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // 
                          },
                          child: CustomRoundNetworkImage(
                            height: 65,
                            width: 65,
                            placeholder: Images.icProfilePlaceholder,
                            image:
                              "$imgBaseurl${signupController.astrologerList[0]!.imagePath}",
                          ),
                        ),
                        const SizedBox(width: 15),
                        Flexible(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                 global.user.name != null && global.user.name != ''
                                  ? '${global.user.name}'.toUpperCase()
                                  : "Astrologer".toUpperCase(),
                                style:
                                    openSansRegular.copyWith(color: Colors.black),
                              ).tr(),
                              Text(
                                global.user.contactNo != null &&
                                        global.user.contactNo != ''
                                    ? '${global.user.contactNo}'
                                    : "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 9.sp),
                              ),
                            ],
                          ),
                        ),
                        // splashController.currentUser == null || splashController.currentUser!.email==null||splashController.currentUser!.email.toString()=="" ? const SizedBox() :
                        // // Text( '${splashController.currentUser!.email}',style: TextStyle(
                        // // fontWeight: FontWeight.w700,
                        // // color: Colors.black,
                        // // fontSize: 14,
                        // // ),
                        // // ),
                        // splashController.currentUser == null || splashController.currentUser!.contactNo.toString()=="null" ||splashController.currentUser!.contactNo.toString()==""? const SizedBox() :
                        // Text( '${splashController.currentUser!.countryCode}-${splashController.currentUser!.contactNo}',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w700,
                        //     color: Colors.black,
                        //     fontSize: 14,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 16),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       GestureDetector(
            //         onTap: () async {
            //           // homeController.isSelectedBottomIcon = 4;
            //           // homeController.update();
            //           // Navigator.pop(context);
            //         },
            //         child: CustomRoundNetworkImage(
            //           height: 70,
            //           width: 70,
            //           placeholder: Images.icProfilePlaceholder,
            //           image:
            //               "$imgBaseurl${signupController.astrologerList[0]!.imagePath}",
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 8,
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(top: 8, left: 5),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               global.user.name != null && global.user.name != ''
            //                   ? '${global.user.name}'.toUpperCase()
            //                   : "Astrologer".toUpperCase(),
            //               style: Get.textTheme.bodyLarge!.copyWith(
            //                   fontSize: 18, fontWeight: FontWeight.w500),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.all(1),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.only(left: 1),
            //                     child: Text(
            //                       '+91-',
            //                       style: Theme.of(context).textTheme.bodySmall,
            //                     ),
            //                   ),
            //                   Text(
            //                     global.user.contactNo != null &&
            //                             global.user.contactNo != ''
            //                         ? '${global.user.contactNo}'
            //                         : "",
            //                     style: Theme.of(context)
            //                         .textTheme
            //                         .bodySmall!
            //                         .copyWith(fontSize: 9.sp),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             sizedBox5(),
            //             Row(
            //               children: [
            //                 Text(
            //                   'Experience',
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .bodySmall!
            //                       .copyWith(fontSize: 9.sp),
            //                 ).tr(),
            //                 sizedBoxW5(),
            //                 Text(
            //                   '${global.user.expirenceInYear}',
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .bodySmall!
            //                       .copyWith(fontSize: 9.sp),
            //                 ).tr(),
            //                 sizedBoxW5(),
            //                 Text(
            //                   'years',
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .bodySmall!
            //                       .copyWith(fontSize: 9.sp),
            //                 ).tr(),
            //               ],
            //             )
            //             // Text(
            //             //   'Experience ${global.user.expirenceInYear} years',
            //             //   style: Theme.of(context)
            //             //       .textTheme
            //             //       .bodySmall!
            //             //       .copyWith(fontSize: 9.sp),
            //             // ).tr(),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Divider(
            //   height: 3.w,
            //   color: Colors.grey.shade400,
            // ),
            _drawerItem(
                icon: Icons.wallet,
                title: 'Wallet Transactions',
                tap: () {
                  walletController.getAmountList();
                  Get.to(() => WalletScreen());
                }),
            Divider(
              color: Theme.of(context).hintColor,
            ),
            _drawerItem(
                icon: Icons.rate_review_outlined,
                title: 'Customer Reviews',
                tap: () async {
                  signupController.astrologerList.clear();
                  signupController.clearReply();
                  await signupController.astrologerProfileById(false);
                  signupController.update();
                  Get.to(() => CustomeReviewScreen());
                }),
            Divider(
              color: Theme.of(context).hintColor,
            ),
            _drawerItem(
                icon: Icons.support_agent_outlined,
                title: 'Contact Support',
                tap: () async {
                  // signupController.astrologerList.clear();
                  // signupController.clearReply();
                  // await signupController.astrologerProfileById(false);
                  // signupController.update();
                  // Get.to(() => HelpScreen());
                }),
            Divider(
              color: Theme.of(context).hintColor,
            ),
            _drawerItem(
                icon: Icons.portrait_rounded,
                title: 'Privacy Policy',
                tap: () async {
                  //  loginController.launchURL(context,'https://lab7.invoidea.in/sagetalkz/privacy-policy');
              
                  Get.to(() => const PrivacyPolicyScreen());
                }),
            Divider(
              color: Theme.of(context).hintColor,
            ),
            _drawerItem(
                icon: Icons.portrait_rounded,
                title: 'Terms and Conditions',
                tap: () async {
                       Get.to(() => TermAndConditionScreen());
                                    //  loginController.launchURL(context,'https://lab7.invoidea.in/sagetalkz/terms-condition');

                  // Get.to(() => AstromallScreen());
                }),
            // Divider(color: Theme.of(context).hintColor,),
            // ListTile(
            //   contentPadding: EdgeInsets.zero,
            //   title: Row(
            //     children: [
            //       SizedBox(
            //         width: 3.h,
            //         height: 3.h,
            //         child: Image.asset(
            //           'assets/images/drawericons/assistant.png',
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(left: 10),
            //         child: Text(
            //           "My Assistant",
            //           style: Theme.of(context)
            //               .textTheme
            //               .titleMedium!
            //               .copyWith(fontSize: 12.sp),
            //         ).tr(),
            //       ),
            //     ],
            //   ),
            //   onTap: () async {
            //     await assistantController.getAstrologerAssistantList();
            //     Get.to(() => AssistantScreen());
            //   },
            // ),
            // ListTile(
            //   contentPadding: EdgeInsets.zero,
            //   title: Row(
            //     children: [
            //       SizedBox(
            //         width: 3.h,
            //         height: 3.h,
            //         child: Image.asset(
            //           'assets/images/drawericons/assistantrequest.png',
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(left: 10),
            //         child: Text(
            //           "Assistant Chat Request",
            //           style: Theme.of(context)
            //               .textTheme
            //               .titleMedium!
            //               .copyWith(fontSize: 12.sp),
            //         ).tr(),
            //       ),
            //     ],
            //   ),
            //   onTap: () async {
            //     final AstrologerAssistantChatController
            //         astrologerAssistantChatController =
            //         Get.find<AstrologerAssistantChatController>();
            //     global.showOnlyLoaderDialog();
            //     await astrologerAssistantChatController
            //         .getAstrologerAssistantChatRequest();
            //     global.hideLoader();
            //     Get.to(() => AssistantChatRequestScreen());
            //   },
            // ),
            // ListTile(
            //   contentPadding: EdgeInsets.zero,
            //   title: Row(
            //     children: [
            //       SizedBox(
            //         width: 3.h,
            //         height: 3.h,
            //         child: Image.asset(
            //           'assets/images/drawericons/wallet.png',
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(left: 10),
            //         child: Text(
            //           "Wallet Transactions",
            //           style: Theme.of(context)
            //               .textTheme
            //               .titleMedium!
            //               .copyWith(fontSize: 12.sp),
            //         ).tr(),
            //       ),
            //     ],
            //   ),
            //   onTap: () {
            //     walletController.getAmountList();
            //     Get.to(() => WalletScreen());
            //   },
            // ),
            // ListTile(
            //   contentPadding: EdgeInsets.zero,
            //   title: Row(
            //     children: [
            //       SizedBox(
            //         width: 3.h,
            //         height: 3.h,
            //         child: Image.asset(
            //           'assets/images/drawericons/feedback.png',
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(left: 10),
            //         child: Text(
            //           "Customer Review",
            //           style: Theme.of(context)
            //               .textTheme
            //               .titleMedium!
            //               .copyWith(fontSize: 12.sp),
            //         ).tr(),
            //       ),
            //     ],
            //   ),
            //   onTap: () async {
            //     signupController.astrologerList.clear();
            //     signupController.clearReply();
            //     await signupController.astrologerProfileById(false);
            //     signupController.update();
            //     Get.to(() => CustomeReviewScreen());
            //   },
            // ),
            //   Divider(color: Theme.of(context).hintColor,),
            // Divider(color: Theme.of(context).hintColor,),
            // _drawerItem(icon: Icons.support_agent_outlined, title: 'Contact Support', tap: () async {
            //   await assistantController.getAstrologerAssistantList();
            //   Get.to(() => AssistantScreen());
            // }),
            Divider(
              color: Theme.of(context).hintColor,
            ),
            _drawerItem(
                icon: Icons.settings,
                title: 'Settings',
                tap: () async {
                  Get.to(() => SettingListScreen());
                }),
                sizedBox20(),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.facebook.com/@SageTalkz/');
                      },
                      child: Image.asset(
                        "assets/images/facebook-color-svgrepo-com.png",
                        fit: BoxFit.cover,
                        height: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchURL('https://www.instagram.com/sagetalkz?igsh=MXdiY3BjNnNtcWowcQ==');
                      },
                      child: Image.asset(
                          "assets/images/instagram-1-svgrepo-com.png",
                          fit: BoxFit.cover,
                          height: 30),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchURL(' https://x.com/SageTalkz');
                      },
                      child: Image.asset(
                          "assets/images/twitter-color-svgrepo-com.png",
                          fit: BoxFit.cover,
                          height: 30),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchURL('https://youtube.com/@sagetalkz?si=lDFWStOzrw3XiVM7');
                      },
                      child: Image.asset(
                          ""
                              "assets/images/youtube-color-svgrepo-com.png",
                          fit: BoxFit.fitHeight,
                          height: 30),
                    ),
                  ],
                ),
            // ListTile(
            //   contentPadding: EdgeInsets.zero,
            //   title: Row(
            //     children: [
            //       SizedBox(
            //         width: 3.h,
            //         height: 3.h,
            //         child: Image.asset(
            //           'assets/images/drawericons/settings.png',
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(left: 10),
            //         child: Text(
            //           "Settings",
            //           style: Theme.of(context)
            //               .textTheme
            //               .titleMedium!
            //               .copyWith(fontSize: 12.sp),
            //         ).tr(),
            //       ),
            //     ],
            //   ),
            //   onTap: () {
            //     Get.to(() => SettingListScreen());
            //   },
            // ),
          ],
        ),
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

  // Widget _drawerItem(
  //     {required IconData icon,
  //     required String title,
  //     required Function() tap}) {
  //   return Padding(
  //     padding: const EdgeInsets.all(13.0),
  //     child: GestureDetector(onTap: tap,
  //       child: Row(children: [
  //         // Icon(
  //         //   icon,
  //         //   color: primaryBrownColor,
  //         //   size: 20,
  //         // ),
  //         // const SizedBox(
  //         //   width: 15,
  //         // ),
  //         Text(
  //           title,
  //              style: openSansRegular.copyWith(fontSize: 16),
  //         ).tr(),
  //       ]),
  //     ),
  //   );
  // }
}
