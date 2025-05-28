// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:developer';

import 'package:astrowaypartner/controllers/HomeController/call_controller.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
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

class Videotab extends StatelessWidget {
  Videotab({super.key});

  final callController = Get.find<CallController>();

  final networkController = Get.find<NetworkController>();
  final drawerKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallController>(
      builder: (callController) {
        final voiceCallList = callController.callList
            .where((call) => call.callType == 11)
            .toList();
        return voiceCallList.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, bottom: 200),
                    child: ElevatedButton(
                      onPressed: () async {
                        var status = networkController.connectionStatus.value;
                        await callController.getCallList(false);
                        callController.update();
                      },
                      child: Icon(Icons.refresh_outlined,
                          color: Theme.of(context).primaryColor),
                    ),
                    // TextButton(
                    //   onPressed: () async {
                    //     var status = networkController.connectionStatus.value;
                    //     await callController.getCallList(false);
                    //     callController.update();

                    //   },
                    //   child:   Icon(
                    //     Icons.refresh_outlined,
                    //     color: Theme.of(context).primaryColor
                    //   ),
                    // ),
                  ),
                  Center(
                    child:
                        const Text("You don't have any video call requests yet")
                            .tr(),
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
                  itemCount: voiceCallList.length,
                  controller: callController.scrollController,
                  physics: const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemBuilder: (context, index) {
                    final call =
                        voiceCallList[index]; // use filtered call object here

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
                                    image: '$imgBaseurl${call.profile}',
                                  ),
                                  Positioned(
                                    top: 0.2.h,
                                    right: 2.w,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.call,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              call.name == ""
                                                  ? "User"
                                                  : call.name ?? 'User',
                                              style: openSansSemiBold.copyWith(
                                                  fontSize: 16),
                                            ),
                                          ),
                                          CustomDecoratedContainer(
                                            verticalPadding: 6,
                                            horizontalPadding: 14,
                                            color: primaryOrangeColor
                                                .withOpacity(0.30),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.call,
                                                    size: 12,
                                                    color: Colors.black),
                                                const SizedBox(width: 6),
                                                Text(
                                                  "Voice Call",
                                                  style:
                                                      openSansRegular.copyWith(
                                                          color: Colors.black,
                                                          fontSize: 12),
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
                                                print(call.callId);
                                                // FlutterCallkitIncoming
                                                //     .hideCallkitIncoming(
                                                //   CallKitParams(
                                                //       id: call.callId
                                                //           .toString()),
                                                // );
                                                // FlutterCallkitIncoming
                                                //     .setCallConnected(
                                                //   call.callId.toString(),
                                                // );
                                                //
                                                // Future.delayed(const Duration(
                                                //         milliseconds: 500))
                                                //     .then((value) async {
                                                //   await localNotifications
                                                //       .cancelAll();
                                                // });
                                                //
                                                // global.showOnlyLoaderDialog();
                                                // await callController
                                                //     .acceptCallRequest(
                                                //   call.callId,
                                                //   call.profile == ""
                                                //       ? "assets/images/no_customer_image.png"
                                                //       : call.profile,
                                                //   call.name ?? 'User',
                                                //   call.id,
                                                //   call.fcmToken ?? '',
                                                //   call.callDuration.toString(),
                                                // );
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
                                                      "Are you Sure You Want to Reject this Request ?",
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
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                primaryRedColor,
                                                          ),
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            "No",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ).tr(),
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                primaryGreenColor,
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
                                                                    call.callId);
                                                            callController
                                                                .update();
                                                          },
                                                          child: const Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ).tr(),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
