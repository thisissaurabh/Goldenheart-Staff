// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:astrowaypartner/utils/dimensions.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/drawer_screen.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:astrowaypartner/widgets/custom_decorated_controller.dart';
import 'package:astrowaypartner/widgets/custom_network_image.dart';
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/colorConst.dart';
import '../../../constants/messageConst.dart';
import '../../../controllers/HomeController/chat_controller.dart';
import '../../../controllers/networkController.dart';
import 'package:astrowaypartner/utils/global.dart' as global;

import '../../../main.dart';
import '../../../theme/nativeTheme.dart';
import '../../../utils/config.dart';
import '../../../utils/images.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});
  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> with AutomaticKeepAliveClientMixin {
  final chatController = Get.find<ChatController>();
  final networkController = Get.find<NetworkController>();

  @override
  void initState() {
    super.initState();
    if (chatController.chatList.isEmpty) {
      chatController.getChatList(true);
    }
  }

  final drawerKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ChatController>(
      builder: (chatController) {
        return chatController.chatList.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, bottom: 200),
                    child: ElevatedButton(
                      onPressed: () async {
                        var status = networkController.connectionStatus.value;
                        if (status <= 0) {
                          global.showToast(message: 'No internet');
                          return;
                        }
                        await chatController.getChatList(false);
                        chatController.update();
                      },
                      child: Icon(Icons.refresh_outlined,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Center(
                      child: const Text(
                              "You don't have any chat call requests yet")
                          .tr()),
                ],
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await chatController.getChatList(true);
                },
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 100),
                  shrinkWrap: true,
                  itemCount: chatController.chatList.length,
                  physics: const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: chatController.scrollController,
                  itemBuilder: (context, index) {
                    return CustomDecoratedContainer(
                      color: Colors.white,
                      verticalPadding: 20,
                      horizontalPadding: 16,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)),
                            child: CustomNetworkImageWidget(
                                radius: 12,
                                placeholder: Images.icProfilePlaceholder,
                                height: 55,
                                width: 55,
                                image:
                                    '$imgBaseurl${chatController.chatList[index].profile}'),
                          ),

                          //   CachedNetworkImage(
                          //   //   imageUrl:
                          //   //       '$imgBaseurl${chatController.chatList[index].profile}',
                          //   //   imageBuilder: (context, imageProvider) =>
                          //   //       Container(
                          //   //     height: 75,
                          //   //     width: 75,
                          //   //     decoration: BoxDecoration(
                          //   //       borderRadius: BorderRadius.circular(7),
                          //   //       color: Get.theme.primaryColor,
                          //   //       image: DecorationImage(
                          //   //         image: NetworkImage(
                          //   //             "$imgBaseurl${chatController.chatList[index].profile}"),
                          //   //       ),
                          //   //     ),
                          //   //   ),
                          //   //   errorWidget: (context, url, error) => Container(
                          //   //     height: 75,
                          //   //     width: 75,
                          //   //     decoration: BoxDecoration(
                          //   //       borderRadius: BorderRadius.circular(7),
                          //   //       color: Get.theme.primaryColor,
                          //   //       image: const DecorationImage(
                          //   //         image: AssetImage(
                          //   //             "assets/images/no_customer_image.png"),
                          //   //       ),
                          //   //     ),
                          //   //   ),
                          //   // ),
                          // ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      chatController.chatList[index].name ==
                                                  "" ||
                                              chatController
                                                      .chatList[index].name ==
                                                  null
                                          ? "User"
                                          : chatController
                                              .chatList[index].name!,
                                      style: openSansSemiBold.copyWith(
                                          fontSize: 16),
                                    ),
                                  ),

                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 5),
                                  //   child: Row(
                                  //     children: [
                                  //       Padding(
                                  //         padding:
                                  //             const EdgeInsets.only(left: 5),
                                  //         child: Text(
                                  //           DateFormat('dd-MM-yyyy').format(
                                  //               DateTime.parse(chatController
                                  //                   .chatList[index].birthDate
                                  //                   .toString())),
                                  //           style: Get.theme.primaryTextTheme
                                  //               .titleSmall,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  sizedBox10(),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        height: 30,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: primaryGreenColor,
                                            foregroundColor: primaryGreenColor,
                                            side: const BorderSide(
                                                color: primaryGreenColor),
                                          ),
                                          onPressed: () async {
                                            Future.delayed(const Duration(
                                                    milliseconds: 500))
                                                .then((value) async {
                                              await localNotifications
                                                  .cancelAll();
                                            });
                                            global.showOnlyLoaderDialog();
                                            await chatController.storeChatId(
                                              chatController
                                                  .chatList[index].id!,
                                              chatController
                                                  .chatList[index].chatId!,
                                            );
                                            global.hideLoader();
                                            await chatController
                                                .acceptChatRequest(
                                              chatController
                                                  .chatList[index].chatId!,
                                              chatController
                                                      .chatList[index].name ??
                                                  'user',
                                              chatController.chatList[index]
                                                      .profile ??
                                                  "",
                                              chatController
                                                  .chatList[index].id!,
                                              chatController
                                                  .chatList[index].fcmToken!,
                                              chatController.chatList[index]
                                                  .chatduration!,
                                            );
                                          },
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "Accept",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w500),
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
                                            backgroundColor: primaryRedColor,
                                            foregroundColor:
                                                COLORS().errorColor,
                                            side: BorderSide(
                                                color: COLORS().errorColor),
                                          ),
                                          onPressed: () {
                                            Get.dialog(
                                              AlertDialog(
                                                title: const Text(
                                                        "Are you Sure You Want to Reject this Request ?")
                                                    .tr(),
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    primaryRedColor),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: const Text(
                                                        MessageConstants.No,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ).tr(),
                                                    ),
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    primaryGreenColor),
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
                                                        chatController
                                                            .rejectChatRequest(
                                                                chatController
                                                                    .chatList[
                                                                        index]
                                                                    .chatId!);
                                                      },
                                                      child: const Text(
                                                        MessageConstants.YES,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
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
                                                  fontWeight: FontWeight.w400),
                                            ).tr(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // chatController.chatList[index].birthTime!
                                  //         .isNotEmpty
                                  //     ? Padding(
                                  //         padding:
                                  //             const EdgeInsets.only(top: 5),
                                  //         child: Row(
                                  //           children: [
                                  //             Icon(Icons.schedule_outlined,
                                  //                 color:
                                  //                     COLORS().primaryColor,
                                  //                 size: 20),
                                  //             Padding(
                                  //               padding:
                                  //                   const EdgeInsets.only(
                                  //                       left: 5),
                                  //               child: Text(
                                  //                 chatController
                                  //                     .chatList[index]
                                  //                     .birthTime!,
                                  //                 style: Get
                                  //                     .theme
                                  //                     .primaryTextTheme
                                  //                     .titleSmall,
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       )
                                  //     : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      sizedBox10(),
                ),
              );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
