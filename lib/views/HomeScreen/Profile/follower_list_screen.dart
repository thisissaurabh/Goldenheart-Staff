// ignore_for_file: must_be_immutable

import 'package:astrowaypartner/constants/colorConst.dart';
import 'package:astrowaypartner/controllers/following_controller.dart';
import 'package:astrowaypartner/models/following_model.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:astrowaypartner/widgets/custom_app_bar.dart';
import 'package:astrowaypartner/widgets/custom_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/config.dart';

class FollowerListScreen extends StatelessWidget {
  FollowingModel? following;
  FollowerListScreen({super.key, this.following});
  final followingController = Get.find<FollowingController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: const CustomApp(title: 'Followers',isBackButtonExist: true,),
        // appBar: MyCustomAppBar(
        //     height: 80,
        //     backgroundColor: COLORS().primaryColor,
        //     title: const Text("Followers").tr()),
        body: GetBuilder<FollowingController>(
          builder: (followingController) {
            return followingController.followerList.isEmpty
                ? Center(
                    child: const Text("You don't have followers yet!").tr(),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        followingController.followerList.clear();
                        followingController.update();
                        await followingController.followingList(false);
                      },
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 3.w,
                            color: Colors.grey.shade400,
                          );
                        },
                        itemCount: followingController.followerList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                decoration: BoxDecoration(
                                  color: COLORS().greyBackgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading:
                                  CustomNetworkImageWidget( height: 5.h,
                                    width: 5.h,
                                    image: '"$imgBaseurl${followingController.followerList[index].profile}"',
                                   placeholder: 'assets/images/no_customer_image.png',),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        followingController.followerList[index]
                                                .name!.isNotEmpty
                                            ? followingController
                                                .followerList[index].name!
                                            : 'User $index',
                                        style: openSansMedium
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "User ID : ",
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .titleMedium!
                                                .copyWith(fontSize: 10.sp),
                                          ).tr(),
                                          Text(
                                            followingController
                                                        .followerList[index]
                                                        .id !=
                                                    null
                                                ? followingController
                                                    .followerList[index].id
                                                    .toString()
                                                : 'N/A',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .titleMedium!
                                                .copyWith(fontSize: 10.sp),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              followingController.isMoreDataAvailable == true &&
                                      !followingController.isAllDataLoaded &&
                                      followingController.followerList.length -
                                              1 ==
                                          index
                                  ? const CircularProgressIndicator()
                                  : const SizedBox(),
                              index ==
                                      followingController.followerList.length -
                                          1
                                  ? const SizedBox(
                                      height: 50,
                                    )
                                  : const SizedBox()
                            ],
                          );
                        },
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
