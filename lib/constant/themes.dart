import 'package:flutter/material.dart';

List<ThemeData> themeArray = [
  ThemeData(
    primaryColorDark: const Color.fromRGBO(0, 0, 0, 1),
    primaryColorLight: const Color.fromRGBO(255, 255, 255, 1),
    hintColor: const Color.fromRGBO(124, 125, 126, 1),
    colorScheme: ColorScheme.fromSwatch(
            accentColor: const Color.fromRGBO(255, 255, 255, 1),
            primarySwatch: mainOrangee,
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0))
        .copyWith(
      secondary: Colors.orange,
    ),
  ),
  ThemeData(
    primaryColorDark: const Color.fromRGBO(0, 0, 0, 1),
    primaryColorLight: const Color.fromRGBO(255, 255, 255, 1),
    hintColor: const Color.fromRGBO(124, 125, 126, 1),
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: orgainalGreen,
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0))
        .copyWith(
      secondary: Colors.greenAccent[500],
    ),
  ),
  ThemeData(
    primaryColorDark: const Color.fromRGBO(255, 255, 255, 1),
    primaryColorLight: const Color.fromARGB(244, 43, 42, 42),
    hintColor: const Color.fromARGB(255, 200, 200, 201),
    colorScheme: ColorScheme.fromSwatch(
      accentColor: const Color.fromRGBO(0, 0, 0, 0),
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
    ).copyWith(
      secondary: Colors.blue,
    ),
  ),
];

List<Color> colorList = [
  Colors.orange[800]!,
  Colors.green[800]!,
  Colors.grey.shade400
];

//to create MaterialColor
//http://mcg.mbitson.com/#!?mcgpalette0=%233f51b5

const MaterialColor mainOrangee =
    MaterialColor(_mcgpalette0PrimaryValue, <int, Color>{
  50: Color(0xFFFFEBE0),
  100: Color(0xFFFFCEB3),
  200: Color(0xFFFFAD80),
  300: Color(0xFFFF8C4D),
  400: Color(0xFFFF7326),
  500: Color(_mcgpalette0PrimaryValue),
  600: Color(0xFFFF5200),
  700: Color(0xFFFF4800),
  800: Color(0xFFFF3F00),
  900: Color(0xFFFF2E00),
});
const int _mcgpalette0PrimaryValue = 0xFFFF5A00;

const MaterialColor mcgpalette0Accent =
    MaterialColor(_mcgpalette0AccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_mcgpalette0AccentValue),
  400: Color(0xFFFFC7BF),
  700: Color(0xFFFFB1A6),
});
const int _mcgpalette0AccentValue = 0xFFFFF4F2;

const MaterialColor orgainalGreen =
    MaterialColor(_orgainagreenPrimaryValue, <int, Color>{
  50: Color(0xFFE9F6E3),
  100: Color(0xFFC8E8B9),
  200: Color(0xFFA3D98B),
  300: Color(0xFF7EC95C),
  400: Color(0xFF62BE39),
  500: Color(_orgainagreenPrimaryValue),
  600: Color(0xFF3FAB13),
  700: Color(0xFF37A210),
  800: Color(0xFF2F990C),
  900: Color(0xFF208A06),
});
const int _orgainagreenPrimaryValue = 0xFF46B216;

const MaterialColor orgainagreenAccent =
    MaterialColor(_orgainagreenAccentValue, <int, Color>{
  100: Color(0xFFC1FFB7),
  200: Color(_orgainagreenAccentValue),
  400: Color(0xFF6AFF51),
  700: Color(0xFF54FF37),
});
const int _orgainagreenAccentValue = 0xFF96FF84;

const MaterialColor mainDarkColor =
    MaterialColor(_mcgpalette1PrimaryValue, <int, Color>{
  50: Color(0xFFE3EAEB),
  100: Color(0xFFB8CACE),
  200: Color(0xFF89A7AE),
  300: Color(0xFF5A848D),
  400: Color(0xFF366974),
  500: Color(_mcgpalette1PrimaryValue),
  600: Color(0xFF114854),
  700: Color(0xFF0E3F4A),
  800: Color(0xFF0B3641),
  900: Color(0xFF062630),
});
const int _mcgpalette1PrimaryValue = 0xFF134F5C;

const MaterialColor mcgpalette1Accent =
    MaterialColor(_mcgpalette1AccentValue, <int, Color>{
  100: Color(0xFF6AD5FF),
  200: Color(_mcgpalette1AccentValue),
  400: Color(0xFF04B8FF),
  700: Color(0xFF00A7E9),
});
const int _mcgpalette1AccentValue = 0xFF37C6FF;
