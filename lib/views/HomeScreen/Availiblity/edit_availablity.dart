import 'dart:convert';
import 'package:astrowaypartner/utils/config.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino package
import 'package:http/http.dart' as http;
import 'package:astrowaypartner/utils/global.dart' as global;

class WeekScheduleWidget extends StatefulWidget {
  const WeekScheduleWidget({Key? key, r}) : super(key: key);

  @override
  _WeekScheduleWidgetState createState() => _WeekScheduleWidgetState();
}

class _WeekScheduleWidgetState extends State<WeekScheduleWidget> {
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<Map<String, dynamic>> schedule = [];

  String? selectedDay;
  String? fromTime;
  String? toTime;

  final TextEditingController fromTimeController = TextEditingController();
  final TextEditingController toTimeController = TextEditingController();

  void addOrUpdateDaySchedule() {
    if (selectedDay == null || fromTime == null || toTime == null) {
      // Show Snackbar when day or time is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in timing details')),
      );
    } else {
      setState(() {
        final existingDayIndex =
            schedule.indexWhere((day) => day['day'] == selectedDay);

        if (existingDayIndex != -1) {
          (schedule[existingDayIndex]['time'] as List).add({
            "fromTime": fromTime,
            "toTime": toTime,
          });
          print('Already Added');
        } else {
          schedule.add({
            "day": selectedDay,
            "time": [
              {"fromTime": fromTime, "toTime": toTime},
            ],
          });
        }

        // Remove the selected day from the dropdown list to avoid duplication
        daysOfWeek.remove(selectedDay);

        // Clear selected values
        selectedDay = null;
        fromTime = null;
        toTime = null;
        fromTimeController.clear();
        toTimeController.clear();
      });
    }
  }

 Future<void> sendScheduleToApi() async {
  if (schedule.isEmpty) {
    // Show Snackbar if no schedule has been added
    print("No schedule provided. Please add at least one schedule.");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please add at least one schedule')),
    );
    return;
  }

  final url = '$baseUrl/astrologer/update-available-time';
  final Map<String, dynamic> requestBody = {
    "astrologerId": global.user.id,
    "astrologerAvailability": schedule,
  };

  // Debug prints: URL and Request Body
  print("Sending schedule to API...");
  print("URL: $url");
  print("Request Body: ${jsonEncode(requestBody)}");

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    // Debug prints: Response details
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("Response Data: $responseData");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Schedule updated successfully: ${responseData['message']}',
          ),
        ),
      );
    } else {
      final responseData = jsonDecode(response.body);
      print("Error Response Data: $responseData");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${responseData['message']}')),
      );
    }
  } catch (e, stackTrace) {
    // Print error and stack trace
    print("Error occurred: $e");
    print("Stack Trace: $stackTrace");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error occurred: $e')),
    );
  }
}


  Future<void> _selectTime(BuildContext context, String type) async {
    final TimeOfDay? selectedTime = await showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Select Time'),
          message: SizedBox(
            height: 216, // Adjusted height for the CupertinoTimePicker
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newTime) {
                String formattedTime = '${newTime.hour}:${newTime.minute}';
                if (type == 'from') {
                  setState(() {
                    fromTime = formattedTime;
                    fromTimeController.text = formattedTime;
                  });
                } else {
                  setState(() {
                    toTime = formattedTime;
                    toTimeController.text = formattedTime;
                  });
                }
              },
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Add Week Schedule',style: openSansMedium,),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: SingleChildScrollView(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor, // Set the background color here
            ),
            onPressed: sendScheduleToApi,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Add Day Schedule', style: openSansRegular.copyWith(color: Colors.white)),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedDay,
              items: daysOfWeek.map((day) {
                return DropdownMenuItem(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDay = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Select Day',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: fromTimeController,
                    decoration: const InputDecoration(
                      labelText: 'From Time',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () => _selectTime(context, 'from'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: toTimeController,
                    decoration: const InputDecoration(
                      labelText: 'To Time',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () => _selectTime(context, 'to'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor, // Set the background color here
              ),
              onPressed: addOrUpdateDaySchedule,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Add', style: openSansRegular.copyWith(color: Colors.white)),
              ),
            ),
            const Divider(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: schedule.length,
                itemBuilder: (context, index) {
                  final daySchedule = schedule[index];
                  final timeList = daySchedule['time'] as List<dynamic>;
                  return Card(
                    child: ListTile(
                      title: Text(daySchedule['day']),
                      subtitle: Text(
                        timeList
                            .map((time) =>
                                '${time['fromTime']} - ${time['toTime']}')
                            .join(', '),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            // Re-add the removed day back to the dropdown
                            daysOfWeek.add(daySchedule['day']);
                            schedule.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
