import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDark = false.obs;
  var isCinematic = true.obs; // متغیر جدید برای تم سینمایی، پیش‌فرض true

  void toggle() {
    isDark.value = !isDark.value;
  }

  void toggleCinematicMode() {
    isCinematic.value = !isCinematic.value; // تغییر حالت تم سینمایی
  }
}