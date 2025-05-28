// ignore_for_file: must_be_immutable
import 'dart:developer';

import 'package:astrowaypartner/constants/colorConst.dart';
import 'package:astrowaypartner/controllers/Authentication/signup_controller.dart';
import 'package:astrowaypartner/controllers/goldenheart/profile_controller.dart';
import 'package:astrowaypartner/theme/nativeTheme.dart';
import 'package:astrowaypartner/utils/dimensions.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/widgets/common_textfield_widget.dart';
import 'package:astrowaypartner/widgets/custom_app_bar.dart';
import 'package:astrowaypartner/widgets/custom_decorated_controller.dart';
import 'package:astrowaypartner/widgets/custom_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import '../../../utils/config.dart';

class CustomeReviewScreen extends StatelessWidget {
  CustomeReviewScreen({super.key});

  GoldenProfileController profileControl = Get.find<GoldenProfileController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileControl.astrologerProfileById(false);
    });
    return SafeArea(
      child: Scaffold(
        appBar: CustomApp(
          title: 'Customer Review',

          //
          isBackButtonExist: true,
        ),
        body: GetBuilder(
          init: GoldenProfileController(),
          builder: (golderProfileControl) {
            return golderProfileControl.astrologerList.isEmpty
                ? SizedBox(
                    child: Center(
                      child: const Text('Please Wait!!!!').tr(),
                    ),
                  )
                : golderProfileControl.astrologerList[0]!.review!.isEmpty ||
                        golderProfileControl.astrologerList[0]!.review == []
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 10, right: 10, bottom: 200),
                            child: SizedBox(),
                            // child: ElevatedButton(
                            //   onPressed: () async {
                            //     golderProfileControl.astrologerList.clear();
                            //     await golderProfileControl
                            //         .astrologerProfileById(false);
                            //     golderProfileControl.update();
                            //   },
                            //   child: const SizedBox(),
                            //   // child: const Icon(
                            //   //   Icons.refresh_outlined,
                            //   //   color: Colors.black,
                            //   // ),
                            // ),
                          ),
                          Center(
                            child: const Text("You don't have any review yet!")
                                .tr(),
                          ),
                        ],
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          golderProfileControl.astrologerList.clear();
                          await golderProfileControl
                              .astrologerProfileById(false);
                          golderProfileControl.update();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeDefault),
                          itemCount: golderProfileControl
                              .astrologerList[0]!.review!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,vertical: 8),
                                  child: CustomDecoratedContainer(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.10),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 8.0, top: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CustomNetworkImageWidget(
                                                  height: Get.height * 0.08,
                                                  width: Get.width * 0.17,
                                                  placeholder:
                                                      'assets/images/no_customer_image.png',
                                                  image:
                                                      "$imgBaseurl${golderProfileControl.astrologerList[0]!.review![index].profile!}"),
                                              // golderProfileControl
                                              //             .astrologerList[0]!
                                              //             .review![index]
                                              //             .profile !=
                                              //         null
                                              //     ? Container(
                                              //         height: Get.height * 0.08,
                                              //         width: Get.width * 0.17,
                                              //         alignment: Alignment.center,
                                              //         decoration: BoxDecoration(
                                              //           color: Colors.transparent,
                                              //           borderRadius:
                                              //               BorderRadius.circular(
                                              //                   7),
                                              //           image: DecorationImage(
                                              //             image: NetworkImage(
                                              //                 "$imgBaseurl${golderProfileControl.astrologerList[0]!.review![index].profile!}"),
                                              //             fit: BoxFit.cover,
                                              //           ),
                                              //           border: Border.all(
                                              //             color: Colors.black,
                                              //             width: 1.0,
                                              //           ),
                                              //         ),
                                              //       )
                                              //     : CircleAvatar(
                                              //         backgroundColor:
                                              //             COLORS().primaryColor,
                                              //         radius: 30,
                                              //         backgroundImage:
                                              //             const AssetImage(
                                              //           "assets/images/no_customer_image.png",
                                              //         ),
                                              //       ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  golderProfileControl
                                                          .astrologerList[0]!
                                                          .review![index]
                                                          .name!
                                                          .isNotEmpty
                                                      ? golderProfileControl
                                                          .astrologerList[0]!
                                                          .review![index]
                                                          .name!
                                                      : "User ${index + 1}",
                                                  style: openSansRegular,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: RatingBar.builder(
                                              initialRating:
                                                  golderProfileControl
                                                          .astrologerList[0]!
                                                          .review![index]
                                                          .rating ??
                                                      0,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemSize: 20,
                                              itemCount: 5,
                                              ignoreGestures: true,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              // ignore: prefer_const_constructors
                                              itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  color: primaryYellow),
                                              onRatingUpdate: (rating) {},
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 0, bottom: 8),
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              golderProfileControl
                                                              .astrologerList[
                                                                  0]!
                                                              .review![index]
                                                              .review !=
                                                          null ||
                                                      golderProfileControl
                                                          .astrologerList[0]!
                                                          .review![index]
                                                          .review!
                                                          .isNotEmpty
                                                  ? golderProfileControl
                                                      .astrologerList[0]!
                                                      .review![index]
                                                      .review!
                                                  : "",
                                              style: openSansRegular.copyWith(
                                                  fontSize: 14),
                                            ),
                                          ),
                                          // golderProfileControl
                                          //         .astrologerList[0]!
                                          //         .review![index]
                                          //         .reply!
                                          //         .isNotEmpty
                                          //     ? Align(
                                          //         alignment:
                                          //             Alignment.centerRight,
                                          //         child: Container(
                                          //           margin:
                                          //               const EdgeInsets.only(
                                          //                   top: 8, bottom: 8),
                                          //           padding:
                                          //               const EdgeInsets.all(
                                          //                   10),
                                          //           color: COLORS()
                                          //               .greyBackgroundColor,
                                          //           child: Text(
                                          //             golderProfileControl
                                          //                         .astrologerList[
                                          //                             0]!
                                          //                         .review![
                                          //                             index]
                                          //                         .reply!
                                          //                         .isNotEmpty ||
                                          //                     golderProfileControl
                                          //                             .astrologerList[
                                          //                                 0]!
                                          //                             .review![
                                          //                                 index]
                                          //                             .reply !=
                                          //                         null
                                          //                 ? golderProfileControl
                                          //                     .astrologerList[
                                          //                         0]!
                                          //                     .review![index]
                                          //                     .reply!
                                          //                 : "",
                                          //             style: Get
                                          //                 .theme
                                          //                 .primaryTextTheme
                                          //                 .titleMedium,
                                          //           ),
                                          //         ),
                                          //       )
                                          //     : const SizedBox(),
                                          // golderProfileControl
                                          //         .astrologerList[0]!
                                          //         .review![index]
                                          //         .reply!
                                          //         .isNotEmpty
                                          //     ? const SizedBox()
                                          //     : Padding(
                                          //         padding:
                                          //             const EdgeInsets.only(
                                          //                 top: 5, bottom: 5),
                                          //         child: Row(
                                          //           children: [
                                          //             Expanded(
                                          //               flex: 4,
                                          //               child:
                                          //                   CommonTextFieldWidget(
                                          //                 hintText:
                                          //                     "Reply.....",
                                          //                 keyboardType:
                                          //                     TextInputType
                                          //                         .text,
                                          //                 textCapitalization:
                                          //                     TextCapitalization
                                          //                         .words,
                                          //                 formatter: [
                                          //                   FilteringTextInputFormatter
                                          //                       .allow(RegExp(
                                          //                           "[a-zA-Z ]"))
                                          //                 ],
                                          //                 textEditingController:
                                          //                     golderProfileControl
                                          //                         .astrologerList[
                                          //                             0]!
                                          //                         .review![
                                          //                             index]
                                          //                         .reviewReply,
                                          //                 onChanged: (p0) {
                                          //                   log(golderProfileControl
                                          //                       .astrologerList[
                                          //                           0]!
                                          //                       .review![index]
                                          //                       .reviewReply!
                                          //                       .text);
                                          //                 },
                                          //               ),
                                          //             ),
                                          //             Expanded(
                                          //               flex: 1,
                                          //               child: IconButton(
                                          //                 onPressed: () {
                                          //                   if (golderProfileControl
                                          //                           .astrologerList[
                                          //                               0]!
                                          //                           .review![
                                          //                               index]
                                          //                           .reviewReply !=
                                          //                       null) {
                                          //                     golderProfileControl
                                          //                         .sendReply(
                                          //                       golderProfileControl
                                          //                           .astrologerList[
                                          //                               0]!
                                          //                           .review![
                                          //                               index]
                                          //                           .id!,
                                          //                       golderProfileControl
                                          //                           .astrologerList[
                                          //                               0]!
                                          //                           .review![
                                          //                               index]
                                          //                           .reviewReply!
                                          //                           .text,
                                          //                     );
                                          //                     golderProfileControl
                                          //                         .update();
                                          //                   } else {
                                          //                     global.showToast(
                                          //                         message: tr(
                                          //                             'Please enter message'));
                                          //                   }
                                          //                 },
                                          //                 icon: Icon(
                                          //                   Icons.send,
                                          //                   size: 30,
                                          //                   color: Theme.of(context).primaryColor,
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
          },
        ),
      ),
    );
  }
}
