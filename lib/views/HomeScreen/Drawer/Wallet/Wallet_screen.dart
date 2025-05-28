// ignore_for_file: file_names, must_be_immutable, avoid_print, prefer_interpolation_to_compose_strings, deprecated_member_use

import 'dart:developer';

import 'package:astrowaypartner/constants/colorConst.dart';
import 'package:astrowaypartner/constants/messageConst.dart';
import 'package:astrowaypartner/controllers/Authentication/signup_controller.dart';
import 'package:astrowaypartner/controllers/HomeController/wallet_controller.dart';
import 'package:astrowaypartner/theme/nativeTheme.dart';
import 'package:astrowaypartner/utils/dimensions.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Wallet/add_amount_screen.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:astrowaypartner/widgets/appbar_back_component.dart';
import 'package:astrowaypartner/widgets/common_textfield_widget.dart';
import 'package:astrowaypartner/widgets/custom_app_bar.dart';
import 'package:astrowaypartner/widgets/custom_button_widget.dart';
import 'package:astrowaypartner/widgets/custom_decorated_controller.dart';
import 'package:astrowaypartner/widgets/custom_textfield.dart';
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;
import 'package:sizer/sizer.dart';

import '../../../../utils/images.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});
  final WalletController walletController = Get.put(WalletController());
  @override
  Widget build(BuildContext context) {
    final WalletController walletController = Get.put(WalletController());

    // Ensures the function is called after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      walletController.withdrawWalletAmount();
    });


    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomApp(
            title: "Wallet",
            isBackButtonExist: true,
            isHideWallet: true,
          ),
          bottomNavigationBar: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: CustomButtonWidget(
                buttonText: 'Withdraw Amount',
                onPressed: () {
                  Get.to(() => AddAmountScreen());
                  walletController.update();
                },
                isBold: false,
              ),
            ),
          ),
          body: SafeArea(
            child: GetBuilder<WalletController>(
              builder: (walletController) {

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      child: Column(
                        children: [
                          CustomDecoratedContainer(
                            verticalPadding: 20,
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.10),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(
                                            Images.icWallet,
                                            height: 55,
                                            width: 55,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          sizedBoxW10(),
                                          Container(
                                            width: 1,
                                            height: 60,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Total Wallet Balance',
                                                style: openSansRegular.copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: Dimensions
                                                        .fontSizeDefault),
                                              ).tr(),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ',
                                                    style: openSansSemiBold
                                                        .copyWith(
                                                            color: Colors.black,
                                                            fontSize: 20),
                                                  ),
                                                  Text(
                                                    walletController.withdraw
                                                                .walletAmount !=
                                                            null
                                                        ? walletController
                                                            .withdraw
                                                            .walletAmount!
                                                            .toStringAsFixed(0)
                                                        : " 0",
                                                    style: openSansSemiBold
                                                        .copyWith(
                                                            color: Colors.black,
                                                            fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      sizedBox10(),
                                      Container(
                                        width: Get.size.width,
                                        height: 1,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Withdrawn Amount',
                                            style: openSansRegular.copyWith(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ).tr(),
                                          sizedBoxW10(),
                                          Flexible(
                                            child: Text(
                                              '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${walletController.withdraw.totalPending != null ? walletController.withdraw.totalPending.toString() : "0"}',
                                              style: openSansSemiBold.copyWith(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Withdraw Amount',
                                            style: openSansRegular.copyWith(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ).tr(),
                                          Text(
                                            '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${walletController.withdraw.withdrawAmount != null ? walletController.withdraw.withdrawAmount! : "0"}',
                                            style: openSansSemiBold.copyWith(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  //                                   ListTile(
                                  //                                     contentPadding: EdgeInsets.zero,
                                  //                                     leading: SizedBox(
                                  //                                       width: 11.h,
                                  //                                       height: 11.h,
                                  //                                       child: Image.asset(
                                  //                                         Images.icWallet,
                                  //                                       ),
                                  //                                     ),
                                  //                                     title: Padding(
                                  //                                       padding: const EdgeInsets.only(top: 5),
                                  //                                       child: Center(
                                  //                                         child: Text(
                                  //                                           'Wallet Amount ',
                                  //                                           style: openSansRegular.copyWith(
                                  //                                             fontSize: Dimensions.fontSizeDefault
                                  //                                           ),
                                  //                                         ).tr(),
                                  //                                       ),
                                  //                                     ),
                                  //                                     subtitle: SizedBox(
                                  //                                       height: 50,
                                  //                                       child: Card(
                                  //                                         shadowColor: COLORS().primaryColor,
                                  //                                         child: Row(
                                  //                                           mainAxisAlignment:
                                  //                                               MainAxisAlignment.center,
                                  //                                           children: [
                                  //                                             Text(
                                  //                                               '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ',
                                  //                                               style: Get
                                  //                                                   .theme.textTheme.bodyLarge!
                                  //                                                   .copyWith(fontSize: 14.sp),
                                  //                                             ),
                                  //                                             Text(
                                  //                                               walletController.withdraw
                                  //                                                           .walletAmount !=
                                  //                                                       null
                                  //                                                   ? walletController
                                  //                                                       .withdraw.walletAmount!
                                  //                                                       .toStringAsFixed(0)
                                  //                                                   : " 0",
                                  //                                               style: Get
                                  //                                                   .theme.textTheme.bodyLarge!
                                  //                                                   .copyWith(fontSize: 14.sp),
                                  //                                             ),
                                  //                                           ],
                                  //                                         ),
                                  //                                       ),
                                  //                                     ),
                                  //                                     trailing: walletController
                                  //                                                 .withdraw.walletAmount !=
                                  //                                             null
                                  //                                         ? GestureDetector(
                                  //                                             onTap: () async {
                                  //                                               walletController.updateAmountId =
                                  //                                                   null;
                                  //                                               walletController.clearAmount();
                                  //                                               await walletController
                                  //                                                   .withdrawWalletAmount();
                                  // //! wallet api
                                  //                                               Get.to(() => AddAmountScreen());
                                  //                                             },
                                  //                                             child: Container(
                                  //                                               decoration: BoxDecoration(
                                  //                                                 color: Get.theme.primaryColor,
                                  //                                                 borderRadius:
                                  //                                                     BorderRadius.circular(5),
                                  //                                               ),
                                  //                                               child: Padding(
                                  //                                                 padding: EdgeInsets.symmetric(
                                  //                                                     horizontal: 2.w),
                                  //                                                 child: Text(
                                  //                                                   'Withdraw',
                                  //                                                   style: Get.theme.textTheme
                                  //                                                       .titleSmall!
                                  //                                                       .copyWith(
                                  //                                                           fontSize: 14.sp),
                                  //                                                 ).tr(),
                                  //                                               ),
                                  //                                             ),
                                  //                                           )
                                  //                                         : const SizedBox(),
                                  //                                   ),
                                ),
                              ],
                            ),
                          ),
                          sizedBox10(),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: CustomDecoratedContainer(
                              color: Colors.white,
                              verticalPadding: 16,
                              child: DefaultTabController(
                                initialIndex: 0,
                                length: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100.w,
                                      height: 40,
                                      margin: EdgeInsets.only(
                                          left: 2.w, right: 2.w),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      child: TabBar(
                                        dividerColor: Colors.transparent,
                                        tabAlignment: TabAlignment.start,
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp),
                                        labelColor: Colors.white,
                                        unselectedLabelColor: Colors.grey,
                                        isScrollable: true,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        indicatorColor:
                                            Theme.of(context).primaryColor,
                                        labelPadding: EdgeInsets.zero,
                                        indicator: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        tabs: [
                                          SizedBox(
                                            width: 45.w,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Tab(
                                                text: tr(
                                                  'Withdraw History',
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 45.w,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Tab(
                                                text: tr('Wallet History'),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: SizedBox(
                                          height: Get.height * 0.53,
                                          child: TabBarView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            children: [
                                              walletController
                                                          .withdraw
                                                          .walletModel!
                                                          .isEmpty &&
                                                      walletController.withdraw
                                                              .walletModel ==
                                                          null
                                                  ? Center(
                                                      child: Text(
                                                        "You don't have any withdraw history here!",
                                                        style: openSansRegular
                                                            .copyWith(
                                                                color: Colors
                                                                    .black),
                                                      ).tr(),
                                                    )
                                                  : RefreshIndicator(
                                                      onRefresh: () async {
                                                        await walletController
                                                            .getAmountList();
                                                        walletController
                                                            .update();
                                                      },
                                                      child: ListView.builder(
                                                        itemCount:
                                                            walletController
                                                                .withdraw
                                                                .walletModel!
                                                                .length,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ',
                                                                              style: openSansRegular.copyWith(color: Colors.black),
                                                                            ),
                                                                            Text(
                                                                              walletController.withdraw.walletModel![index].withdrawAmount.toString(),
                                                                              style: openSansRegular.copyWith(color: Colors.black),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 5),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.schedule,
                                                                                color: Colors.black,
                                                                                size: 12,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 4),
                                                                                child: Text(
                                                                                  DateFormat('hh:mm a').format(DateTime.parse(walletController.withdraw.walletModel![index].createdAt.toString())),
                                                                                  style: openSansRegular.copyWith(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: [
                                                                            Text(
                                                                              DateFormat('dd-MM-yyyy').format(DateTime.parse(walletController.withdraw.walletModel![index].createdAt.toString())),
                                                                              style: openSansRegular.copyWith(color: Colors.black),
                                                                            ),
                                                                            // Padding(
                                                                            //   padding:
                                                                            //       const EdgeInsets.only(top: 5),
                                                                            //   child:
                                                                            //       Text(
                                                                            //     walletController.withdraw.walletModel![index].status!,
                                                                            //     style: Get.theme.textTheme.bodyMedium!.copyWith(
                                                                            //       color: walletController.withdraw.walletModel![index].status == 'Released' ? Colors.green : Colors.orange,
                                                                            //     ),
                                                                            //   ),
                                                                            // ),
                                                                          ],
                                                                        ),
                                                                        walletController.withdraw.walletModel![index].status ==
                                                                                'Pending'
                                                                            ? Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    walletController.fillAmount(walletController.withdraw.walletModel![index]);
                                                                                    walletController.updateAmountId = walletController.withdraw.walletModel![index].id;
                                                                                    Get.to(() => AddAmountScreen());
                                                                                    walletController.update();
                                                                                  },
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: Get.theme.primaryColor,
                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(10),
                                                                                      child: Text(
                                                                                        'Pending',
                                                                                        style: openSansRegular.copyWith(color: Colors.white),
                                                                                      ).tr(),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : const SizedBox(),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Divider(
                                                                  height: 3.w,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                              walletController
                                                          .withdraw
                                                          .walletTransactionModel!
                                                          .isEmpty &&
                                                      walletController.withdraw
                                                              .walletTransactionModel ==
                                                          null
                                                  ? Center(
                                                      child: const Text(
                                                              "You don't have any wallet transation history here!")
                                                          .tr(),
                                                    )
                                                  : RefreshIndicator(
                                                      onRefresh: () async {
                                                        await walletController
                                                            .getAmountList();
                                                        walletController
                                                            .update();
                                                      },
                                                      child: ListView.builder(
                                                        itemCount: walletController
                                                            .withdraw
                                                            .walletTransactionModel!
                                                            .length,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          String
                                                              transactiontype =
                                                              walletController
                                                                  .withdraw
                                                                  .walletTransactionModel![
                                                                      index]
                                                                  .transactionType
                                                                  .toString();
                                                          log('transaction-type-$transactiontype');

                                                          return Column(
                                                            children: [
                                                              // Container(color: Colors.red,
                                                              //   child: Text(
                                                              //     walletController.withdraw.walletModel![index].accountHolderName.toString(),
                                                              //     style: Get.theme.textTheme.bodyMedium!.copyWith(
                                                              //       fontWeight: FontWeight.w800,
                                                              //       color: walletController.withdraw.walletTransactionModel![index].paymentStatus == 'success' ? Colors.green : Colors.orange,
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              90.w,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    'Amount',
                                                                                    style: openSansRegular.copyWith(color: Colors.black),
                                                                                  ).tr(),
                                                                                  Text(
                                                                                    '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${walletController.withdraw.walletTransactionModel![index].amount.toString()}',
                                                                                    style: openSansRegular.copyWith(color: Colors.black),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 5),
                                                                                child: Text(
                                                                                  DateFormat('dd-MM-yyyy').format(DateTime.parse(walletController.withdraw.walletTransactionModel![index].createdAt.toString())),
                                                                                  style: openSansRegular.copyWith(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              90.w,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    'Transaction type',
                                                                                    style: Get.theme.textTheme.bodyLarge,
                                                                                  ).tr(),
                                                                                  transactiontype == 'recharge'
                                                                                      ? const Icon(
                                                                                          CupertinoIcons.bolt,
                                                                                          color: Colors.green,
                                                                                        )
                                                                                      : transactiontype == 'Gift'
                                                                                          ? const Icon(
                                                                                              CupertinoIcons.gift,
                                                                                              color: Colors.green,
                                                                                            )
                                                                                          : (transactiontype == 'Video Live Streaming')
                                                                                              ? const Icon(
                                                                                                  CupertinoIcons.video_camera_solid,
                                                                                                  color: Colors.red,
                                                                                                )
                                                                                              : (transactiontype == 'Audio Live Streaming')
                                                                                                  ? const Icon(
                                                                                                      CupertinoIcons.speaker_3_fill,
                                                                                                      color: Colors.red,
                                                                                                    )
                                                                                                  : (transactiontype == 'Call')
                                                                                                      ? const Icon(CupertinoIcons.phone)
                                                                                                      : (transactiontype == 'Chat')
                                                                                                          ? const Icon(CupertinoIcons.chat_bubble_2)
                                                                                                          : Image(
                                                                                                              height: 5.w,
                                                                                                              width: 5.w,
                                                                                                              image: const AssetImage('assets/images/report.png'),
                                                                                                            ),
                                                                                ],
                                                                              ),
                                                                              Text(
                                                                                walletController.withdraw.walletTransactionModel![index].paymentStatus != null ? '${walletController.withdraw.walletTransactionModel![index].paymentStatus?.toUpperCase().substring(0, 1) ?? ''}${walletController.withdraw.walletTransactionModel![index].paymentStatus?.substring(1) ?? ''}' : '',
                                                                                style: Get.theme.textTheme.bodyMedium!.copyWith(
                                                                                  fontWeight: FontWeight.w800,
                                                                                  color: walletController.withdraw.walletTransactionModel![index].paymentStatus == 'success' ? Colors.green : Colors.orange,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Divider(
                                                                  height: 3.w,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  //Withdraw amount
  void withdrawAmount({int? index}) {
    try {
      Get.defaultDialog(
        titlePadding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        title: walletController.updateAmountId != null
            ? tr('UPDATE AN AMOUNT')
            : tr('ADD AN AMOUNT'),
        titleStyle: Get.theme.textTheme.titleSmall,
        content: Column(
          children: [
            Icon(
              Icons.account_balance_outlined,
              size: 140,
              color: COLORS().blackColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSize10),
              child: CustomTextField(
                hintText:
                    "${global.getSystemFlagValue(global.systemFlagNameList.currency)} Add Amount",
                // hintText: ' Add Amount',
                controller: walletController.cWithdrawAmount,
                inputType: TextInputType.number,
              ),
            )
          ],
        ),
        confirm: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  primaryGreenColor, // Change this to your desired color
            ),
            onPressed: () {
              if (walletController.updateAmountId != null) {
                if (double.parse(walletController.cWithdrawAmount.text) <=
                    double.parse(
                        walletController.withdraw.walletAmount.toString())) {
                  walletController.updateAmount(
                      walletController.withdraw.walletModel![index!].id!);
                } else {
                  global.showToast(message: tr("Please enter a valid amount"));
                }
              } else {
                if (double.parse(walletController.cWithdrawAmount.text) <=
                    double.parse(
                        walletController.withdraw.walletAmount.toString())) {
                  walletController.addAmount();
                } else {
                  global.showToast(message: tr("Please enter a valid amount"));
                }
              }
              walletController.getAmountList();
              walletController.update();
            },
            child: const Text(MessageConstants.WITHDRAW).tr(),
          ),
        ),
      );
      walletController.update();
    } catch (e) {
      print('Exception :  Wallet_screen - withdrawAmount() :' + e.toString());
    }
  }
}
