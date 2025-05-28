import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/nativeTheme.dart';
class ConfirmationDialog extends StatelessWidget {
  final Function() yesTap;
  final String title;
  const ConfirmationDialog({super.key, required this.yesTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return   AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: Get.textTheme.titleMedium,
      ).tr(),
      content: Row(
        children: [
          Expanded(
            flex: 4,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRedColor, // Change background color
                foregroundColor: Colors.white, // Change text color), // Optional: Customize padding
              ),
              onPressed: () {
                Get.back();
              },
              child: const Text('No').tr(),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 4,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreenColor, // Change background color
                foregroundColor: Colors.white, // Change text color), // Optional: Customize padding
              ),
              onPressed: yesTap,
              child: Text('YES').tr(),
            ),
          ),
        ],
      ),
    );
  }
}
