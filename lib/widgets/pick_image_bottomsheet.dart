import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colorConst.dart';
import '../controllers/HomeController/edit_profile_controller.dart';

class PickImageBottomsheet extends StatelessWidget {
  PickImageBottomsheet({super.key});

  final EditProfileController editProfileController =
      Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ListTile(
            //   leading: Icon(
            //     Icons.camera_alt,
            //     color: COLORS().blackColor,
            //   ),
            //   title: Text(
            //     "Camera",
            //     style: Get.theme.primaryTextTheme.titleMedium,
            //   ).tr(),
            //   onTap: () async {
            //     editProfileController.imageFile = await editProfileController
            //         .imageService(ImageSource.camera);
            //     editProfileController.userFile =
            //         editProfileController.imageFile;
            //     editProfileController.profile = base64
            //         .encode(editProfileController.imageFile!.readAsBytesSync());
            //     editProfileController.update();
            //     Get.back();
            //     // editProfileController.onOpenCamera();

            //     // _tImage = await br.openCamera(Theme.of(context).primaryColor, isProfile: true);
            //   },
            // ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Colors.blue,
              ),
              title: Text(
                "Gallery",
                style: Get.theme.primaryTextTheme.titleMedium,
              ).tr(),
              onTap: () async {
                editProfileController.imageFile = await editProfileController
                    .imageService(ImageSource.gallery);
                editProfileController.userFile =
                    editProfileController.imageFile;
                editProfileController.profile = base64
                    .encode(editProfileController.imageFile!.readAsBytesSync());
                editProfileController.update();
                Get.back();
                // editProfileController.onOpenGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: COLORS().errorColor),
              title: Text(
                "Cancel",
                style: Get.theme.primaryTextTheme.titleMedium,
              ).tr(),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ],
    );
  }
}
