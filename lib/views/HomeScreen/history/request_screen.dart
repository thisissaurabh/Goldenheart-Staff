import 'package:astrowaypartner/controllers/Authentication/login_controller.dart';
import 'package:astrowaypartner/utils/textstyles.dart';
import 'package:astrowaypartner/views/HomeScreen/tabs/callTab.dart';
import 'package:astrowaypartner/views/HomeScreen/tabs/chatTab.dart';
import 'package:astrowaypartner/views/HomeScreen/tabs/videoTab.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomApp(
        title: "Request",
        isHideWallet: true,
      ),
      body: Column(
        children: [
          // Top Button Row
          UserSession.logintype == 1
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserSession.logintype == 1
                          ? _buildTabButton("Chat", 0)
                          : const SizedBox(),
                      // _buildTabButton("Chat" , 0),
                      const SizedBox(width: 10),
                      _buildTabButton(
                          UserSession.logintype == 1
                              ? "Call"
                              : "Video & Audio Call",
                          1),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTherapistTabButton("Video & Audio Call"),
                      // _buildTabButton(UserSession.logintype == 1 ?   "Call" : "Voice & Audio Call", 1),
                    ],
                  ),
                ),

          // PageView

          Expanded(
              child: UserSession.logintype == 1
                  ? PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      children: [
                        UserSession.logintype == 1
                            ? const ChatTab()
                            : const SizedBox(),
                        // const ChatTab(),
                        const CallTab()
                      ],
                    )
                  : const CallTab()),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return ElevatedButton(
      onPressed: () => _onTabSelected(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedIndex == index ? Colors.black : Colors.white,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      child: Text(
        text,
        style: openSansRegular.copyWith(
          color: _selectedIndex == index ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildTherapistTabButton(
    String text,
  ) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      child: Text(
        text,
        style: openSansRegular.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPageItem(String title, Color color) {
    return Center(
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
