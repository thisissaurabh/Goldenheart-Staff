import 'dart:io';

import 'package:astrowaypartner/theme/nativeTheme.dart';
import 'package:astrowaypartner/utils/dimensions.dart';
import 'package:astrowaypartner/widgets/custom_app_bar.dart';
import 'package:astrowaypartner/widgets/custom_button_widget.dart';
import 'package:astrowaypartner/widgets/custom_network_image.dart';
import 'package:astrowaypartner/widgets/custom_snackbar.dart';
import 'package:astrowaypartner/widgets/custom_textfield.dart';
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/HomeController/home_controller.dart';
import '../../../controllers/HomeController/wallet_controller.dart';
import 'package:astrowaypartner/utils/global.dart' as global;
import '../../../controllers/notification_controller.dart';
import '../../../utils/images.dart';
import '../../../utils/textstyles.dart';
import '../../../widgets/custom_dropdown.dart';
import 'live_video_player_screen.dart';


class LivePanelScreen extends StatelessWidget {
   LivePanelScreen({super.key});
  final homeController = Get.find<HomeController>();
   final notificationController = Get.find<NotificationController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Images.placeholder,height: 200,width: 200,),
              sizedBoxDefault(),
              Row(
                children: [
                  const Icon(Icons.video_camera_front_outlined,color:primaryBrownColor ,size: 50,),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Live Streaming',style: openSansSemiBold.copyWith(
                          fontSize: 14,
                        ),).tr(),
                        Text('Start your live streaming',style: openSansRegular.copyWith(
                            fontSize: 14,color: Theme.of(context).dividerColor.withOpacity(0.70)
                        ),).tr()
                      ],
                    ),
                  )
                ],
              ),
              sizedBoxDefault(),
              CustomButtonWidget(buttonText: 'Go Live',
                isBold: false,
                onPressed: () {
                // Get.to(() => YouTubeLiveStream());
                  Get.dialog(AddLiveStreamDialog());
                  },
                borderSideColor: Theme.of(context).dividerColor,
                textColor: Theme.of(context).primaryColor,
                color: Theme.of(context).dividerColor,)


            ],
          ),
        ),
      );
    });
  }
}


class AddLiveStreamDialog extends StatelessWidget {
   AddLiveStreamDialog({super.key});
   final _videoLinkController = TextEditingController();
  final _videoTitleController = TextEditingController();
   final _astrologerId = TextEditingController();
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    String categoryId;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize10),
      child: SingleChildScrollView(
        child: GetBuilder<HomeController>(builder: (homeControl) {
          return  Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Start Live Stream',
                      style: openSansRegular,).tr(),
                      IconButton(onPressed: () {
                        Get.back();
                      }, icon: Icon(Icons.close,color: Theme.of(context).dividerColor,
                        size: 30,)),
                    ],
                  ),
                  sizedBoxDefault(),
                  GestureDetector(onTap: () async {
                   homeControl.pickImage(false);
                  }, child: Container(
                    height: 150,
                    clipBehavior: Clip.hardEdge,
                    width: Get.size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                      color: Theme.of(context).dividerColor.withOpacity(0.60)),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child:homeControl.pickedLogo != null && homeControl.pickedLogo!.path.isNotEmpty ?

                    Image.file(
                      File( homeControl.pickedLogo!.path), fit: BoxFit.cover,
                    )
                     :
                    Image.asset(Images.icAddVideoHolder,
                      height: 10,
                    )

                  )),
                  sizedBoxDefault(),
                  CustomTextField(showTitle: true,
                    hintText: 'Video Title',
                    validation: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter a video title';
                      }
                      return null;
                    },
                    controller: _videoTitleController,
                  ),
                  sizedBoxDefault(),
                  CustomTextField(showTitle: true,
                    validation: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter a video link';
                      }
                      if (!Uri.tryParse(val)!.hasAbsolutePath ?? false) {
                        return 'Please enter a valid video link';
                      }
                      return null;
                    },
                    hintText: 'Video Link',

                    controller: _videoLinkController,
                  ),
                  sizedBoxDefault(),
                  sizedBoxDefault(),
                  CustomDropdownField(showTitle: true,
                    hintText: 'Select Live Stream Category',
                    options: homeControl.dropdownOptions.map((option) => option['label']!).toList(),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                    onChanged: (String? selectedLabel) {
                      if (selectedLabel != null) {
                        final selectedOption = homeControl.dropdownOptions.firstWhere(
                              (option) => option['label'] == selectedLabel,
                          orElse: () => {"value": "", "label": ""},
                        );

                        homeControl.setLiveStreamCategoryId("${selectedOption['value']}");
                        print(homeControl.liveStreamCategory);
                      }
                    },
                  ),
                  sizedBox30(),
                  homeControl.isLoading ? const Center(child: CircularProgressIndicator()) :
                  CustomButtonWidget(buttonText: 'Go Live',
                  color: Theme.of(context).dividerColor,
                  textColor: Theme.of(context).primaryColor,
                  borderSideColor:Theme.of(context).dividerColor,
                  onPressed: () {
                    if(_formKey.currentState!.validate()) {
                      homeControl.addLiveStreamVideo(_videoLinkController.text, _videoTitleController.text, global.user.id.toString(),homeControl.liveStreamCategory,homeControl.pickedLogo);
                      Get.back();
                    } else {
                      showCustomSnackBar('Please Enter Video Stream Details');
                    }
                  },
                  isBold: false,)


                ],
              ),
            ),
          );
        })




      ),
    );
  }
}
