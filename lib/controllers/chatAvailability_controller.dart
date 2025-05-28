// ignore_for_file: avoid_print, file_names

import 'dart:convert';

import 'package:astrowaypartner/services/apiHelper.dart';
import 'package:astrowaypartner/widgets/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;

class ChatAvailabilityController extends GetxController {
  int? chatType = 1;

  APIHelper apiHelper = APIHelper();
  bool showAvailableTime = true;
  final waitTime = TextEditingController();
  TimeOfDay? timeOfDay2;
  TimeOfDay selectedWaitTime = TimeOfDay.now();
  // final cWaitTimeTime = TextEditingController();
  String? chatStatusName;

  void setChatAvailability(int? index, String? name) {
    chatType = index;
    chatStatusName = name;
    update();
  }


  selectWaitTime(BuildContext context) async {
    try {
      DateTime? selectedTime; // Declare selectedTime variable to store the selected time

      final DateTime currentTime = DateTime.now(); // Get the current time
      final DateTime maxSelectableTime = currentTime.add(const Duration(hours: 6)); // Maximum selectable time (6 hours ahead)

      await showCupertinoModalPopup(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
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
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss the picker if cancel is pressed
                        },
                      ),
                      CupertinoButton(
                        child: const Text("Done"),
                        onPressed: () {
                          if (selectedTime != null) {
                            // Format selected time as TimeOfDay for displaying in 12-hour format
                            final selectedTimeOfDay = TimeOfDay.fromDateTime(selectedTime!);

                            // Check if the selected time is in the past
                            if (selectedTime!.isBefore(currentTime)) {
                              print('Selected time is in the past.');
                            } else if (selectedTime!.isAfter(maxSelectableTime)) {
                              // If selected time is greater than maxSelectableTime
                              // Ensure the dialog doesn't close before showing the alert
                              showCustomSnackBar('You can select waiting time upto 6 hours from now');
                            } else {
                              // Valid selection
                              selectedWaitTime = selectedTimeOfDay;
                              timeOfDay2 = selectedTimeOfDay;
                              update();

                              // Update the text field with formatted time in 12-hour format
                              waitTime.text = selectedTimeOfDay.format(context);
                              print('Hour: ${timeOfDay2!.hour}');
                              print('Minute: ${timeOfDay2!.minute}');

                              Navigator.of(context).pop(); // Close the modal after valid selection
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  // CupertinoDatePicker for time only
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: DateTime(
                        currentTime.year,
                        currentTime.month,
                        currentTime.day,
                        selectedWaitTime.hour,
                        selectedWaitTime.minute,
                      ),
                      use24hFormat: false, // Set to true for 24-hour format for selection
                      onDateTimeChanged: (DateTime newTime) {
                        selectedTime = newTime; // Update the selected time when changed
                      },
                      minimumDate: currentTime, // Minimum selectable time (current time)
                      maximumDate: maxSelectableTime, // Maximum selectable time (6 hours ahead)
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(textAlign: TextAlign.center,
                        "You can add waiting time upto 6 hours only"),
                  ),
              ]
              ),

            ),
          );
        },
      );
    } catch (e) {
      print('Exception - selectWaitTime(): $e');
    }
  }






  // selectWaitTime(BuildContext context) async {
  //   try {
  //     final TimeOfDay? timeOfDay = await showTimePicker(
  //       context: context,
  //       initialTime: selectedWaitTime,
  //       initialEntryMode: TimePickerEntryMode.dial,
  //     );
  //     if (timeOfDay != null && timeOfDay != selectedWaitTime) {
  //       selectedWaitTime = timeOfDay;
  //       timeOfDay2 = timeOfDay;
  //       update();
  //       // ignore: use_build_context_synchronously
  //       waitTime.text = timeOfDay.format(context);
  //       print('check timeOfDay2');
  //       print(timeOfDay2!.minute);
  //       print(timeOfDay2!.hour);
  //     }
  //     update();
  //   } catch (e) {
  //     print('Exception  - $screen - selectWaitTime():$e');
  //   }
  // }

  statusChatChange({int? astroId, String? chatStatus, String? chatTime}) async {
    debugPrint('inside status chat $chatStatus');
    try {
      DateTime? date = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0);
      if (chatStatus == "Wait Time") {
        date = date.add(Duration(
          minutes: timeOfDay2!.minute,
          hours: timeOfDay2!.hour,
        ));
      }
      await global.checkBody().then(
        (result) async {
          if (result) {
            debugPrint('inside status chat addchat waitlist $chatStatus');

            await apiHelper
                .addChatWaitList(
                    astrologerId: astroId, status: chatStatus, datetime: date)
                .then(
              (result) async {
                debugPrint('inside status chat status ${result.status}');

                if (result.status == "200") {
                  global.user.chatStatus = chatStatus;
                  global.user.chatWaitTime = date;
                  await global.sp!.setString(
                      'currentUser', json.encode(global.user.toJson()));
                  debugPrint("Chat availability add successfully");
                  update();
                } else {
                  global.showToast(message: "Not available chat status");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - statusChatChange(): $e');
    }
  }
}
