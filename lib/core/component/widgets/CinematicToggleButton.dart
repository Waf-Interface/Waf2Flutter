import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class CinematicToggleButton extends StatelessWidget {
  const CinematicToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() => ElevatedButton(
      onPressed: () {
        themeController.toggleCinematicMode();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: themeController.isCinematic.value
            ? Colors.blue.withOpacity(0.7)
            : Colors.grey.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        themeController.isCinematic.value
            ? 'Disable Cinematic Mode'.tr
            : 'Enable Cinematic Mode'.tr,
        style: const TextStyle(color: Colors.white),
      ),
    ));
  }
}