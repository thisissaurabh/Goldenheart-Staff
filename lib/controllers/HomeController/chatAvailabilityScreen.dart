// ignore_for_file: file_names

import 'package:astrowaypartner/constants/colorConst.dart';
import 'package:astrowaypartner/controllers/chatAvailability_controller.dart';
import 'package:astrowaypartner/theme/nativeTheme.dart';
import 'package:astrowaypartner/utils/images.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:astrowaypartner/widgets/appbar_back_component.dart';
import 'package:astrowaypartner/widgets/common_textfield_widget.dart';
import 'package:astrowaypartner/widgets/custom_button_widget.dart';
import 'package:astrowaypartner/widgets/custom_decorated_controller.dart';
import 'package:astrowaypartner/widgets/primary_text_widget.dart';
import 'package:astrowaypartner/utils/global.dart' as global;
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatAvailabilityScreen extends StatelessWidget {
  ChatAvailabilityScreen({super.key});

  ChatAvailabilityController chatAvailabilityController =
      Get.find<ChatAvailabilityController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: CustomApp(
            title: 'Chat Availability',
            isBackButtonExist: true,
            isHideWallet: true,
          ),
          body:
              GetBuilder<ChatAvailabilityController>(builder: (chatAvaialble) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(children: [
                    CustomDecoratedContainer(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: chatAvailabilityController.chatType,
                            activeColor: primaryGreenColor,
                            onChanged: (val) {
                              chatAvailabilityController.setChatAvailability(
                                  val, "Online");
                              chatAvailabilityController.showAvailableTime =
                                  true;
                              chatAvailabilityController.update();
                            },
                          ),
                          Text(
                            'Online',
                            style: openSansRegular,
                          ).tr()
                        ],
                      ),
                    ),
                    sizedBox10(),
                    CustomDecoratedContainer(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Radio(
                            value: 2,
                            groupValue: chatAvailabilityController.chatType,
                            activeColor: primaryRedColor,
                            onChanged: (val) {
                              chatAvailabilityController.setChatAvailability(
                                  val, "Offline");
                              chatAvailabilityController.showAvailableTime =
                                  true;
                              chatAvailabilityController.update();
                            },
                          ),
                          Text(
                            'Offline',
                            style: openSansRegular,
                          ).tr()
                        ],
                      ),
                    ),
                    //            sizedBox10(),
                    //           CustomDecoratedContainer(color: Colors.white,
                    //             child: Row(
                    //               children: [
                    //                 Radio(
                    //                   value: 3,
                    //                   groupValue: chatAvailabilityController.chatType,
                    //                   activeColor: primaryRedColor,
                    //                   onChanged: (val) {
                    //                     chatAvailabilityController.setChatAvailability(
                    // val, "Wait Time");
                    //                     chatAvailabilityController.showAvailableTime = false;
                    //                     chatAvailabilityController.update();
                    //                   },
                    //                 ),
                    //                 Text(
                    //                   'Wait Time',
                    //                style: openSansRegular,
                    //                 ).tr()
                    //               ],
                    //             ),
                    //           ),
                    //       sizedBox10(),
                    //           chatAvailabilityController.showAvailableTime == true
                    //               ? const SizedBox()
                    //               : CustomDecoratedContainer(color: Colors.white,
                    //                 child: Column(
                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //                     children: [
                    //                       const Padding(
                    // padding: EdgeInsets.all(10),
                    // child: PrimaryTextWidget(
                    //     text: "Choose time for available"),
                    //                       ),
                    //                       Padding(
                    // padding: const EdgeInsets.only(top: 0, left: 10),
                    // child: const Text(
                    //   "Once wait time is over status will become Online",
                    //   style: TextStyle(fontSize: 09, color: Colors.grey),
                    // ).tr(),
                    //                       ),
                    //                       Padding(
                    // padding: const EdgeInsets.all(5),
                    // child: CommonTextFieldWidget(
                    //   onTap: () {
                    //     chatAvailabilityController
                    //         .selectWaitTime(context);
                    //   },
                    //   hintText: tr("Choose Time"),
                    //   textEditingController:
                    //       chatAvailabilityController.waitTime,
                    //   readOnly: true,
                    //   keyboardType: TextInputType.none,
                    // ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //               ),
                  ]),
                ),
              ],
            );
          }),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: CustomButtonWidget(
                buttonText: 'Submit',
                onPressed: () async {
                  global.user.chatStatus =
                      chatAvailabilityController.chatStatusName;
                  global.user.dateTime =
                      chatAvailabilityController.waitTime.text;

                  global.showOnlyLoaderDialog();
                  await chatAvailabilityController.statusChatChange(
                      astroId: global.user.id!,
                      chatStatus: chatAvailabilityController.chatStatusName,
                      chatTime: chatAvailabilityController.waitTime.text);
                  global.hideLoader();
                  chatAvailabilityController.showAvailableTime = true;
                  chatAvailabilityController.update();
                  Get.back();
                },
                isBold: false,
              ),
            ),
          )

          //
          // Container(
          //   decoration: BoxDecoration(
          //     color: COLORS().primaryColor,
          //     borderRadius: BorderRadius.circular(5),
          //   ),
          //   height: 45,
          //   margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          //   width: MediaQuery.of(context).size.width,
          //   child: TextButton(
          //     onPressed: () async {
          //       global.user.chatStatus =
          //           chatAvailabilityController.chatStatusName;
          //       global.user.dateTime = chatAvailabilityController.waitTime.text;
          //
          //       global.showOnlyLoaderDialog();
          //       await chatAvailabilityController.statusChatChange(
          //           astroId: global.user.id!,
          //           chatStatus: chatAvailabilityController.chatStatusName,
          //           chatTime: chatAvailabilityController.waitTime.text);
          //       global.hideLoader();
          //       chatAvailabilityController.showAvailableTime = true;
          //       chatAvailabilityController.update();
          //       Get.back();
          //     },
          //     child: const Text(
          //       "Submit",
          //       style: TextStyle(color: Colors.black),
          //     ).tr(),
          //   ),
          // ),
          ),
    );
  }
}
