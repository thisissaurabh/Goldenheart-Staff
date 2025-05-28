
import 'package:astrowaypartner/controllers/notification_controller.dart';
import 'package:astrowaypartner/utils/images.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/HomeScreen/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppbarBackComponent extends StatelessWidget {
  final bool? isBackButton;
  final Function() tap;
  final String? title;
  final bool? isNotification;
  final double? padding;
  const AppbarBackComponent({super.key, this.isBackButton = false,
   required this.tap,  this.title ="Sagetalkz", this.isNotification = false,  this.padding});

  @override
  Widget build(BuildContext context) {
    return    Padding(
      padding:  EdgeInsets.only(left: padding ?? 0,right:padding ?? 0,bottom: 16,top: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                                        children: [
                                          isBackButton!
                                              ? IconButton(
                                                  icon: const Icon(Icons.arrow_back),
                                                  color: Theme.of(context).highlightColor,
                                                  onPressed: tap,
                                                )
                                              : InkWell(
                                                  onTap: tap,
                                                  child: Icon(
                                                    Icons.menu,
                                                    color:
                                                        Theme.of(context).highlightColor,
                                                  )),
                                          Image.asset(Images.icLogo,
                                              height: 60, width: 60),
                                        ],
                                      ),
                                      isNotification! ? 
                                        GetBuilder<NotificationController>(
                                      builder: (notificationController) {
                                    return IconButton(
                                      icon: Icon(
                                        Icons.notifications_outlined,
                                        color: Theme.of(context).highlightColor,
                                      ),
                                      onPressed: () async {
                                            notificationController.notificationList
                                      .clear();
                                  notificationController
                                      .getNotificationList(false);
                                  Get.to(() => NotificationScreen());
                                      },
                                    );
                                  }) : const SizedBox()
            ],
          ),
          isBackButton! ? 
          Padding(
            padding: const EdgeInsets.only(left: 20,top: 5),
            child: Text(title!.toUpperCase(),style: openSansMedium.copyWith(color: Colors.white),),
          ) : const SizedBox()
        ],
      ),
    );
  }
}