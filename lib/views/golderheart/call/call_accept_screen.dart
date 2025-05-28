import 'package:astrowaypartner/controllers/HomeController/call_controller.dart';
import 'package:astrowaypartner/utils/images.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/drawer_screen.dart';

import 'package:astrowaypartner/views/HomeScreen/tabs/callTab.dart';
import 'package:astrowaypartner/views/HomeScreen/tabs/chatTab.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:astrowaypartner/widgets/appbar_back_component.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

import 'package:astrowaypartner/controllers/HomeController/call_controller.dart';
import 'package:astrowaypartner/widgets/custom_decorated_controller.dart';
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/colorConst.dart';
import '../../../constants/messageConst.dart';
import '../../../controllers/networkController.dart';
import 'package:astrowaypartner/utils/global.dart' as global;

import '../../../main.dart';
import '../../../theme/nativeTheme.dart';
import '../../../utils/config.dart';
import '../../../utils/images.dart';
import '../../../utils/textstyles.dart';
import '../../../widgets/custom_network_image.dart';

class CallAcceptScreen extends StatelessWidget {
   CallAcceptScreen({super.key});


final callController = Get.find<CallController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:  CustomApp(title: "Voice Calls"),
      body:  GetBuilder<CallController>(
      builder: (callController) {
        return callController.callList.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, bottom: 200),
                    child: TextButton(
                      onPressed: () async {

                        await callController.getCallList(false);
                        callController.update();
                       
                      },
                      child:  const Icon(
                        Icons.refresh_outlined,
                        color: yellowColor,
                      ),
                    ),
                  ),
                  Center(
                    child: const Text("You don’t have any call requests yet").tr(),
                  ),
                ],
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await callController.getCallList(true);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 100),
                  itemCount: callController.callList.length,
                  controller: callController.scrollController,
                  physics: const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CustomDecoratedContainer(
                          color: Colors.white,
                          verticalPadding: 20,
                          horizontalPadding: 16,
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  CustomRoundNetworkImage(
                                    placeholder: Images.icProfilePlaceholder,
                                    height: 55,
                                    width: 55,
                                    image:
                                        '$imgBaseurl${callController.callList[index].profile}',
                                  ),
                                  Positioned(
                                    top: 0.2.h,
                                    right: 2.w,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        callController
                                                    .callList[index].callType ==
                                                10
                                            ? Icons.call
                                            : Icons.video_call,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                          
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Icon(Icons.person,
                                          //     color: COLORS().primaryColor,
                                          //     size: 20),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Flexible(
                                              child: Text(
                                                            maxLines: 1,overflow: TextOverflow.ellipsis,
                                                callController.callList[index]
                                                            .name ==
                                                        ""
                                                    ? "User"
                                                    : callController
                                                            .callList[index]
                                                            .name ??
                                                        'User',
                                                style: openSansSemiBold.copyWith(
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                   
                                          CustomDecoratedContainer(verticalPadding: 6,horizontalPadding: 14,
                                            color: callController
                                                        .callList[index]
                                                        .callType ==
                                                    10
                                                ? primaryOrangeColor.withOpacity(0.30)
                                                : primaryOrangeColor.withOpacity(0.30),
                                            child: Row(
                                              children: [
                                                  Icon(callController
                                                            .callList[index]
                                                            .callType ==
                                                        10 ? Icons.call :  Icons.video_call ,size: 12,
                                                        color: callController
                                                        .callList[index]
                                                        .callType ==
                                                    10
                                                ? Colors.black
                                                : Colors.black, ),
                                                const SizedBox(width: 6,),

                                                Text(
                                                  callController.callList[index]
                                                              .callType ==
                                                          10
                                                      ? "Voice Call"
                                                      : "Video Call",
                                                      style: openSansRegular.copyWith(
                                                        color: Colors.black,fontSize: 12
                                                      ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      sizedBox12(),
                                  
                                      sizedBox10(),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 90,
                                            height: 30,
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.green,
                                                side: const BorderSide(
                                                    color: Colors.green),
                                              ),
                                              onPressed: () async {
                                                log('hide call noti');

                                                FlutterCallkitIncoming
                                                    .hideCallkitIncoming(
                                                        CallKitParams(
                                                            id: callController
                                                                .callList[index]
                                                                .callId
                                                                .toString()));
                                                FlutterCallkitIncoming
                                                    .setCallConnected(
                                                        callController
                                                            .callList[index]
                                                            .callId
                                                            .toString());

                                                Future.delayed(const Duration(
                                                        milliseconds: 500))
                                                    .then((value) async {
                                                  await localNotifications
                                                      .cancelAll();
                                                });

                                                log('calltype - ${callController.callList[index].callType}');

                                                if (callController
                                                        .callList[index]
                                                        .callType ==
                                                    10) {
                                                  //! AUDIO UNCOMMENT
                                                  global.showOnlyLoaderDialog();
                                                  await callController
                                                      .acceptCallRequest(
                                                    callController
                                                        .callList[index].callId,
                                                    callController
                                                                .callList[index]
                                                                .profile ==
                                                            ""
                                                        ? "assets/images/no_customer_image.png"
                                                        : callController
                                                            .callList[index]
                                                            .profile,
                                                    callController
                                                            .callList[index]
                                                            .name ??
                                                        'User',
                                                    callController
                                                        .callList[index].id,
                                                    callController
                                                            .callList[index]
                                                            .fcmToken ??
                                                        '',
                                                    callController
                                                        .callList[index]
                                                        .callDuration
                                                        .toString(),
                                                  );
                                                } else if (callController
                                                        .callList[index]
                                                        .callType ==
                                                    11) {
                                                  //!VIDEO WORKING
                                                  log('on homescreen accept video audio ');

                                                  global.showOnlyLoaderDialog();
                                                  await callController
                                                      .acceptVideoCallRequest(
                                                    callController
                                                        .callList[index].callId,
                                                    callController
                                                                .callList[index]
                                                                .profile ==
                                                            ""
                                                        ? "assets/images/no_customer_image.png"
                                                        : callController
                                                            .callList[index]
                                                            .profile,
                                                    callController
                                                            .callList[index]
                                                            .name ??
                                                        'User',
                                                    callController
                                                        .callList[index].id,
                                                    callController
                                                            .callList[index]
                                                            .fcmToken ??
                                                        '',
                                                    callController
                                                        .callList[index]
                                                        .callDuration!
                                                        .toString(),
                                                  );
                                                } else {
                                                  debugPrint(
                                                      'for audio calltype 10 and 11 for video its neither of them');
                                                }
                                              },
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  "Accept",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ).tr(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 90,
                                            height: 30,
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor:
                                                    primaryRedColor,
                                                foregroundColor:
                                                    COLORS().errorColor,
                                                side: BorderSide(
                                                    color: COLORS().errorColor),
                                              ),
                                              onPressed: () {
                                                Get.dialog(
                                                  AlertDialog(
                                                    title: Text(
                                                      "Are you sure?",
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ).tr(),
                                                    content: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton .styleFrom(
                                                            backgroundColor: primaryRedColor, // Set your desired background color
                                                          ),
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child:
                                                              const Text("No")
                                                                  .tr(),
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                primaryGreenColor, // Set your desired background color
                                                          ),
                                                          onPressed: () {
                                                            Future.delayed(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            500))
                                                                .then(
                                                                    (value) async {
                                                              await localNotifications
                                                                  .cancelAll();
                                                            });
                                                            callController
                                                                .rejectCallRequest(
                                                                    callController
                                                                        .callList[
                                                                            index]
                                                                        .callId);
                                                            callController
                                                                .update();
                                                          },
                                                          child:
                                                              const Text("Yes")
                                                                  .tr(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                             
                                              },
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  "Reject",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ).tr(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
      },
    ),
    );
  }
}
