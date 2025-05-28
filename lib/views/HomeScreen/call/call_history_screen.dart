import 'package:astrowaypartner/controllers/HomeController/chat_controller.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:astrowaypartner/widgets/appbar_back_component.dart';
import 'package:astrowaypartner/widgets/custom_decorated_controller.dart';
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;

class CallScreenHistory extends StatelessWidget {
  const CallScreenHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController walletController = Get.put(ChatController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ChatController>().fetchUserCallRequest();
    });
    return Scaffold(
      appBar: CustomApp(
        title: "Voice Calls",
        isHideWallet: true,
      ),
      body: SafeArea(
        child: GetBuilder<ChatController>(builder: (controller) {
          final list = controller.callHistoryList;
          final isListEmpty = list == null || list.isEmpty;

          return isListEmpty
              ? Center(
                  child: Text(
                    "No Call History Available",
                    style: openSansMedium.copyWith(color: Colors.black),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final item = list[i];

                    return CustomDecoratedContainer(
                      tap: () {
                        print(item.deduction?.toString() ?? '0.0');
                      },
                      color: Theme.of(context).primaryColor.withOpacity(0.10),
                      radius: 8,
                      verticalPadding: 12,
                      horizontalPadding: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                (item.callType ?? 0) == 10
                                    ? "Audio Call "
                                    : "Video Call ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: openSansRegular.copyWith(fontSize: 14),
                              ).tr(),
                              Flexible(
                                child: Text(
                                  'with ${item.username ?? "User"} for ${item.totalMin ?? "0"} Min',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: openSansRegular.copyWith(fontSize: 14),
                                ).tr(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Received Amount :",
                                style: openSansRegular.copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ).tr(),
                              Flexible(
                                child: Text(
                                  "${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${item.deduction?.toString() ?? '0.0'}",
                                  style: openSansRegular.copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Package Duration :',
                                style: openSansRegular.copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ).tr(),
                              Expanded(
                                child: Text(
                                  '${item.chatDuration ?? "0"} Min',
                                  style: openSansRegular.copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          sizedBox4(),
                          Container(
                            width: Get.size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: getStatusColor(item.chatStatus ?? ""),
                            ),
                            child: Center(
                              child: Text(
                                item.chatStatus ?? "Unknown",
                                style: openSansRegular.copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      sizedBox10(),
                );

          // : ListView.separated(
          //     padding: const EdgeInsets.all(8),
          //     shrinkWrap: true,
          //     itemCount: list.length,
          //     itemBuilder: (_, i) {
          //       return CustomDecoratedContainer(
          //         tap: () {
          //           print(list[i].deduction.toString());
          //         },
          //         color: Theme.of(context).primaryColor.withOpacity(0.10),
          //         radius: 8,
          //         verticalPadding: 12,
          //         horizontalPadding: 12,
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Row(
          //               children: [
          //                 Text(list[i].callType == 10 ?
          //                     "Call " : "Video ",
          //                   maxLines: 1,
          //                   overflow: TextOverflow.ellipsis,
          //                   style: openSansRegular.copyWith(fontSize: 14),
          //                 ).tr(),
          //                 Text(
          //                   'with ${list[i].username} for ${list[i].totalMin} Min',
          //                   maxLines: 1,
          //                   overflow: TextOverflow.ellipsis,
          //                   style: openSansRegular.copyWith(fontSize: 14),
          //                 ).tr(),
          //                 // Flexible(
          //                 //   child: Text(
          //                 //     list[i].username,
          //                 //     maxLines: 1,
          //                 //     overflow: TextOverflow.ellipsis,
          //                 //     style: openSansRegular.copyWith(fontSize: 14),
          //                 //   ),
          //                 // ),
          //               ],
          //             ),
          //             Row(
          //               children: [
          //                 Text(
          //                   "Received Amount :",
          //                   style: openSansRegular.copyWith(
          //                     fontSize: 14,
          //                     color: Theme.of(context).disabledColor,
          //                   ),
          //                 ).tr(),
          //                 Flexible(
          //                   child: Text(
          //                     "${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${list[i].deduction?.toString() ?? '0.0'}",
          //                     style: openSansRegular.copyWith(
          //                       fontSize: 14,
          //                       color: Theme.of(context).disabledColor,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             Row(
          //               children: [
          //                 Text(
          //                   'Package Duration :',
          //                   style: openSansRegular.copyWith(
          //                     fontSize: 14,
          //                     color: Theme.of(context).disabledColor,
          //                   ),
          //                 ).tr(),
          //                 Expanded(
          //                   child: Text(
          //                     '${list[i].minuteDuration ?? "0"} Min',
          //                     style: openSansRegular.copyWith(
          //                       fontSize: 14,
          //                       color: Theme.of(context).disabledColor,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             sizedBox4(),
          //             Container(
          //               width: Get.size.width,
          //               padding: const EdgeInsets.symmetric(
          //                   vertical: 6, horizontal: 10),
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(12),
          //                 color: getStatusColor(list[i].chatStatus),
          //               ),
          //               child: Center(
          //                 child: Text(
          //                   list[i].chatStatus,
          //                   style: openSansRegular.copyWith(
          //                     fontSize: 14,
          //                     color: Theme.of(context).disabledColor,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       );
          //
          //     },
          //     separatorBuilder: (BuildContext context, int index) =>
          //         sizedBox10(),
          //   );
        }),
      ),
    );
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case 'Completed':
        return Colors.green.withOpacity(0.20); // Green for completed
      case 'Confirmed':
        return Colors.blue.withOpacity(0.20);
        ; // Blue for confirmed
      case 'Pending':
        return Colors.orange.withOpacity(0.20);
        ; // Orange for pending (if applicable)
      case 'Cancelled':
        return Colors.red.withOpacity(0.20);
        ; // Red for cancelled (if applicable)
      default:
        return Colors.grey.withOpacity(0.20);
        ; // Default color
    }
  }
}
