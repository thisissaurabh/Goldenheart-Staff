// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:astrowaypartner/controllers/HomeController/call_controller.dart';
import 'package:astrowaypartner/controllers/HomeController/chat_controller.dart';

import 'package:astrowaypartner/controllers/HomeController/wallet_controller.dart';
import 'package:astrowaypartner/controllers/following_controller.dart';
import 'package:astrowaypartner/views/HomeScreen/home_screen.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../models/add_live_stream_model.dart';
import '../../models/language.dart';
import '../../services/apiHelper.dart';
import '../../utils/config.dart';


class HomeController extends GetxController with GetTickerProviderStateMixin {
  String screen = 'home_controller.dart';
  final chatController = Get.find<ChatController>();
  final callController = Get.find<CallController>();

  final walletController = Get.find<WalletController>();
  final followingController = Get.find<FollowingController>();
  int? notificationHandlingremoteUID = 0;


  XFile? _pickedLogo;
  XFile? get pickedLogo => _pickedLogo;

  void pickImage(bool isRemove) async {
    if(isRemove) {
      _pickedLogo = null;
    }else {
      _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
      update();
    }
  }

  List<Map<String, String>> dropdownOptions = [
    {"value": "1", "label": "Free Live Webinar"},
    {"value": "2", "label": "Free Live Vastu"},
    {"value": "3", "label": "Free Live Remedies"},
  ];

  getOnlineAstro(val) {
    notificationHandlingremoteUID = val;
    log('is online homecontroller check- $notificationHandlingremoteUID');
    update();
  }

  int selectedItemPosition = 0;
  int previousposition = 0;

  //Scroll  controller
  ScrollController chatScrollController = ScrollController();
  ScrollController callScrollController = ScrollController();
  ScrollController reportScrollController = ScrollController();
  ScrollController followingScrollController = ScrollController();
  int fetchRecord = 20;
  int startIndex = 0; //! WORK HERE
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isChatMoreDataAvailable = false;
  bool isCallMoreDataAvailable = false;
  bool isReportMoreDataAvailable = false;
  bool isFollowerMoreDataAvailable = false;
  TabController? historyTabController;
  TabController? tabController;

  List<Language> lan = [];
  APIHelper apiHelper = APIHelper();

  @override
  onInit() {
    init();
    historyTabController = TabController(length: 4, vsync: this);
    tabController = TabController(length: 3, vsync: this);

    super.onInit();
  }

  init() async {
    // await walletController.getAmountList();
    paginateTask();
  }

  void paginateTask() {
    chatScrollController.addListener(() async {
      if (chatScrollController.position.pixels ==
              chatScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isChatMoreDataAvailable = true;
        print('scroll my following');
        update();
        await chatController.getChatList(true);
      }
    });
    callScrollController.addListener(() async {
      if (callScrollController.position.pixels ==
              callScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isCallMoreDataAvailable = true;
        print('scroll my following');
        update();
        await callController.getCallList(true);
      }
    });
    reportScrollController.addListener(() async {
      if (reportScrollController.position.pixels ==
              reportScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isReportMoreDataAvailable = true;
        print('scroll my following');
        update();
        await callController.getCallList(true);
      }
    });
    followingScrollController.addListener(() async {
      if (followingScrollController.position.pixels ==
              followingScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isFollowerMoreDataAvailable = true;
        print('scroll my following');
        update();
        await followingController.followingList(true);
      }
    });
  }

//Home Tabs
  int homeTabIndex = 0.obs();

//Histroey Tabs
  int historyCurrentIndex = 0;
  int historyTabIndex = 0.obs();

  onHistoryTabBarIndexChanged(value) {
    historyTabIndex = value;
    update();
  }

  String _liveStreamCategory = "";

  String get liveStreamCategory => _liveStreamCategory;

  void setLiveStreamCategoryId(String orderId) {
    _liveStreamCategory = orderId;
    update();
  }



  int? currentPage;
  int totalPage = 3;


  int isSelectedBottomIcon = 1.obs();
  bool isSelected = false;

  DateTime? currentBackPressTime;

