import 'package:astrowaypartner/controllers/HomeController/chat_controller.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:astrowaypartner/widgets/appbar_back_component.dart';
import 'package:astrowaypartner/widgets/custom_decorated_controller.dart';
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;

class VIdeoScreenHistory extends StatelessWidget {
  const VIdeoScreenHistory({super.key});

  @override
  Widget build(BuildContext context) {
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
                  itemCount: list!.length,
                  itemBuilder: (_, i) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name : ${list[i].username}'.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: openSansRegular.copyWith(fontSize: 14),
                        ),
                        sizedBox4(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Received Amount: ${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${list[i].deduction ?? '0'}",
                              style: openSansRegular.copyWith(
                                fontSize: 14,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: getStatusColor(list[i].chatStatus),
                                    ),
                                    child: Text(
                                      list[i].chatStatus,
                                      style: openSansRegular.copyWith(
                                        fontSize: 14,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                    ),
                                  ),
                                  sizedBox4(),
                                  Text(
                                    'Duration: ${((int.tryParse(list[i].chatDuration ?? '0') ?? 0) ~/ 60)} min',
                                    style: openSansRegular.copyWith(
                                      fontSize: 14,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                        )
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      sizedBox10(),
                );
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
