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

class ChatScreenHistory extends StatelessWidget {
  const ChatScreenHistory({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ChatController>().fetchUserChatRequest();
    });

    return Scaffold(
      appBar: CustomApp(
        title: "Chat",
        isHideWallet: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<ChatController>(builder: (controller) {
                final list = controller.chatHistoryList ?? []; // Ensure list is not null
                final isListEmpty = list.isEmpty;

                return isListEmpty
                    ? Center(
                  child: Text(
                    "No Chat History Available",
                    style: openSansMedium.copyWith(color: Colors.black),
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final chat = list[i]; // Assign to a variable for cleaner code

                    return CustomDecoratedContainer(
                      tap: () {
                        print(chat.deduction!.toString() ?? "No Deduction");
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
                                "Chat ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: openSansRegular.copyWith(fontSize: 14),
                              ).tr(),
                              Text(
                                'with ${chat.username ?? "Unknown"} for ${chat.totalMin ?? "0"} Min',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: openSansRegular.copyWith(fontSize: 14),
                              ).tr(),
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
                                  "${global.getSystemFlagValue(global.systemFlagNameList.currency) ?? ""} ${chat.deduction?.toString() ?? "0.0"}",
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
                                  '${chat.minuteDuration?.toString() ?? "0"} Min',
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
                              color: getStatusColor(chat.chatStatus ?? ""),
                            ),
                            child: Center(
                              child: Text(
                                chat.chatStatus ?? "Unknown Status",
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
                  separatorBuilder: (BuildContext context, int index) => sizedBox10(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

  Color getStatusColor(String? status) {
    switch (status) {
      case 'Completed':
        return Colors.green.withOpacity(0.20); // Green for completed
      case 'Confirmed':
        return Colors.blue.withOpacity(0.20);
        ; // Blue for confirmed
      case 'Pending':
        return Colors.purple.withOpacity(0.20);
        ; // Orange for pending (if applicable)
      case 'Cancelled':
        return Colors.red.withOpacity(0.20);
        ; // Red for cancelled (if applicable)
      default:
        return Colors.grey.withOpacity(0.20);

    }
  }

