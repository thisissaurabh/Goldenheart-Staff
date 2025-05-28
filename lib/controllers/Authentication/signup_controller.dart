// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, avoid_print, duplicate_ignore

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:astrowaypartner/models/call_history_model.dart';
import 'package:astrowaypartner/models/primary_skill_model.dart';
import 'package:astrowaypartner/utils/config.dart';
import 'package:astrowaypartner/views/Authentication/login_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/home_screen.dart';
import 'package:astrowaypartner/views/splash/splashScreen.dart';
import 'package:astrowaypartner/widgets/loading_widget.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:astrowaypartner/utils/global.dart' as global;
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/Master Table Model/all_skill_model.dart';
import '../../models/Master Table Model/astrologer_category_list_model.dart';
import '../../models/Master Table Model/language_list_model.dart';
import '../../models/Master Table Model/primary_skill_model.dart';
import '../../models/time_availability_model.dart';
import '../../models/user_model.dart';
import '../../models/week_model.dart';
import '../../services/apiHelper.dart';
import '../../views/Authentication/OtpScreens/signup_otp_screen.dart';
import 'package:http/http.dart' as http;
import 'signup_otp_controller.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class SignupController extends GetxController {
//Class
  APIHelper apiHelper = APIHelper();
  String screen = 'signup_controller.dart';

  final cReply = TextEditingController();

  void clearReply() {
    cReply.text = '';
  }

  List<CurrentUser?> astrologerList = [];
  String countryCode = "+91";
  String phoneNumber = '';

  updateCountryCode(String? value) {
    countryCode = value!;
    log('country code is $countryCode');
    update();
  }

  updatephoneno(String? value) {
    phoneNumber = value!;
    log(' phoneNumber is $phoneNumber');
    update();
  }

  //List of checkbox
  List<AstrolgoerCategoryModel> astroId = [];
  List<PrimarySkillModel> primaryId = [];
  List<AllSkillModel> allId = [];
  List<LanguageModel> lId = [];

//static List
  List<Week>? week = [];
  List<TimeAvailabilityModel>? timeAvailabilityList = [];
  List<String?> daysList = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

//--------------------Personal Details----------------------
//Name
  final TextEditingController cName = TextEditingController();
  final FocusNode fName = FocusNode();

//Email
  final TextEditingController cEmail = TextEditingController();
  final FocusNode fEmail = FocusNode();

//Mobile Numer
  final TextEditingController cMobileNumber = TextEditingController();
  final TextEditingController userId = TextEditingController();
  final FocusNode fMobileNumber = FocusNode();

//Terms ANd Condition
  RxBool termAndCondtion = false.obs;

//--------------------------Skills Details----------------------
//User Image
  Uint8List? tImage;
  File? selectedImage;
  var imagePath = ''.obs;

  onOpenCamera() async {
    selectedImage = await openCamera(Get.theme.primaryColor).obs();
    update();
  }

  onOpenGallery() async {
    selectedImage = await openGallery(Get.theme.primaryColor).obs();
    update();
  }

  Future<File?> openCamera(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage =
      await picker.pickImage(source: ImageSource.camera);

      if (_selectedImage != null) {
        CroppedFile? _croppedFile = await ImageCropper().cropImage(
          sourcePath: _selectedImage.path,
          aspectRatio:
          isProfile ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: isProfile
                  ? CropAspectRatioPreset.square
                  : CropAspectRatioPreset.original,
              backgroundColor: Colors.grey,
              toolbarColor: Colors.grey[100],
              toolbarWidgetColor: color,
              activeControlsWidgetColor: color,
              cropFrameColor: color,
              lockAspectRatio: isProfile ? true : false,
            ),
          ],
        );
        if (_croppedFile != null) {
          return File(_croppedFile.path);
        }
      }
    } catch (e) {
      print("Exception - $screen - openCamera():" + e.toString());
    }
    return null;
  }

  Future<File?> openGallery(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage =
      await picker.pickImage(source: ImageSource.gallery);

      if (_selectedImage != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: _selectedImage.path,
          aspectRatio:
          isProfile ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: isProfile
                  ? CropAspectRatioPreset.square
                  : CropAspectRatioPreset.original,
              backgroundColor: Colors.grey,
              toolbarColor: Colors.grey[100],
              toolbarWidgetColor: color,
              activeControlsWidgetColor: color,
              cropFrameColor: color,
              lockAspectRatio: isProfile ? true : false,
            ),
          ],
        );

        if (croppedFile != null) {
          selectedImage = File(croppedFile.path);
          List<int> imageBytes = selectedImage!.readAsBytesSync();
          print(imageBytes);
          imagePath.value = base64Encode(imageBytes);

          List<int> decodedbytes = base64.decode(imagePath.value);
          return File(decodedbytes.toString());
        }
      }
    } catch (e) {
      print("Exception - $screen - openGallery()" + e.toString());
    }
    return null;
  }

//Date oF Birth
  final TextEditingController cBirthDate = TextEditingController();
  DateTime? selectedDate;

  onDateSelected(DateTime? picked) {
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      cBirthDate.text = selectedDate.toString();
      cBirthDate.text = formatDate(selectedDate!, [dd, '-', mm, '-', yyyy]);
    }
    update();
  }

  bool select = false;

//Gender List
  String selectedGender = "Male";
  String selectedSocialMedia = "Youtube";

  //Choose category
  final cSelectCategory = TextEditingController();

//Primary Skills
  final TextEditingController cPrimarySkill = TextEditingController();

//All Skills
  final TextEditingController cAllSkill = TextEditingController();

//Language
  final TextEditingController cLanguage = TextEditingController();

//Charge
  final TextEditingController cCharges = TextEditingController();
  final FocusNode fCharges = FocusNode();

  //Video call Charge
  final TextEditingController cVideoCharges = TextEditingController();
  final FocusNode fVideoCharges = FocusNode();

  //Charge
  final TextEditingController cReportCharges = TextEditingController();
  final FocusNode fReportCharges = FocusNode();

//Expirence
  final TextEditingController cExpirence = TextEditingController();
  final FocusNode fExpirence = FocusNode();

//Contribution Hours
  final TextEditingController cContributionHours = TextEditingController();
  final FocusNode fContributionHours = FocusNode();

