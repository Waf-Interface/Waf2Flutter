import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msf/core/utills/ColorConfig.dart';

ThemeData getTheme(bool isDark) {
  return isDark
      ? ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: Colors.blueAccent,
      secondary: Colors.yellowAccent,
      onSecondary: ColorConfig.secondryColor,
      tertiary: Colors.blueGrey,
      surface: Colors.blue,
    ),
    scaffoldBackgroundColor: ColorConfig.bgColorW,
    drawerTheme: const DrawerThemeData(
      backgroundColor: ColorConfig.bgDrawer,
    ),
    canvasColor: Colors.white,
    primaryColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.light().textTheme.apply(bodyColor: Colors.black)),
  )
      : ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Colors.blueAccent,
      secondary: Colors.yellowAccent,
      tertiary: Colors.blueGrey,
      onSecondary: ColorConfig.secondryColor,
      surface: Colors.blue,
    ),
    scaffoldBackgroundColor: ColorConfig.bgColor,
    drawerTheme: const DrawerThemeData(
      backgroundColor: ColorConfig.secondryColor,
    ),
    canvasColor: ColorConfig.secondryColor,
    primaryColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme.apply(bodyColor: Colors.white)),
  );
}