import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class ColorConfig {
  static final ThemeController _themeController = Get.find<ThemeController>();

  static const Color bgColor = Color.fromARGB(255, 31, 30, 45);
  static const Color secondryColor = Color(0xFF2A2D3E);
  static const Color primaryColor = Color(0xFF2697FF);
  static const Color bgDrawer = Color.fromARGB(255, 39, 46, 62);
  static const Color bgColorW = Color.fromARGB(255, 187, 185, 185);

  // رنگ شیشه‌ای برای افکت Glassmorphism
  static Color get glassColor {
    return _themeController.isDark.value
        ? Colors.white.withOpacity(0.09) // border گلس
        : Colors.white.withOpacity(0.05); //خوده container
  }
}