//Hear about astrotalk
  final TextEditingController cHearAboutAstroGuru = TextEditingController();
  final FocusNode fHearAboutAstroGuru = FocusNode();

//Working on Any Other Platform
  final TextEditingController cNameOfPlatform = TextEditingController();
  final FocusNode fNameOfPlatform = FocusNode();
  final TextEditingController cMonthlyEarning = TextEditingController();
  final FocusNode fMonthlyEarning = FocusNode();
  int? anyOnlinePlatform;

  void setOnlinePlatform(int? index) {
    anyOnlinePlatform = index;
    update();
  }

//----------------Other Details--------------

//on board you
  final TextEditingController cOnBoardYou = TextEditingController();
  final FocusNode fOnBoardYou = FocusNode();

//time for interview
  final TextEditingController cTimeForInterview = TextEditingController();
  final FocusNode fTimeForInterview = FocusNode();

//live city
  final TextEditingController cLiveCity = TextEditingController();
  final FocusNode fLiveCity = FocusNode();

//source of business
  String? selectedSourceOfBusiness;

//source of business
  String? selectedHighestQualification;

//source of business
  String? selectedDegreeDiploma;

//College/School/university
  final TextEditingController cCollegeSchoolUniversity =
  TextEditingController();
  final FocusNode fCollegeSchoolUniversity = FocusNode();

//Learn Astrology
  final TextEditingController cLearnAstrology = TextEditingController();
  final FocusNode fLearnAstroLogy = FocusNode();

//Insta
  final TextEditingController cInsta = TextEditingController();
  final FocusNode fInsta = FocusNode();

//Facebook
  final TextEditingController cFacebook = TextEditingController();
  final FocusNode fFacebook = FocusNode();

//LinkedIn
  final TextEditingController cLinkedIn = TextEditingController();
  final FocusNode fLinkedIn = FocusNode();

//Youtube
  final TextEditingController cYoutube = TextEditingController();
  final FocusNode fYoutube = FocusNode();

//Website
  final TextEditingController cWebSite = TextEditingController();
  final FocusNode fWebSite = FocusNode();

//refer
  final TextEditingController cNameOfReferPerson = TextEditingController();
  final FocusNode fNameOfReferPerson = FocusNode();
  int? referPerson;

  void setReferPerson(int? index) {
    referPerson = index;
    update();
  }

//Expected Minimum Earning from Astroguru
  final TextEditingController cExptectedMinimumEarning =
  TextEditingController();
  final FocusNode fExpectedMinimumEarning = FocusNode();

//Expected Maximum Earning
  final TextEditingController cExpectedMaximumEarning = TextEditingController();
  final FocusNode fExpectedMaximumEarning = FocusNode();

//Long Bio
  final TextEditingController cLongBio = TextEditingController();
  final FocusNode fLongBio = FocusNode();

//-------------------------Assignment----------------------------

//foreign country
  String? selectedForeignCountryCount;

//currently working as job
  String? selectedCurrentlyWorkingJob;
  final TextEditingController cforeignCountry = TextEditingController();
  final FocusNode cforeignFunction = FocusNode();

//Facebook
  final TextEditingController cGoodQuality = TextEditingController();
  final FocusNode fGoodQuality = FocusNode();

//LinkedIn
  final TextEditingController cBiggestChallenge = TextEditingController();
  final FocusNode fBiggestChallenge = FocusNode();

//Youtube
  final TextEditingController cRepeatedQuestion = TextEditingController();
  final FocusNode fRepeatedQuestion = FocusNode();

//---------------------------Availability---------------------------
  final TextEditingController cSunday = TextEditingController();
  final TextEditingController cMonday = TextEditingController();
  final TextEditingController cTuesday = TextEditingController();
  final TextEditingController cWednesday = TextEditingController();
  final TextEditingController cThursday = TextEditingController();
  final TextEditingController cFriday = TextEditingController();
  final TextEditingController cSaturday = TextEditingController();

  final cStartTime = TextEditingController();
  final cEndTime = TextEditingController();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();

  void clearTime() {
    cStartTime.text = '';
    cEndTime.text = '';
  }

