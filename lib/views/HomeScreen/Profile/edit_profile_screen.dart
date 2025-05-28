// ignore_for_file: unused_local_variable, must_be_immutable, use_build_context_synchronously

import 'dart:developer';
import 'package:astrowaypartner/constants/colorConst.dart';
import 'package:astrowaypartner/controllers/Authentication/login_controller.dart';
import 'package:astrowaypartner/controllers/Authentication/signup_controller.dart';
import 'package:astrowaypartner/controllers/HomeController/edit_profile_controller.dart';
import 'package:astrowaypartner/controllers/callAvailability_controller.dart';
import 'package:astrowaypartner/controllers/chatAvailability_controller.dart';
import 'package:astrowaypartner/controllers/following_controller.dart';
import 'package:astrowaypartner/theme/nativeTheme.dart';
import 'package:astrowaypartner/utils/images.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/drawer_screen.dart';

import 'package:astrowaypartner/views/HomeScreen/Profile/follower_list_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/Profile/mediapickerDialog.dart';

import 'package:astrowaypartner/views/HomeScreen/call/callAvailabilityScreen.dart';

import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:astrowaypartner/widgets/appbar_back_component.dart';
import 'package:astrowaypartner/widgets/custom_button_widget.dart';
import 'package:astrowaypartner/widgets/custom_decorated_controller.dart';
import 'package:astrowaypartner/widgets/custom_network_image.dart';
import 'package:astrowaypartner/widgets/custom_textfield.dart';
import 'package:astrowaypartner/widgets/date_converter.dart';
import 'package:astrowaypartner/widgets/pick_image_bottomsheet.dart';
import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;
import 'package:sizer/sizer.dart';
import '../../../controllers/goldenheart/profile_controller.dart';

import '../../../utils/config.dart';
import 'testscreen.dart';