  Future<bool> onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      global.showToast(message: "Press again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  int selectedIndex = 0;
  void onItemTapped(int index) {
    selectedIndex = index;
    update(); // Notify UI
  }
  updateLan(int index) {
    selectedIndex = index;
    lan[index].isSelected = true;
    update();
    for (int i = 0; i < lan.length; i++) {
      if (i == index) {
        continue;
      } else {
        lan[i].isSelected = false;
        update();
      }
    }
    update();
  }

  updateLanIndex() async {
    global.spLanguage = await SharedPreferences.getInstance();
    var currentLan = global.spLanguage!.getString('currentLanguage') ?? 'en';
    for (int i = 0; i < lan.length; i++) {
      if (lan[i].lanCode == currentLan) {
        selectedIndex = i;
        lan[i].isSelected = true;
        update();
      } else {
        lan[i].isSelected = false;
        update();
      }
    }
    print(selectedIndex);
  }

  getLanguages() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          lan.clear();
          lan.addAll(staticLanguageList);
          update();
        }
      });
    } catch (e) {
      print("Exception in addFeedback():- $e");
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<dynamic> addLiveStreamVideo(
      String? youtubeLink,
      String? videoTitle,
      String? astrologerId,
      String? categoryId,
      XFile? image) async {
    _isLoading = true;
    update();

    String? savedVideoId;
    String? savedVideoTitle;

    try {
      final uri = Uri.parse('${appParameters[appMode]['apiUrl']}addLiveVideoApi');
      print('API URL: $uri');
      final headers = await global.getApiHeaders(false);
      print('Request Headers: $headers');

      // Prepare Multipart Request
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);

      // Add fields to the request
      request.fields['youtubeLink'] = youtubeLink ?? '';
      request.fields['videoTitle'] = videoTitle ?? '';
      request.fields['astrologer_id'] = astrologerId ?? '';
      request.fields['category_id'] = categoryId ?? '';
      request.fields['sort_order'] = '1';

      if (image != null) {
        final imageFile = await http.MultipartFile.fromPath('coverImage', image.path);
        request.files.add(imageFile);
      }

      // Send the request
      final response = await request.send();
      print('Response Status Code: ${response.statusCode}');

      final responseBody = await response.stream.bytesToString();
      print('Response Body: $responseBody');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);
        final recordList = jsonResponse['recordList'];

        // Save id and videoTitle in variables
        savedVideoId = recordList['id'].toString();
        savedVideoTitle = recordList['videoTitle'];

        print('Saved Video ID: $savedVideoId');
        print('Saved Video Title: $savedVideoTitle');
        // Get.to(() => YouTubeLiveStream(videoId: '$savedVideoId',));

        // Navigate to the live stream player
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception in addLiveStreamVideo: $e');
    } finally {
      _isLoading = false;
      update();
    }

    return {'id': savedVideoId, 'videoTitle': savedVideoTitle}; // Return saved values if needed
  }

  Future<dynamic> endLiveStream(
      String? videoId,
     ) async {
    _isLoading = true;
    update();
    try {
      final uri = Uri.parse('${appParameters[appMode]['apiUrl']}end-live-video');
      print('API endLiveStream URL: $uri');
      final headers = await global.getApiHeaders(false); // No JSON content-type for multipart
      print('Request endLiveStream Headers: $headers');
      final request = http.MultipartRequest('POST', uri);
      request.fields['id'] = videoId ?? '';
      final response = await request.send();
      print('Response endLiveStream Status Code: ${response.statusCode}');

      final responseBody = await response.stream.bytesToString();
      print('Response endLiveStream  Body: $responseBody');

      if (response.statusCode == 200) {
        Get.to(() => const HomeScreen());
      } else {
        print('Error endLiveStream: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception in endLiveStream $e');
    } finally {
      _isLoading = false;
      update();
    }


  }




  Future<String?> pickFiles() async {
    // Define the allowed file extensions
    List<String> allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];

    // Prompt the user to pick files
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: allowedExtensions,
    // );

    // try {
    //   if (result != null) {
    //     List<File> files = result.paths.map((path) => File(path!)).toList();
    //     log('file is ${files[0].path}');
    //     return files[0].path;
    //   } else {
    //     log('selecting file error');
    //     return '';
    //   }
    // } on Exception catch (e) {
    //   log('file error $e');
    //   return '';
    // }
  }

}
