

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/nativeTheme.dart';
import '../utils/config.dart';
import '../utils/textstyles.dart';
import 'custom_network_image.dart';


class CallExtendDailog {
  static Timer? _autoDismissTimer;
  static Timer? _countdownTimer;
  static int _remainingSeconds = 15;

  static void showLoading({
    required String? img,
    required String? message,
    required String? name,
    required Function() backTap,
    required Function() onTap,
  }) {
    _autoDismissTimer?.cancel();
    _countdownTimer?.cancel();
    _remainingSeconds = 15;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          // Start countdown timer
          _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (_remainingSeconds > 0) {
              _remainingSeconds--;
              setState(() {});
            } else {
              _countdownTimer?.cancel();
            }
          });

          // Start auto-dismiss timer
          _autoDismissTimer = Timer(const Duration(seconds: 15), () {
            if (Get.isDialogOpen ?? false) {
              Get.back(); // Close dialog
              backTap();  // Trigger backTap
            }
          });

          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: Get.size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      CustomNetworkImageWidget(
                          height: 120, width: 120, image: '$imgBaseurl$img'),
                      const SizedBox(height: 5),
                      Text(
                        name!,
                        textAlign: TextAlign.center,
                        style: openSansRegular.copyWith(
                            color: Colors.black.withOpacity(0.60), fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message!,
                        textAlign: TextAlign.center,
                        style: openSansMedium.copyWith(color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Auto closing in $_remainingSeconds seconds',
                        style: openSansRegular.copyWith(
                            fontSize: 12, color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryRedColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                _autoDismissTimer?.cancel();
                                _countdownTimer?.cancel();
                                backTap();
                              },
                              child: const Text('No').tr(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreenColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                _autoDismissTimer?.cancel();
                                _countdownTimer?.cancel();
                                onTap();
                              },
                              child: const Text('YES').tr(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    _autoDismissTimer?.cancel();
    _countdownTimer?.cancel();
    Get.back();
  }
}
