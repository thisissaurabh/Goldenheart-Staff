// ignore_for_file: must_be_immutable, unnecessary_null_comparison, avoid_print, prefer_typing_uninitialized_variables, deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';

import 'package:astrowaypartner/constants/colorConst.dart';
import 'package:astrowaypartner/controllers/Authentication/login_controller.dart';
import 'package:astrowaypartner/controllers/Authentication/signup_controller.dart';
import 'package:astrowaypartner/controllers/HistoryController/call_history_controller.dart';
import 'package:astrowaypartner/controllers/HomeController/chat_controller.dart';
import 'package:astrowaypartner/controllers/HomeController/edit_profile_controller.dart';
import 'package:astrowaypartner/controllers/HomeController/home_controller.dart';
import 'package:astrowaypartner/controllers/HomeController/live_astrologer_controller.dart';

import 'package:astrowaypartner/controllers/HomeController/wallet_controller.dart';
import 'package:astrowaypartner/controllers/following_controller.dart';

import 'package:astrowaypartner/controllers/networkController.dart';
import 'package:astrowaypartner/controllers/notification_controller.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/Wallet/Wallet_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/Drawer/drawer_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/Profile/edit_profile_screen.dart';

import 'package:astrowaypartner/views/HomeScreen/call/call_history_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/call/chat_history_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/call/video_call_screen.dart';
import 'package:astrowaypartner/views/HomeScreen/history/request_screen.dart';

import 'package:astrowaypartner/views/HomeScreen/notification_screen.dart';

import 'package:astrowaypartner/views/HomeScreen/tabs/callTab.dart';

import 'package:astrowaypartner/views/golderheart/call/call_accept_screen.dart';
import 'package:astrowaypartner/views/golderheart/profile_screen.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:astrowaypartner/widgets/custom_app_bar.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;
import 'package:sizer/sizer.dart';
import '../../controllers/splashController.dart';
import '../../services/apiHelper.dart';
import '../../utils/images.dart';

import '../../widgets/wallet_history_screen.dart';
import 'history/HistroryScreen.dart';

import 'tabs/chatTab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final chatController = Get.find<ChatController>();
  final callHistoryController = Get.find<CallHistoryController>();

  final signupController = Get.find<SignupController>();
  final walletController = Get.find<WalletController>();
  final followingController = Get.find<FollowingController>();
  final editProfileController = Get.put(EditProfileController());
  final liveAstrologerController = Get.find<LiveAstrologerController>();
  final notificationController = Get.find<NotificationController>();
  final networkController = Get.find<NetworkController>();
  final homeController = Get.find<HomeController>();
  final splashController = Get.find<SplashController>();



  final apiHelper = APIHelper();
  final snakeBarStyle = SnakeBarBehaviour.pinned;
  bool showSelectedLabels = true;
  bool showUnselectedLabels = true;
  Color selectedColor = Colors.grey.shade500;
  Color unselectedColor = Colors.blueGrey;
  int _selectedItemPosition = 0;
  int previousposition = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getwalletamountlist();
      // walletController.getAmountList();
      //global.warningDialog(context);
    });
    apiHelper.setAstrologerOnOffBusyline('Online');
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    print('User Type == >> ${UserSession.logintype}');
    return SafeArea(
      child: GetBuilder<HomeController>(builder: (homeController) {
        return WillPopScope(
          onWillPop: () async {
            bool isExit = false;
            if (homeController.isSelectedBottomIcon == 1) {
              isExit = await homeController.onBackPressed();
              if (isExit) exit(0);
            } else {
              homeController.isSelectedBottomIcon = 1;
              homeController.update();
            }
            return isExit;
          },
          child: Scaffold(
            body: Container(
              color: COLORS().greyBackgroundColor,
              child: homeController.isSelectedBottomIcon == 1
                  ? const RequestScreen()
                  : homeController.isSelectedBottomIcon == 2
                      ? const CallScreenHistory()
                      : homeController.isSelectedBottomIcon == 3 &&
                              UserSession.logintype == 1
                          ? const ChatScreenHistory()
                          : ProfileWidget(),
            ),
            drawer: DrawerScreen(),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedItemPosition,
              selectedItemColor: Get.theme.primaryColor,
              unselectedItemColor: Colors.black.withOpacity(0.5),
              onTap: (value) {
                setState(() {
                  _selectedItemPosition = value;
                  homeController.isSelectedBottomIcon =
                      UserSession.logintype == 1 ? value + 1 : value + 1;
                  homeController.update();
                });
              },
              items: UserSession.logintype == 1
                  ? [
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'Requests'),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.call), label: 'Calls History'),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.chat), label: 'Chat'),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.person), label: 'Profile'),
                    ]
                  : [
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'Requests'),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.call), label: 'Calls History'),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.person), label: 'Profile'),
                    ],
            ),
          ),
        );
      }),
    );
  }

  void getamountlist() async {
    await walletController.getAmountList();
  }

  void setLocale(Locale nLocale) {
    context.setLocale(nLocale);
    Get.updateLocale(nLocale);
  }

  void _handlevalue2(HomeController homeController) async {
    signupController.astrologerList.clear();
    await signupController.astrologerProfileById(true);
    homeController.isSelectedBottomIcon = 3;
    homeController.update();
  }

  void _handlevalue3(HomeController homeController) async {
    followingController.followerList.clear();
    await followingController.followingList(false);
    homeController.isSelectedBottomIcon = 4;
    homeController.update();
  }

  void showCuprtinoLiveDialog(HomeController homeController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Start Live Session').tr(),
          content: const Text('Do you want to start a live session?').tr(),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'Go Live',
                style: TextStyle(color: Colors.black),
              ).tr(),
              onPressed: () {
                //  "Go Live"
                liveAstrologerController.isImInLive = true;
                liveAstrologerController.update();
                homeController.isSelectedBottomIcon = 2;
                homeController.update();
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ).tr(),
              onPressed: () {
                setState(() {
                  _selectedItemPosition = previousposition;
                });
                // Navigator.of(context).pop();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  void alreadyLive(int position, HomeController homeController) {
    debugPrint('already live posi $position');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('You are Live').tr(),
          content: const Text('Do you want to Stop a live session?').tr(),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ).tr(),
              onPressed: () {
                homeController.isSelectedBottomIcon = position;
                homeController.update();
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ).tr(),
              onPressed: () {
                setState(() {
                  _selectedItemPosition = 1;
                  //! Fix position when No clicked while Live Live index is 1 i.e
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void getwalletamountlist() async {
    await walletController.getAmountList();
    walletController.update();
  }
}
