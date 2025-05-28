import 'package:astrowaypartner/controllers/HomeController/wallet_controller.dart';
import 'package:astrowaypartner/theme/nativeTheme.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Wallet/Wallet_screen.dart';
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;

class CustomApp extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final double? height;
  final bool? isHideWallet;

  CustomApp({
    super.key,
    required this.title,
    this.isBackButtonExist = false,
    this.height,
    this.isHideWallet = false,
  });
  WalletController walletController = Get.find<WalletController>();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: colorAppbar,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
      ),
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/ic_appbar_logo.png",
              height: 40,
              width: 40,
            ),
            sizedBox4(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      isBackButtonExist
                          ? Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Icon(Icons.arrow_back)),
                            )
                          : const SizedBox(),
                      Text(
                        title!,
                        style: openSansMedium.copyWith(fontSize: 18),
                      ).tr(),
                    ],
                  ),
                ),

                isHideWallet!
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          walletController.getAmountList();
                          Get.to(() => WalletScreen());
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/ic_wallet_icon.png",
                              height: 28,
                              width: 28,
                              color: yellowColor,
                            ),
                            sizedBoxW10(),
                            Text(
                              '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${walletController.withdraw.walletAmount != null ? walletController.withdraw.walletAmount!.toStringAsFixed(0) : " 0"}',
                              style: openSansSemiBold.copyWith(
                                  color: yellowColor, fontSize: 20),
                            ),
                          ],
                        ),
                      )
                //  GestureDetector(
                // behavior: HitTestBehavior.translucent,
                // onTap: () {

                // },
                // child: const Icon(CupertinoIcons.bell)),
                //  GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   onTap: () {

                //   },
                //   child: const Icon(CupertinoIcons.bell)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 120);
}