// dynamic Availability Widget
  Widget dynamicWeekFieldWidget(BuildContext? context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: 35,
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(""),
        ),
      ),
    );
  }

  selectStartTime(BuildContext context) async {
    try {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(12)),
              height: 300,
              child: Column(
                children: [
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss the picker
                        },
                      ),
                      CupertinoButton(
                        child: Text("Done"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Confirm selection
                        },
                      ),
                    ],
                  ),
                  // CupertinoDatePicker for time only
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: DateTime(
                        DateTime
                            .now()
                            .year,
                        DateTime
                            .now()
                            .month,
                        DateTime
                            .now()
                            .day,
                        selectedStartTime.hour,
                        selectedStartTime.minute,
                      ),
                      use24hFormat: false, // Set to true for 24-hour format
                      onDateTimeChanged: (DateTime newTime) {
                        selectedStartTime = TimeOfDay(
                          hour: newTime.hour,
                          minute: newTime.minute,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).then((_) {
        cStartTime.text = selectedStartTime.format(context);
        update();
      });
    } catch (e) {
      print('Exception  - $screen - selectStartTime(): ' + e.toString());
    }
  }

  //Available Time Start
  // selectStartTime(BuildContext context) async {
  //   try {
  //     final TimeOfDay? timeOfDay = await showTimePicker(
  //       barrierDismissible: true,
  //       context: context,
  //       initialTime: selectedStartTime,
  //       initialEntryMode: TimePickerEntryMode.dial,
  //     );
  //     if (timeOfDay != null) {
  //       selectedStartTime = timeOfDay;
  //       cStartTime.text = timeOfDay.format(context);
  //     }
  //     update();
  //   } catch (e) {
  //     print('Exception  - $screen - selectStartTime():' + e.toString());
  //   }
  // }
  //Available Time End

  selectEndTime(BuildContext context) async {
    try {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss the picker
                        },
                      ),
                      CupertinoButton(
                        child: Text("Done"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Confirm selection
                        },
                      ),
                    ],
                  ),
                  // CupertinoDatePicker for time only
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: DateTime(
                        DateTime
                            .now()
                            .year,
                        DateTime
                            .now()
                            .month,
                        DateTime
                            .now()
                            .day,
                        selectedEndTime.hour,
                        selectedEndTime.minute,
                      ),
                      use24hFormat: false,
                      // Set to true for 24-hour format
                      onDateTimeChanged: (DateTime newTime) {
                        if (newTime.isBefore(
                          DateTime(
                            DateTime
                                .now()
                                .year,
                            DateTime
                                .now()
                                .month,
                            DateTime
                                .now()
                                .day,
                            selectedStartTime.hour,
                            selectedStartTime.minute,
                          ),
                        )) {
                          // Prevent selecting a time before the start time
                          return;
                        }
                        selectedEndTime = TimeOfDay(
                          hour: newTime.hour,
                          minute: newTime.minute,
                        );
                      },
                      minimumDate: DateTime(
                        DateTime
                            .now()
                            .year,
                        DateTime
                            .now()
                            .month,
                        DateTime
                            .now()
                            .day,
                        selectedStartTime.hour,
                        selectedStartTime.minute,
                      ), // Disable times before start time
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).then((_) {
        cEndTime.text = selectedEndTime.format(context);
        update();
      });
    } catch (e) {
      print('Exception - $screen - selectEndTime(): ' + e.toString());
    }
  }

  // selectEndTime(BuildContext context) async {
  //   try {
  //     await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           child: Container(
  //             height: 300,
  //             decoration: BoxDecoration(
  //                 color: CupertinoColors.systemBackground.resolveFrom(context),
  //                 borderRadius: BorderRadius.circular(12)
  //             ),

  //             child: Column(
  //               children: [
  //                 // Action buttons
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     CupertinoButton(
  //                       child: Text("Cancel"),
  //                       onPressed: () {
  //                         Navigator.of(context).pop(); // Dismiss the picker
  //                       },
  //                     ),
  //                     CupertinoButton(
  //                       child: Text("Done"),
  //                       onPressed: () {
  //                         Navigator.of(context).pop(); // Confirm selection
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //                 // CupertinoDatePicker for time only
  //                 Expanded(
  //                   child: CupertinoDatePicker(
  //                     mode: CupertinoDatePickerMode.time,
  //                     initialDateTime: DateTime(
  //                       DateTime.now().year,
  //                       DateTime.now().month,
  //                       DateTime.now().day,
  //                       selectedEndTime.hour,
  //                       selectedEndTime.minute,
  //                     ),
  //                     use24hFormat: false, // Set to true for 24-hour format
  //                     onDateTimeChanged: (DateTime newTime) {
  //                       selectedEndTime = TimeOfDay(
  //                         hour: newTime.hour,
  //                         minute: newTime.minute,
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ).then((_) {
  //       cEndTime.text = selectedEndTime.format(context);
  //       update();
  //     });
  //   } catch (e) {
  //     print('Exception - $screen - selectEndTime(): ' + e.toString());
  //   }
  // }

  // selectEndTime(BuildContext context) async {
  //   try {
  //     final TimeOfDay? timeOfDay = await showTimePicker(
  //       context: context,
  //       initialTime: selectedEndTime,
  //       initialEntryMode: TimePickerEntryMode.dial,
  //     );
  //     if (timeOfDay != null) {
  //       selectedEndTime = timeOfDay;
  //       cEndTime.text = timeOfDay.format(context);
  //     }
  //     update();
  //   } catch (e) {
  //     print('Exception - $screen - selectEndTime():' + e.toString());
  //   }
  // }

//----------------------Button On Tap-------------------
  int index = 0;

  onStepBack() {
    try {
      if (index >= 0) {
        index -= 1;
        update();
      }
    } catch (err) {
      global.printException("singup_controller.dart", "onStepBack", err);
    }
  }

  onStepNext() {
    try {
      if (index == 0 || index > 0) {
        index += 1;
        update();
      }
    } catch (err) {
      global.printException("singup_controller.dart", "onStepNext", err);
    }
  }

  validateForm(int index, {
    BuildContext? context,
    String countrycode = '+91',
  }) {
    try {
//------Validation_of_Personal_Detail-----------------

      if (index == 0) {
        if (cName.text.isNotEmpty &&
            cEmail.text.isNotEmpty &&
            GetUtils.isEmail(cEmail.text) &&
            cMobileNumber.text.isNotEmpty &&
            cMobileNumber.text.length == 10 &&
            termAndCondtion.value) {
          print("index = 0");
          // checkContactExist(cMobileNumber.text, countrycode);
          onStepNext(); // Move inside successful validation
        } else {
          if (cName.text.isEmpty) {
            global.showToast(message: "Please Enter Valid Name");
          } else if (cEmail.text.isEmpty || !GetUtils.isEmail(cEmail.text)) {
            global.showToast(message: "Please Enter Valid Email Address");
          } else if (cMobileNumber.text.isEmpty ||
              cMobileNumber.text.length != 10) {
            global.showToast(message: "Please Enter Valid Mobile Number");
          } else if (!termAndCondtion.value) {
            global.showToast(message: "Please Agree With T&C");
          } else {
            global.showToast(
                message: "Something Wrong in Personal Detail Form");
          }
        }
      }

//------Validation_of_Skill_Detail-----------------
      else if (index == 1) {
        if (selectedGender != "" &&
            selectedDate != null &&
            cSelectCategory.text != "" &&
            cPrimarySkill.text != "" &&
            cAllSkill.text != "" &&
            cLanguage.text != "" &&
            // cCharges.text != "" &&
            // cVideoCharges.text != "" &&
            // cReportCharges.text != "" &&
            cExpirence.text != "" &&
            cContributionHours.text != "" &&
            (anyOnlinePlatform == 1 && cNameOfPlatform.text != "" ||
                anyOnlinePlatform == 2 ||
                anyOnlinePlatform == null) &&
            (anyOnlinePlatform == 1 && cMonthlyEarning.text != "" ||
                anyOnlinePlatform == 2 ||
                anyOnlinePlatform == null)) {
          print("index = 1");
          onStepNext();
          // } else if (selectedImage == null) {
          //   global.showToast(message: "Please Select Image");
        } else if (selectedGender == "") {
          global.showToast(message: "Please Select Gender");
        } else if (selectedDate == null) {
          global.showToast(message: "Please Select Date of Birth");
        } else if (cSelectCategory.text == "") {
          global.showToast(message: "Please Select astrologer category");
        } else if (cPrimarySkill.text == "") {
          global.showToast(message: "Please Select Primary Skill");
        } else if (cAllSkill.text == "") {
          global.showToast(message: "Please Select All Skill");
        } else if (cLanguage.text == "") {
          global.showToast(message: "Please Select Language");
        } else if (cCharges.text == "") {
          global.showToast(message: "Please Enter Per Minutes Charges");
        }
        // else if (cVideoCharges.text == "") {
        //   global.showToast(message: "Please Enter video Charges");
        // } else if (cReportCharges.text == "") {
        //   global.showToast(message: "Please Enter report Charges");
        // }
        else if (cExpirence.text == "") {
          global.showToast(message: "Please Enter Experience");
        } else if (cContributionHours.text == "") {
          global.showToast(message: "Please Enter Contribution Hours");
        } else if (anyOnlinePlatform == 1 && cNameOfPlatform.text == "") {
          global.showToast(message: "Please Enter Name Of Platform");
        } else if (anyOnlinePlatform == 1 && cMonthlyEarning.text == "") {
          global.showToast(message: "Please Enter Monthly Earning");
        } else {
          global.showToast(message: "Something Wrong in Skill Detail Form");
        }
      }
//------Validation_of_Other_Detail-----------------
      else if (index == 2) {
        if (cOnBoardYou.text != "" &&
            cTimeForInterview.text != "" &&
            (selectedSourceOfBusiness != "" &&
                selectedSourceOfBusiness != null) &&
            (selectedHighestQualification != "" &&
                selectedHighestQualification != null) &&
            (selectedDegreeDiploma != "" && selectedDegreeDiploma != null) &&
            cExptectedMinimumEarning.text != "" &&
            cExpectedMaximumEarning.text != "" &&
            cLongBio.text != "") {
          print("index = 2");
          onStepNext();
        } else if (cOnBoardYou.text == "") {
          global.showToast(message: "Please Enter Why Should We Onboard You");
        } else if (cTimeForInterview.text == "") {
          global.showToast(message: "Please Enter Suitable Time For Interview");
        } else if (selectedSourceOfBusiness == null ||
            selectedSourceOfBusiness == "") {
          global.showToast(message: "Please Select Source Of Business");
        } else if (selectedHighestQualification == null ||
            selectedHighestQualification == "") {
          global.showToast(message: "Please Select Highest Qualification");
        } else if (selectedDegreeDiploma == null ||
            selectedDegreeDiploma == "") {
          global.showToast(message: "Please Select Degree/Diploma");
        } else if (cExptectedMinimumEarning.text == "") {
          global.showToast(message: "Please Enter Minimum Earning");
        } else if (cExpectedMaximumEarning.text == "") {
          global.showToast(message: "Please Enter Maximum Earning");
        } else if (double.parse(cExptectedMinimumEarning.text) >=
            double.parse(cExpectedMaximumEarning.text)) {
          global.showToast(
              message: "Maximum Earning Should Be  Greater Than Minimum");
        } else if (cLongBio.text == "") {
          print(cExptectedMinimumEarning.text);
          print(cExpectedMaximumEarning.text);
          global.showToast(message: "Please Enter Long Bio");
        } else {
          global.showToast(message: "Something Wrong in Other Detail Form");
        }
      }
//------Validation_of_Assignment-----------------
      else if (index == 3) {
        if ((cforeignCountry.text != "" && cforeignCountry.text != null) &&
            (selectedCurrentlyWorkingJob != "" &&
                selectedCurrentlyWorkingJob != null) &&
            cGoodQuality.text != "" &&
            cBiggestChallenge.text != "" &&
            cRepeatedQuestion.text != "") {
          print("index = 3");
          onStepNext();
        } else if (cforeignCountry.text == "" || cforeignCountry.text == null) {
          global.showToast(
              message: "Please Add Number of Foreign Country You Lived");
        } else if (selectedCurrentlyWorkingJob == "" ||
            selectedCurrentlyWorkingJob == null) {
          global.showToast(
              message: "Please Select Current Working Fulltime Job");
        } else if (cGoodQuality.text == "") {
          global.showToast(message: "Please Enter Good Quality");
        } else if (cBiggestChallenge.text == "") {
          global.showToast(message: "Please Enter Biggest Challenge");
        } else if (cRepeatedQuestion.text == "") {
          global.showToast(message: "Please Enter Repeated Question");
        } else {
          global.showToast(message: "Something Wrong in Assignment Form");
        }
      }
//------Validation_of_Availability_Detail-----------------
      else if (index == 4) {
        print('check');
        // signupAstrologer();
        if (cStartTime.text != '' && cEndTime.text != '') {
          print('check2');

          signupAstrologer();
        } else {
          print('check3');
          global.showToast(message: "Please select time");
        }
        print('check4');
      } else {
        global.showToast(message: "No Index Found");
      }
    } catch (err) {
      global.printException("signup_controller.dart", "validateForm()", err);
    }
  }

//Register astrologer
  Future signupAstrologer() async {
    try {
      await global.checkBody().then(
            (networkResult) async {
          if (networkResult) {
            await global.getDeviceData();
            global.astrologerUser.userId = int.parse(userId.text);
            global.astrologerUser.roleId = 2;
            global.astrologerUser.name = cName.text;
            global.astrologerUser.email = cEmail.text;
            global.astrologerUser.contactNo = cMobileNumber.text;
            global.astrologerUser.imagePath = imagePath.value;
            global.astrologerUser.gender = selectedGender;
            global.astrologerUser.birthDate = selectedDate;
            global.astrologerUser.primarySkill = cPrimarySkill.text;
            global.astrologerUser.astrologerCategory = cSelectCategory.text;
            global.astrologerUser.allSkill = cAllSkill.text;
            global.astrologerUser.languageKnown = cLanguage.text;
            global.astrologerUser.charges = int.parse('20');
            global.astrologerUser.videoCallRate = int.parse('20');
            global.astrologerUser.reportRate = int.parse('20');

            // global.astrologerUser.charges = int.parse(cCharges.text);
            // global.astrologerUser.videoCallRate = int.parse(cVideoCharges.text);
            // global.astrologerUser.reportRate = int.parse(cReportCharges.text);
            global.astrologerUser.expirenceInYear = int.parse(cExpirence.text);
            global.astrologerUser.dailyContributionHours =
                int.parse(cContributionHours.text);
            global.astrologerUser.hearAboutAstroGuru = selectedSocialMedia;
            global.astrologerUser.isWorkingOnAnotherPlatform =
                anyOnlinePlatform;
            global.astrologerUser.otherPlatformName = cNameOfPlatform.text;
            global.astrologerUser.otherPlatformMonthlyEarning =
                cMonthlyEarning.text;
            global.astrologerUser.onboardYou = cOnBoardYou.text;
            global.astrologerUser.suitableInterviewTime =
                cTimeForInterview.text;
            global.astrologerUser.currentCity = cLiveCity.text;
            global.astrologerUser.mainSourceOfBusiness =
                selectedSourceOfBusiness;
            global.astrologerUser.highestQualification =
                selectedHighestQualification;
            global.astrologerUser.degreeDiploma = selectedDegreeDiploma;
            global.astrologerUser.collegeSchoolUniversity =
                cCollegeSchoolUniversity.text;
            global.astrologerUser.learnAstrology = cLearnAstrology.text;
            global.astrologerUser.instagramProfileLink = cInsta.text;
            global.astrologerUser.facebookProfileLink = cFacebook.text;
            global.astrologerUser.linkedInProfileLink = cLinkedIn.text;
            global.astrologerUser.youtubeProfileLink = cYoutube.text;
            global.astrologerUser.webSiteProfileLink = cWebSite.text;
            global.astrologerUser.isAnyBodyRefer = referPerson;
            global.astrologerUser.referedPersonName = cNameOfReferPerson.text;
            global.astrologerUser.expectedMinimumEarning =
                int.parse(cExptectedMinimumEarning.text);
            global.astrologerUser.expectedMaximumEarning =
                int.parse(cExpectedMaximumEarning.text);
            global.astrologerUser.longBio = cLongBio.text;
            global.astrologerUser.foreignCountryCount = cforeignCountry.text;
            global.astrologerUser.currentlyWorkingJob =
                selectedCurrentlyWorkingJob;
            global.astrologerUser.goodQualityOfAstrologer = cGoodQuality.text;
            global.astrologerUser.biggestChallengeFaced =
                cBiggestChallenge.text;
            global.astrologerUser.repeatedQuestion = cRepeatedQuestion.text;
            global.astrologerUser.astrologerCategoryId = [];
            global.astrologerUser.primarySkillId = [];
            global.astrologerUser.allSkillId = [];
            global.astrologerUser.languageId = [];
            global.astrologerUser.week = [];

            print(
                "global.astrologerUser.userId ===== ${global.astrologerUser
                    .userId}");
            print(
                "global.astrologerUser.roleId ===== ${global.astrologerUser
                    .roleId}");
            print(
                "global.astrologerUser.name ===== ${global.astrologerUser
                    .name}");
            print(
                "global.astrologerUser.email ===== ${global.astrologerUser
                    .email}");
            print(
                "global.astrologerUser.contactNo ===== ${global.astrologerUser
                    .contactNo}");
            print(
                "global.astrologerUser.imagePath ===== ${global.astrologerUser
                    .imagePath}");
            print(
                "global.astrologerUser.gender ===== ${global.astrologerUser
                    .gender}");
            print(
                "global.astrologerUser.birthDate ===== ${global.astrologerUser
                    .birthDate}");
            print(
                "global.astrologerUser.primarySkill ===== ${global
                    .astrologerUser.primarySkill}");
            print(
                "global.astrologerUser.astrologerCategory ===== ${global
                    .astrologerUser.astrologerCategory}");
            print(
                "global.astrologerUser.allSkill ===== ${global.astrologerUser
                    .allSkill}");
            print(
                "global.astrologerUser.languageKnown ===== ${global
                    .astrologerUser.languageKnown}");
            print(
                "global.astrologerUser.charges ===== ${global.astrologerUser
                    .charges}");
            print(
                "global.astrologerUser.videoCallRate ===== ${global
                    .astrologerUser.videoCallRate}");
            print(
                "global.astrologerUser.reportRate ===== ${global.astrologerUser
                    .reportRate}");
            print(
                "global.astrologerUser.expirenceInYear ===== ${global
                    .astrologerUser.expirenceInYear}");
            print(
                "global.astrologerUser.dailyContributionHours ===== ${global
                    .astrologerUser.dailyContributionHours}");
            print(
                "global.astrologerUser.hearAboutAstroGuru ===== ${global
                    .astrologerUser.hearAboutAstroGuru}");
            print(
                "global.astrologerUser.isWorkingOnAnotherPlatform ===== ${global
                    .astrologerUser.isWorkingOnAnotherPlatform}");
            print(
                "global.astrologerUser.otherPlatformName ===== ${global
                    .astrologerUser.otherPlatformName}");
            print(
                "global.astrologerUser.otherPlatformMonthlyEarning ===== ${global
                    .astrologerUser.otherPlatformMonthlyEarning}");
            print(
                "global.astrologerUser.onboardYou ===== ${global.astrologerUser
                    .onboardYou}");
            print(
                "global.astrologerUser.suitableInterviewTime ===== ${global
                    .astrologerUser.suitableInterviewTime}");
            print(
                "global.astrologerUser.currentCity ===== ${global.astrologerUser
                    .currentCity}");
            print(
                "global.astrologerUser.mainSourceOfBusiness ===== ${global
                    .astrologerUser.mainSourceOfBusiness}");
            print(
                "global.astrologerUser.highestQualification ===== ${global
                    .astrologerUser.highestQualification}");
            print(
                "global.astrologerUser.degreeDiploma ===== ${global
                    .astrologerUser.degreeDiploma}");
            print(
                "global.astrologerUser.collegeSchoolUniversity ===== ${global
                    .astrologerUser.collegeSchoolUniversity}");
            print(
                "global.astrologerUser.learnAstrology ===== ${global
                    .astrologerUser.learnAstrology}");
            print(
                "global.astrologerUser.instagramProfileLink ===== ${global
                    .astrologerUser.instagramProfileLink}");
            print(
                "global.astrologerUser.facebookProfileLink ===== ${global
                    .astrologerUser.facebookProfileLink}");
            print(
                "global.astrologerUser.linkedInProfileLink ===== ${global
                    .astrologerUser.linkedInProfileLink}");
            print(
                "global.astrologerUser.youtubeProfileLink ===== ${global
                    .astrologerUser.youtubeProfileLink}");
            print(
                "global.astrologerUser.webSiteProfileLink ===== ${global
                    .astrologerUser.webSiteProfileLink}");
            print(
                "global.astrologerUser.isAnyBodyRefer ===== ${global
                    .astrologerUser.isAnyBodyRefer}");
            print(
                "global.astrologerUser.referedPersonName ===== ${global
                    .astrologerUser.referedPersonName}");
            print(
                "global.astrologerUser.expectedMinimumEarning ===== ${global
                    .astrologerUser.expectedMinimumEarning}");
            print(
                "global.astrologerUser.expectedMaximumEarning ===== ${global
                    .astrologerUser.expectedMaximumEarning}");
            print(
                "global.astrologerUser.longBio ===== ${global.astrologerUser
                    .longBio}");
            print(
                "global.astrologerUser.foreignCountryCount ===== ${global
                    .astrologerUser.foreignCountryCount}");
            print(
                "global.astrologerUser.currentlyWorkingJob ===== ${global
                    .astrologerUser.currentlyWorkingJob}");
            print(
                "global.astrologerUser.goodQualityOfAstrologer ===== ${global
                    .astrologerUser.goodQualityOfAstrologer}");
            print(
                "global.astrologerUser.biggestChallengeFaced ===== ${global
                    .astrologerUser.biggestChallengeFaced}");
            print(
                "global.astrologerUser.repeatedQuestion ===== ${global
                    .astrologerUser.repeatedQuestion}");
            print(
                "global.astrologerUser.astrologerCategoryId ===== ${global
                    .astrologerUser.astrologerCategoryId}");
            print(
                "global.astrologerUser.primarySkillId ===== ${global
                    .astrologerUser.primarySkillId}");
            print(
                "global.astrologerUser.allSkillId ===== ${global.astrologerUser
                    .allSkillId}");
            print(
                "global.astrologerUser.languageId ===== ${global.astrologerUser
                    .languageId}");

            for (var i = 0; i < astroId.length; i++) {
              global.astrologerUser.astrologerCategoryId!.addAll(astroId);
            }
            for (var i = 0; i < primaryId.length; i++) {
              global.astrologerUser.primarySkillId!.addAll(primaryId);
            }
            for (var i = 0; i < allId.length; i++) {
              global.astrologerUser.allSkillId!.addAll(allId);
            }
            for (var i = 0; i < lId.length; i++) {
              global.astrologerUser.languageId!.addAll(lId);
            }

            global.astrologerUser.week = [];

            for (var i = 0; i < week!.length; i++) {
              if (week![i].timeAvailabilityList!.isNotEmpty) {
                global.astrologerUser.week!.add(Week(
                    day: week![i].day,
                    timeAvailabilityList: week![i].timeAvailabilityList));
              }
            }
            global.astrologerUser.week!
                .removeWhere((element) => element.day == "");
            print(
                "User data being sent to week API: ${global.astrologerUser.week!
                    .length}");

            global.showOnlyLoaderDialog();
            await apiHelper.signUp(global.astrologerUser).then(
                  (apiRresult) async {
                global.hideLoader();
                if (apiRresult.status == '200') {
                  global.astrologerUser = apiRresult.recordList;


                  global.showToast(
                      message: "You Have Succesfully Register User");
                } else if (apiRresult.status == '400') {
                  global.showToast(message: apiRresult.message);
                  update();
                } else {
                  global.showToast(
                      message: "Somehing Went Wrong, ${apiRresult.message}");
                }
              },
            );
          } else {
            global.showToast(message: "No Network Available");
          }
        },
      );
    } catch (err) {
      global.showToast(
          message: "something went wrong, duplicate phone no used");
      global.printException("singup_controller.dart", "signupAstrologer", err);
    }
  }

//Check contact number exist or not
  checkContactExist(String phoneNumber, String countrycode) async {
    try {
      await global.checkBody().then(
            (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper.checkExistContactNumber(phoneNumber).then(
                  (result) {
                global.hideLoader();
                print("status code send otp${result.status}");
                if (result.status == "200") {
                  Get
                      .find<SignupOtpController>()
                      .second = 60;
                  update();

                  Get.find<SignupOtpController>().timer();
                  startHeadlesswithOtp(
                    phoneNumber,
                    countryCode, //Country cdoe
                  );
                } else {
                  global.hideLoader();
                  global.showToast(
                      message: "Contact Number is Already Register");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print("Exception - SignUpControoler.dart - checkContactExist(): " +
          e.toString());
    }
  }

//----------------------OTP sent-----------------------------------//
  RxBool isLoading = false.obs;
  dynamic smsCode = "";
  Timer? countDown;

  Map<String, dynamic>? dataResponse;

  String phoneOrEmail = '';
  String otp = '';
  bool isInitIos = false;
  final otplessFlutterPlugin = Otpless();

  void onHeadlessResult(dynamic result) async {
    log('signup-onHeadlessResult called');
    log('signup-onHeadlessResult Result: $result');
    dataResponse = result;

    if (result != null) {
      int statuscode = dataResponse!['statusCode'];
      log('signup-onHeadlessResult statuscode: $statuscode');

      if (statuscode == 200) {
        String mPhone = phoneNumber; //! error
        log('phone no in sighup controller is $mPhone');

        if (mPhone.isNotEmpty) {
          log('going to signupOTPScreen: $statuscode');
          Get.to(() =>
              SignupOtpScreen(
                mobileNumber: mPhone,
              ));
        } else {
          log('failed to send otp error is $result');
        }
      } else {
        log('failed to send otp');
      }
    } else {
      log('failed to send otp result is null');
    }
  }

  //! PHONE OTP
  Future<void> startHeadlesswithOtp(String phoneno, String countrycode) async {
    otplessFlutterPlugin.setHeadlessCallback(onHeadlessResult);

    log('signup start sending otp $phoneno  and $countrycode');
    if (Platform.isIOS && !isInitIos) {
      otplessFlutterPlugin.initHeadless(OtplessappId);
      otplessFlutterPlugin.setHeadlessCallback(onHeadlessResult);
      isInitIos = true;
      debugPrint("init headless sdk is called for ios");
      return;
    }
    Map<String, dynamic> arg = {};
    arg["phone"] = phoneno;
    arg["countryCode"] = countrycode;
    log('signup arg is $arg');
    otplessFlutterPlugin.startHeadless(onHeadlessResult, arg);
  }

//Astrologer profile
  ScrollController walletHistoryScrollController = ScrollController();
  ScrollController callHistoryScrollController = ScrollController();
  ScrollController chatHistoryScrollController = ScrollController();
  ScrollController reportHistoryScrollController = ScrollController();
  int fetchRecord = 10;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;

  @override
  onInit() {
    init();
    super.onInit();
  }

  init() async {
    paginateTask();
  }

  // Future<void> deleteAccount() async {
  //   try {
  //     await FirebaseAuth.instance.currentUser!.delete();
  //     print('Account deleted successfully.firebase too');
  //   } catch (e) {
  //     print('Error deleting account: $e');
  //   }
  // }

  void paginateTask() {
    walletHistoryScrollController.addListener(() async {
      if (walletHistoryScrollController.position.pixels ==
          walletHistoryScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await astrologerProfileById(true);
        update();
      }
    });
    chatHistoryScrollController.addListener(() async {
      if (chatHistoryScrollController.position.pixels ==
          chatHistoryScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await astrologerProfileById(true);
      }
    });
    callHistoryScrollController.addListener(() async {
      if (callHistoryScrollController.position.pixels ==
          callHistoryScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await astrologerProfileById(true);
      }
    });
    reportHistoryScrollController.addListener(() async {
      if (reportHistoryScrollController.position.pixels ==
          reportHistoryScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await astrologerProfileById(true);
      }
    });
  }

  Future astrologerProfileById(bool isLazyLoading) async {
    debugPrint('calling astrolgerprofile all');
    try {
      startIndex = 0;
      if (astrologerList.isNotEmpty) {
        startIndex = astrologerList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      global.checkBody().then(
            (result) {
          if (result) {
            global.showOnlyLoaderDialog();
            int id = global.user.id ?? 0;
            apiHelper
                .getAstrologerProfile(id, startIndex, fetchRecord)
                .then((result) {
              global.hideLoader();
              if (result.status == "200") {
                astrologerList.addAll(result.recordList);
                update();
                log("astrologerProfileById-> ${result.recordList}");
                print('List length is ${astrologerList.length} ');
                if (result.recordList.length == 0) {
                  isMoreDataAvailable = false;
                  isAllDataLoaded = true;
                }
                if (result.recordList.length < fetchRecord) {
                  isMoreDataAvailable = false;
                  isAllDataLoaded = true;
                }
              } else {
                global.showToast(message: result.message.toString());
              }
              update();
            });
          }
        },
      );
    } catch (e) {
      print('Exception: $screen - astrologerProfileById():-' + e.toString());
    }
  }

//Delete astrologer account
  deleteAstrologer(int id) async {
    try {
      await global.checkBody().then(
            (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper.astrologerDelete(id).then(
                  (result) async {
                global.hideLoader();
                if (result.status == "200") {
                  global.showToast(message: result.message.toString());
                  Get.back();
                } else {
                  global.showToast(message: result.message.toString());
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - rejectCallRequest(): ' + e.toString());
    }
  }

//Clear astrologer data
  clearAstrologer() {
    try {
      //Astrologer category
      for (var i = 0; i < global.astrologerCategoryModelList!.length; i++) {
        global.astrologerCategoryModelList![i].isCheck = false;
      }
      //Primary skill
      for (var i = 0; i < global.skillModelList!.length; i++) {
        global.skillModelList![i].isCheck = false;
      }
      //All skill
      for (var i = 0; i < global.allSkillModelList!.length; i++) {
        global.allSkillModelList![i].isCheck = false;
      }
      //Language
      for (var i = 0; i < global.languageModelList!.length; i++) {
        global.languageModelList![i].isCheck = false;
      }
    } catch (e) {
      print("Exception - $screen - clearAstrologer():" + e.toString());
    }
  }

//send reply
  Future sendReply(int id, String reply) async {
    try {
      await global.checkBody().then(
            (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper.astrologerReply(id, reply).then(
                  (result) {
                global.hideLoader();
                if (result.status == "200") {
                  cReply.text = '';
                  global.showToast(message: result.message.toString());
                  astrologerList.clear();
                  isAllDataLoaded = false;
                  update();
                  astrologerProfileById(false);
                } else {
                  global.showToast(message: "Review is not send");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - sendReply():-' + e.toString());
    }
  }

  List<CalltSession>? _callHistoryList;

  List<CalltSession>? get callHistoryList => _callHistoryList;

  Future<void> fetchUserCallRequest() async {
    global.showOnlyLoaderDialog(); // Show loader
    update();

    try {
      var headers = await global.getApiHeaders(true);
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://lab7.invoidea.in/goldenheart/api/get-astrologer-call-request?id=${global
                  .getCurrentUserId()}'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var jsonData = json.decode(responseBody);

        if (jsonData['recordList'] != null && jsonData['recordList'] is List) {
          _callHistoryList = (jsonData['recordList'] as List)
              .map((item) => CalltSession.fromJson(item))
              .toList();
        } else {
          _callHistoryList = []; // Ensure it's an empty list if null
        }

        print('Chat History Length: ${_callHistoryList!.length}');
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      global.hideLoader();
      update();
    }
  }

  Future<void> updateAstroSkill(List<int?> selectedSkills) async {
    var headers = await global.getApiHeaders(true);

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://lab7.invoidea.in/goldenheart/api/update-astro-skill'));

    // Convert the selectedSkills list to a comma-separated string
    String primarySkillStr = selectedSkills
        .whereType<int>()
        .join(","); // Filter null values and join

    // Adding fields to the request body
    request.fields.addAll({
      'primarySkill[]': primarySkillStr, // Sending the dynamic skill IDs
      'id': global.currentUserId.toString() // User ID
    });

    // Adding headers to the request
    request.headers.addAll(headers);

    // Sending the request
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      await getAstroSkill();
      global.showToast(message: "Update Successfully");

      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

// Future<void> updateAstroSkill({required List<int> primarySkillIds}) async {
//   // The primarySkillIds should already be a list of integers (skill IDs)
//   // so we don't need to map them to anything

//   global.astrologerUser.primarySkillId = List.from(primarySkillIds); // Just set the IDs directly

//   var headers = await global.getApiHeaders(true);

//   var request = http.MultipartRequest(
//     'POST',
//     Uri.parse('https://lab7.invoidea.in/goldenheart/api/update-astro-skill'),
//   );

//   // Add each skill ID as a separate field in the request
//   for (var skillId in primarySkillIds) {
//     request.fields['primarySkill[]'] = skillId.toString(); // Convert each ID to a string for the request
//   }

//   // Add the user ID to the request fields
//   request.fields['id'] = global.currentUserId.toString();

//   // Add headers to the request
//   request.headers.addAll(headers);

//   // Debug prints for better insight
//   print("🔹 User ID: ${global.currentUserId.toString()}");
//   print("🔹 API URL: ${request.url}");
//   print("🔹 Headers: $headers");
//   print("🔹 Fields: ${request.fields}");

//   // Print out the fields to check the content
//   request.fields.forEach((key, value) {
//     print("🔹 Field - $key: $value");
//   });

//   try {
//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       var responseData = await response.stream.bytesToString();
//       print("✅ Success: $responseData");
//     } else {
//       print("❌ Error: ${response.statusCode} - ${response.reasonPhrase}");
//     }
//   } catch (e) {
//     print("🚨 Exception: $e");
//   }
// }

// Future<void> getAstroSkill() async {
//   var url = Uri.parse('https://lab7.invoidea.in/goldenheart/api/get-astro-skill?id=11');

//   var headers = global.getApiHeaders(); // Fetch headers from global class

//   try {
//     var response = await http.post(url, headers: headers);

//     if (response.statusCode == 200) {
//       var responseData = jsonDecode(response.body);
//       print("API Response: $responseData");

//       astroSkills.clear(); // Clear previous data before updating

//       if (responseData is List) {
//         astroSkills.addAll(responseData.map((item) => AstroSkill.fromJson(item)));
//       } else if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
//         astroSkills.addAll((responseData['data'] as List)
//             .map((item) => AstroSkill.fromJson(item)));
//       }
//     } else {
//       print("Error: ${response.statusCode} - ${response.reasonPhrase}");
//     }
//   } catch (e) {
//     print("Exception in getAstroSkill(): $e");
//   }
// }

  List<AstroSkill>? _astroSkillList;

  List<AstroSkill>? get astroSkillList => _astroSkillList;

  Future<void> getAstroSkill() async {
    global.showOnlyLoaderDialog(); // Show loader
    update();

    try {
      // Fetch headers from global
      var headers = await global.getApiHeaders(true);
      print('Headers: $headers'); // Print headers for debugging

      // Prepare the POST request
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://lab7.invoidea.in/goldenheart/api/get-astro-skill?id=${global
                  .currentUserId.toString()}'));
      request.headers.addAll(headers);
      print('Request URL: ${request.url}'); // Print URL for debugging

      // Send the request and get the response
      http.StreamedResponse response = await request.send();

      print(
          'Response Status Code: ${response
              .statusCode}'); // Print response status code

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('Response Body: $responseBody'); // Print response body

        var jsonData = json.decode(responseBody);
        print('Decoded JSON Data: $jsonData'); // Print decoded JSON data

        if (jsonData['astrologerlist'] != null &&
            jsonData['astrologerlist'] is List) {
          _astroSkillList = (jsonData['astrologerlist'] as List)
              .map((item) => AstroSkill.fromJson(item))
              .toList();
          print(
              'AstroSkill List Length: ${_astroSkillList
                  ?.length}'); // Print the length of the list
        } else {
          _astroSkillList = []; // Ensure it's an empty list if null
          print(
              'AstroSkill List is empty or null'); // Debugging message if list is empty or null
        }

        print(
            'Chat getAstroSkill Length: ${_astroSkillList
                ?.length}'); // Print list length
      } else {
        print('Error: ${response.reasonPhrase}'); // Print error reason
      }
    } catch (e) {
      print('Exception: $e'); // Catch and print any exceptions
    } finally {
      global.hideLoader(); // Hide the loader after request completes
      update();
    }
  }


  Future<void> deleteStaff(String userId) async {
    LoadingDialog.showLoading();
    update();

    final url = Uri.parse('$baseUrl/delete-staff');

    var headers = {
      'Cookie': 'PHPSESSID=b7c3e63a18cb98e6aa9e4d332197a60f',
    };

    var request = http.MultipartRequest('POST', url);
    request.fields['user_id'] = userId;
    request.headers.addAll(headers);

    // DEBUG: Print request details
    print('⏳ Sending DELETE STAFF request...');
    print('🔗 URL: $url');
    print('📨 Headers: $headers');
    print('📤 Fields: ${request.fields}');

    try {
      http.StreamedResponse response = await request.send();

      // DEBUG: Print response status
      print('✅ Response Status Code: ${response.statusCode}');
      print('✅ Response Reason: ${response.reasonPhrase}');

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        // DEBUG: Print successful response body
        print('📦 Response Body: $responseBody');

        LoadingDialog.hideLoading();

        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        print('🧹 SharedPreferences cleared.');

        await Get.offAll(() => LoginScreen()); // Clears entire navigation stack

        print('➡️ Navigated to LoginScreen.');

        update();
      } else {
        print('❌ Failed: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('🛑 Exception: $e');
    } finally {
      LoadingDialog.hideLoading();
      update();
      print('🔚 Finished deleteStaff operation.');
    }
  }




}
