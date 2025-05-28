
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Map<int, Color> color = {
  50: const Color.fromRGBO(198, 29, 36, .1),
  100: const Color.fromRGBO(198, 29, 36, .2),
  200: const Color.fromRGBO(198, 29, 36, .3),
  300: const Color.fromRGBO(198, 29, 36, .4),
  400: const Color.fromRGBO(198, 29, 36, .5),
  500: const Color.fromRGBO(198, 29, 36, .6),
  600: const Color.fromRGBO(198, 29, 36, .7),
  700: const Color.fromRGBO(198, 29, 36, .8),
  800: const Color.fromRGBO(198, 29, 36, .9),
  900: const Color.fromRGBO(198, 29, 36, 1),
};



ThemeData nativeTheme() {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    fontFamily: 'FuturaCyrillic',
    dividerColor: Colors.black,
    disabledColor: Colors.black.withOpacity(0.50),
    hoverColor: const Color(0xff4D2A7C),
    primaryColor: const Color(0xffBB9847),
    cardColor: Colors.white,
    scaffoldBackgroundColor:  Colors.white,
    primaryColorDark: const Color(0xffD28D0C),
    hintColor: Colors.black.withOpacity(0.60),
    highlightColor: const Color(0xffFCCD0A),
 
    iconTheme: const IconThemeData(color: Colors.black),
    primaryIconTheme: const IconThemeData(color: Colors.black),
    textTheme: const TextTheme(
    
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black),
      displaySmall: TextStyle(color: Colors.black),
      headlineMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    primaryTextTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black),
      displaySmall: TextStyle(color: Colors.black),
      headlineMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
    ),

  
 
  );
}
const Color colorAppbar = Color(0xffF7F3E9);
const Color primaryYellow = Color(0xffBB9847);
const Color primaryColor = Color(0xffBB9847);
const Color redColor = Color(0xffDB292C);
const Color primaryGreenColor = Color(0xff0e971c);
const Color lightPrimary = Color(0xffFDF9D5);
const Color blackBgPrimary = Color(0xff212121);
const Color primaryPinkColor = Color(0xffFFB19c);
const Color primaryBrownColor = Color(0xffBD7A2C);
const Color primaryRedColor = Color(0xffDB292C);
const Color yellowColor = Color(0xffD28D0c);
const Color primaryOrangeColor = Color(0xffD2410C);
const Color whiteBgColor = Color(0xffF7F3E9);
 Color colorWalletBg = Color(0xffCB8B58).withOpacity(.30);