enum StatusOption { image, video, text }

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GoldenProfileController profileControl = Get.find<GoldenProfileController>();

  // SignupController signupController = Get.find<SignupController>();
  FollowingController followingController = Get.find<FollowingController>();
  final EditProfileController editProfileController =
  Get.put(EditProfileController());

  ChatAvailabilityController chatAvailabilityController =
  Get.find<ChatAvailabilityController>();

  CallAvailabilityController callAvailabilityController =
  Get.find<CallAvailabilityController>();



  final drawerKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _languageController = TextEditingController();
  final _expYearsController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNumber = TextEditingController();

  final _dobController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileControl.astrologerProfileById(false);
    });
    _nameController.text = global.user.name != null && global.user.name != ''
        ? '${global.user.name} '.toUpperCase()
        : tr("Astrologer Name").toUpperCase();
    _genderController.text =
    global.user.gender != null && global.user.gender != ''
        ? '${global.user.gender}'
        : tr("- - - - -");

    _languageController.text = global.user.languageId!.isNotEmpty
        ? global.user.languageId!
        .map((e) => e.name)
        .toList()
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        : "";
    _expYearsController.text =
    global.user.expirenceInYear != null && global.user.expirenceInYear != 0
        ? '${global.user.expirenceInYear}'
        : "0";
    _dobController.text = global.user.birthDate != null &&
        global.user.birthDate != ''
        ? SimpleDateConverter.formatDateToCustomFormat(global.user.birthDate!)
        : tr("- - - - -");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          key: drawerKey,
          drawer: DrawerScreen(),
          appBar: CustomApp(
            title: "Profile",
            isBackButtonExist: true,
            isHideWallet: true,
          ),
          body: SingleChildScrollView(
            child: GetBuilder(
                init: GoldenProfileController(),
                builder: (golderProfileControl) {
                  return golderProfileControl.astrologerList.isEmpty
                      ? const SizedBox()
                      : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GetBuilder<EditProfileController>(
                          builder: (controller) {
                            return Column(
                              children: [
                                sizedBox10(),

                                Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Center(
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Colors.white),
                                                shape: BoxShape.circle),
                                            child: Container(
                                              height: 95,
                                              width: 95,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color: Colors.white),
                                                  shape: BoxShape.circle),
                                              child: Column(
                                                children: [
                                                  controller.userFile != null &&
                                                      controller.userFile != ''
                                                      ? Center(
                                                    child: Container(
                                                        clipBehavior:
                                                        Clip.hardEdge,
                                                        height: 95,
                                                        width: 95,
                                                        decoration:
                                                        const BoxDecoration(
                                                            shape: BoxShape
                                                                .circle),
                                                        child: Image.file(
                                                          controller
                                                              .userFile!,
                                                          fit: BoxFit.cover,
                                                        )),
                                                  )
                                                      : Center(
                                                    child: CustomRoundNetworkImage(
                                                        height: 95,
                                                        width: 95,
                                                        placeholder: Images
                                                            .icProfilePlaceholder,
                                                        image:
                                                        "$imgBaseurl${global.user.imagePath}"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 16,
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: TextButton(
                                            onPressed: () {
                                              Get.bottomSheet(
                                                  PickImageBottomsheet(),
                                                  backgroundColor: Colors.white);
                                            },
                                            child: Image.asset(
                                              "assets/images/ic_edit.png",
                                              height: 30,
                                              width: 30,
                                            )))
                                  ],
                                ),

                                // Center(
                                //   child: Container(
                                //     height: 100,
                                //     width: 100,
                                //     decoration: BoxDecoration(
                                //         border: Border.all(
                                //             width: 0.5, color: Colors.white),
                                //         shape: BoxShape.circle),
                                //     child: Container(
                                //       height: 95,
                                //       width: 95,
                                //       decoration: BoxDecoration(
                                //           color: Theme.of(context)
                                //               .primaryColor
                                //               .withOpacity(0.10),
                                //           borderRadius: BorderRadius.circular(12)),
                                //       child: CustomNetworkImageWidget(
                                //           radius: 0,
                                //           placeholder: Images.icProfilePlaceholder,
                                //           image:
                                //               "$imgBaseurl${golderProfileControl.astrologerList[0]!.imagePath}"),
                                //     ),
                                //   ),
                                // ),
                                sizedBox10(),
                                CustomTextField(
                                  showTitle: true,
                                  capitalization: TextCapitalization.words,
                                  controller: _nameController,
                                  hintText: "Full Name",
                                  readOnly: true,
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your full name';
                                    } else if (!RegExp(r'^[A-Za-z\s]+$')
                                        .hasMatch(value)) {
                                      return 'Name can only contain letters and spaces';
                                    }
                                    return null;
                                  },
                                ),
                                // sizedBox10(),

                                // CustomTextField(
                                //   showTitle: true,
                                //   capitalization: TextCapitalization.words,
                                //   controller: _genderController,
                                //   hintText: "Gender",
                                //   validation: (value) {
                                //     if (value == null || value.isEmpty) {
                                //       return 'Please enter your gender';
                                //     } else if (!RegExp(
                                //             r'^(Male|Female|Other|Non-Binary|Prefer not to say)$',
                                //             caseSensitive: false)
                                //         .hasMatch(value)) {
                                //       return 'Please enter a valid gender';
                                //     }
                                //     return null;
                                //   },
                                // ),
                                sizedBox10(),
                                CustomTextField(
                                  readOnly: true,
                                  showTitle: true,
                                  controller: _dobController,
                                  hintText: 'Date of Birth',
                                ),
                                sizedBox10(),
                                CustomTextField(
                                  readOnly: true,
                                  //    isDisableColor: true,
                                  // isEditable: true,

                                  showTitle: true,
                                  controller: _genderController,
                                  hintText: 'Gender',
                                ),

                                // sizedBox10(),

                                // CustomTextField(
                                //   inputType: TextInputType.number,
                                //   showTitle: true,
                                //   controller: _ageController, // Changed controller for age
                                //   hintText: "Age",
                                //   validation: (value) {
                                //     if (value == null || value.isEmpty) {
                                //       return 'Please enter your age';
                                //     } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                //       return 'Age must be a valid number';
                                //     } else if (int.parse(value) < 18 || int.parse(value) > 100) {
                                //       return 'Age must be between 18 and 100';
                                //     }
                                //     return null;
                                //   },
                                // ),
                                sizedBox10(),

                                CustomTextField(
                                  readOnly: true,
                                  showTitle: true,
                                  capitalization: TextCapitalization.words,
                                  controller: _languageController,
                                  hintText: "Language",
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your language';
                                    } else if (!RegExp(r'^[A-Za-z\s,]+$')
                                        .hasMatch(value)) {
                                      return 'Language can only contain letters and commas';
                                    }
                                    return null;
                                  },
                                ),
                                sizedBox10(),
                                UserSession.logintype == 1
                                    ? const SizedBox()
                                    : global.user.expirenceInYear != null &&
                                    global.user.expirenceInYear != 0
                                    ? CustomTextField(
                                  readOnly: true,
                                  inputType: TextInputType.number,
                                  showTitle: true,
                                  controller:
                                  _expYearsController, // Fixed controller
                                  hintText: "Experience (Years)",
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your experience in years';
                                    } else if (!RegExp(r'^[0-9]+$')
                                        .hasMatch(value)) {
                                      return 'Experience must be a valid number';
                                    } else if (int.parse(value) < 0 ||
                                        int.parse(value) > 50) {
                                      return 'Experience must be between 0 and 50 years';
                                    }
                                    return null;
                                  },
                                )
                                    : const SizedBox(),

                                // Container(margin: const EdgeInsets.all(16),
                                //   padding: const EdgeInsets.all(16),
                                //   decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(16),
                                //   color: Theme.of(context).primaryColor.withOpacity(0.10)
                                // ),
                                //   child: Column(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       InkWell(
                                //         onTap: () {
                                //           // storycontroller
                                //           //     .getAstroStory(signupController
                                //           //         .astrologerList[0]!.id
                                //           //         .toString())
                                //           //     .then((value) {
                                //           //   value.isEmpty
                                //           //       ? global.showToast(
                                //           //           message: 'No Story Uploaded',
                                //           //         )
                                //           //       : Navigator.of(context).push(
                                //           //           MaterialPageRoute(
                                //           //               builder: (context) => ViewStoriesScreen(
                                //           //                     profile:
                                //           //                         "$imgBaseurl${signupController.astrologerList[0]!.imagePath}",
                                //           //                     name: signupController.astrologerList[0]!.name.toString(),
                                //           //                     isprofile: false,
                                //           //                     astroId: int.parse(signupController.astrologerList[0]!.id.toString()),
                                //           //                   )),);
                                //           // });
                                //         },
                                //         child: Row(
                                //           children: [
                                //             CustomRoundNetworkImage(
                                //                 height: 80,
                                //                 width: 80,
                                //                 placeholder: Images.icProfilePlaceholder,
                                //                 image: "$imgBaseurl${signupController.astrologerList[0]!.imagePath}"),
                                //             sizedBoxW15(),
                                //             Expanded(
                                //                 child: Column(
                                //               crossAxisAlignment: CrossAxisAlignment.start,
                                //               children: [
                                //                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                   children: [
                                //                     Flexible(
                                //                       child: Text(
                                //                         maxLines: 1,
                                //                         overflow: TextOverflow.ellipsis,
                                //                         global.user.name != null &&
                                //                                 global.user.name != ''
                                //                             ? '${global.user.name} '.toUpperCase()
                                //                             : tr("Astrologer Name").toUpperCase(),
                                //                         style:
                                //                             openSansSemiBold.copyWith(fontSize: 14),
                                //                       ).tr(),
                                //                     ),

                                //                   ],
                                //                 ),
                                //                 Row(
                                //                   children: [
                                //                        Text(
                                //                       maxLines: 1,
                                //                       overflow: TextOverflow.ellipsis,
                                //                       'Mobile No',
                                //                       style: openSansRegular.copyWith(
                                //                           color: Theme.of(context)
                                //                               .dividerColor,
                                //                           fontSize: 14),
                                //                     ).tr(),
                                //                     sizedBoxW5(),
                                //                     Flexible(
                                //                       child: Text(
                                //                         maxLines: 1,
                                //                         overflow: TextOverflow.ellipsis,
                                //                         global.user.contactNo != null && global.user.contactNo != '' ? '${global.user.contactNo} '.toUpperCase() : tr("---").toUpperCase(),
                                //                         style: openSansRegular.copyWith(
                                //                             color: Theme.of(context)
                                //                                 .dividerColor,
                                //                             fontSize: 14),
                                //                       ).tr(),
                                //                     ),
                                //                   ],
                                //                 ),
                                //                 Row(
                                //                   children: [
                                //                        Text(
                                //                       maxLines: 1,
                                //                       overflow: TextOverflow.ellipsis,
                                //                       'Email',
                                //                       style: openSansRegular.copyWith(
                                //                           color: Theme.of(context)
                                //                               .dividerColor,
                                //                           fontSize: 14),

                                //                     ).tr(),
                                //                     sizedBoxW5(),
                                //                     Flexible(
                                //                       child: Text(
                                //                         maxLines: 1,
                                //                         overflow: TextOverflow.ellipsis,
                                //                         '${global.user.email != null && global.user.email != '' ? '${global.user.email} ' : tr("---")}',
                                //                         style: openSansRegular.copyWith(
                                //                             color: Theme.of(context)
                                //                                 .dividerColor,
                                //                             fontSize: 14),
                                //                       ).tr(),
                                //                     ),
                                //                   ],
                                //                 ),

                                //               ],
                                //             ))
                                //           ],
                                //         ),
                                //       ),
                                //       const SizedBox(
                                //         width: 8,
                                //       ),
                                //       sizedBoxDefault(),
                                //       GetBuilder<FollowingController>(
                                //         builder: (followingController) {
                                //           return  GestureDetector(
                                //             onTap: () {
                                //               Get.to(() => FollowerListScreen());
                                //             },
                                //             child: Container(
                                //               padding: const EdgeInsets.all(16),
                                //               decoration: BoxDecoration(
                                //                   border: Border.all(
                                //                     width: 0.5,
                                //                     color: Theme.of(context).primaryColor,,
                                //                   ),
                                //                   borderRadius: BorderRadius.circular(12)),
                                //               child: Row(mainAxisSize: MainAxisSize.min,
                                //                 children: [
                                //                   Text(
                                //                     followingController.followerList.length
                                //                         .toString(),
                                //                     style: openSansRegular.copyWith(
                                //                         fontSize: 14, color: Theme.of(context).primaryColor,),
                                //                   ).tr(/*args: [
                                //                         followingController.followerList.length
                                //                             .toString()
                                //                       ]*/),
                                //                   sizedBoxW10(),
                                //                   Text(
                                //                     'Followers',
                                //                     style: openSansRegular.copyWith(
                                //                         fontSize: 14, color: Theme.of(context).primaryColor,),
                                //                   ).tr(/*args: [
                                //                         followingController.followerList.length
                                //                             .toString()
                                //                       ]*/),
                                //                 ],
                                //               ),
                                //             ),
                                //           );
                                //         },
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: CustomDecoratedContainer(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          // ListTile(
                                          //   enabled: true,
                                          //   tileColor: Colors.white,
                                          //   leading: Icon(
                                          //     CupertinoIcons.person,
                                          //     size: 20.sp,
                                          //     color: Theme.of(context).primaryColor,
                                          //   ),
                                          //   title: Text(
                                          //     "Personal Detail",
                                          //     style:
                                          //         openSansRegular.copyWith(
                                          //           fontSize: 14
                                          //         ),
                                          //   ).tr(),
                                          //   trailing: Icon(
                                          //     Icons.arrow_forward_ios,
                                          //     size: 16.sp,
                                          //   ),
                                          //   onTap: () {
                                          //     Get.to(() =>  PersonalDetailScreen());
                                          //   },
                                          // ),
                                          // Divider(
                                          //   height: 3.w,
                                          //   color: Colors.grey.shade400,
                                          // ),
                                          // ListTile(
                                          //   enabled: true,
                                          //   tileColor: Colors.white,
                                          //   leading: Icon(
                                          //     color: Theme.of(context).primaryColor,
                                          //       CupertinoIcons.bag,
                                          //     size: 20.sp,
                                          //   ),
                                          //   title: Text(
                                          //     "Other Details",
                                          //     style:
                                          //     openSansRegular.copyWith(
                                          //         fontSize: 14
                                          //     ),
                                          //   ).tr(),
                                          //   trailing: Icon(
                                          //     Icons.arrow_forward_ios,
                                          //     size: 16.sp,
                                          //   ),
                                          //   onTap: () {
                                          //     Get.to(() => const OtherDetailScreen());
                                          //   },
                                          // ),
                                          // Divider(
                                          //   height: 3.w,
                                          //   color: Colors.grey.shade400,
                                          // ),

                                          // Divider(
                                          //   height: 3.w,
                                          //   color: Colors.grey.shade400,
                                          // ),
                                          // ListTile(
                                          //   enabled: true,
                                          //   tileColor: Colors.white,
                                          //   leading: Icon(
                                          //     color: Theme.of(context).primaryColor,
                                          //     Icons.sticky_note_2_outlined,
                                          //     size: 20.sp,
                                          //   ),
                                          //   title: Text(
                                          //     "Other Details",
                                          //     style:openSansRegular.copyWith(
                                          //         fontSize: 14
                                          //     ),
                                          //   ).tr(),
                                          //   trailing: Icon(
                                          //     Icons.arrow_forward_ios,
                                          //     size: 16.sp,
                                          //   ),
                                          //   onTap: () {
                                          //     Get.to(() => const OtherDetailScreen());
                                          //   },
                                          // ),
                                          // Divider(
                                          //   height: 3.w,
                                          //   color: Colors.grey.shade400,
                                          // ),
                                          // ListTile(
                                          //   enabled: true,
                                          //   tileColor: Colors.white,
                                          //   leading: Icon(
                                          //     color: Theme.of(context).primaryColor,
                                          //     Icons.task,
                                          //     size: 20.sp,
                                          //   ),
                                          //   title: Text(
                                          //     "Assignment",
                                          //     style:openSansRegular.copyWith(
                                          //         fontSize: 14
                                          //     ),
                                          //   ).tr(),
                                          //   trailing: Icon(
                                          //     Icons.arrow_forward_ios,
                                          //     size: 16.sp,
                                          //   ),
                                          //   onTap: () {
                                          //     Get.to(() => const AssignmentDetailScreen());
                                          //   },
                                          // ),
                                          // Divider(
                                          //   height: 3.w,
                                          //   color: Colors.grey.shade400,
                                          // ),
                                          // ListTile(
                                          //   enabled: true,
                                          //   tileColor: Colors.white,
                                          //   leading: Icon(
                                          //     color: Theme.of(context).primaryColor,
                                          //       CupertinoIcons.calendar,
                                          //     size: 20.sp,
                                          //   ),
                                          //   title: Text(
                                          //     "Availability",
                                          //     style:openSansRegular.copyWith(
                                          //         fontSize: 14
                                          //     ),
                                          //   ).tr(),
                                          //   trailing: Icon(
                                          //     Icons.arrow_forward_ios,
                                          //     size: 16.sp,
                                          //   ),
                                          //   onTap: () async {
                                          //     await golderProfileControl.astrologerProfileById(false);
                                          //     golderProfileControl.update();
                                          //     Get.to(() => AvailabiltyScreen());
                                          //   },
                                          // ),
                                          // Divider(
                                          //   height: 3.w,
                                          //   color: Colors.grey.shade400,
                                          // ),
                                          // ListTile(
                                          //   enabled: true,
                                          //   tileColor: Colors.white,
                                          //   leading: Icon(
                                          //     color: Theme.of(context).primaryColor,
                                          //              CupertinoIcons.chat_bubble_text,
                                          //     size: 20.sp,
                                          //   ),
                                          //   title: Text(
                                          //     "Chat Availability",
                                          //     style:openSansRegular.copyWith(
                                          //         fontSize: 14
                                          //     ),
                                          //   ).tr(),
                                          //   trailing: Icon(
                                          //     Icons.arrow_forward_ios,
                                          //     size: 16.sp,
                                          //   ),
                                          //   onTap: () {
                                          //     chatAvailabilityController.chatStatusName =
                                          //         global.user.chatStatus;
                                          //     global.user;
                                          //     if (global.user.chatWaitTime != null) {
                                          //       String formattedTime = DateFormat('HH:mm')
                                          //           .format(global.user.chatWaitTime!);
                                          //       chatAvailabilityController.waitTime.text =
                                          //           formattedTime;
                                          //       chatAvailabilityController.timeOfDay2 = TimeOfDay(
                                          //           hour: global.user.chatWaitTime!.hour,
                                          //           minute: global.user.chatWaitTime!.minute);
                                          //     }
                                          //     if (global.user.chatStatus == "Online") {
                                          //       chatAvailabilityController.chatType = 1;
                                          //       chatAvailabilityController.showAvailableTime =
                                          //           true;
                                          //     } else if (global.user.chatStatus == "Offline") {
                                          //       chatAvailabilityController.chatType = 2;
                                          //       chatAvailabilityController.showAvailableTime =
                                          //           true;
                                          //     } else {
                                          //       chatAvailabilityController.chatType = 3;
                                          //       chatAvailabilityController.showAvailableTime =
                                          //           false;
                                          //     }
                                          //     chatAvailabilityController.update();
                                          //     Get.to(() => ChatAvailabilityScreen());
                                          //   },
                                          // ),
                                          // Divider(
                                          //   height: 3.w,
                                          //   color: Colors.grey.shade400,
                                          // ),
                                          // ListTile(
                                          //   enabled: true,
                                          //   tileColor: Colors.white,
                                          //   leading: Icon(
                                          //     color: Theme.of(context).primaryColor,
                                          //    CupertinoIcons.phone,
                                          //     size: 20.sp,
                                          //   ),
                                          //   title: Text(
                                          //     "Call Availability",
                                          //     style:openSansRegular.copyWith(
                                          //         fontSize: 14
                                          //     ),
                                          //   ).tr(),
                                          //   trailing: Icon(
                                          //     Icons.arrow_forward_ios,
                                          //     size: 16.sp,
                                          //   ),
                                          //   onTap: () {
                                          //     callAvailabilityController.callStatusName =
                                          //         global.user.callStatus;
                                          //     if (global.user.callWaitTime != null) {
                                          //       String formattedTime = DateFormat('HH:mm')
                                          //           .format(global.user.callWaitTime!);
                                          //       callAvailabilityController.waitTime.text =
                                          //           formattedTime;
                                          //       callAvailabilityController.timeOfDay2 = TimeOfDay(
                                          //           hour: global.user.callWaitTime!.hour,
                                          //           minute: global.user.callWaitTime!.minute);
                                          //     }
                                          //     if (global.user.callStatus == "Online") {
                                          //       callAvailabilityController.callType = 1;
                                          //       callAvailabilityController.showAvailableTime =
                                          //           true;
                                          //     } else if (global.user.callStatus == "Offline") {
                                          //       callAvailabilityController.callType = 2;
                                          //       callAvailabilityController.showAvailableTime =
                                          //           true;
                                          //     } else {
                                          //       callAvailabilityController.callType = 3;
                                          //       callAvailabilityController.showAvailableTime =
                                          //           false;
                                          //     }
                                          //     callAvailabilityController.update();
                                          //     Get.to(() => CallAvailabilityScreen());
                                          //   },
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }));
                }),
          ),
          // bottomNavigationBar: Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: SingleChildScrollView(
          //     child: CustomButtonWidget(
          //       buttonText: 'Update',
          //       onPressed: () {
          //         print(global.user.userId.toString());
          //         editProfileController.userFile == null &&
          //                 editProfileController.imagePath.isEmpty
          //             ? editProfileController.updateProfileApi(
          //                 isImageIncluded: false,
          //                 _nameController.text,
          //                 _dobController.text,
          //                 global.user.userId.toString(),
          //                 global.user.id.toString(),
          //                 '')
          //             : editProfileController.updateProfileApi(
          //                 isImageIncluded: true,
          //                 _nameController.text,
          //                 _dobController.text,
          //                 global.user.userId.toString(),
          //                 global.user.id.toString(),
          //                 editProfileController.userFile!.path);
          //       },
          //       fontSize: 14,
          //     ),
          //   ),
          // ),
        ));
  }
}
