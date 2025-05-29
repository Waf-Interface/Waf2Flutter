import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  void questionSnackbar({
    required String question,
    required String snackBarTitle,
    required String snackBarMessage,
    VoidCallback? onYes,
  }) {
    Get.snackbar(
      snackBarTitle,
      question,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.withOpacity(0.7),
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      mainButton: TextButton(
        onPressed: () {
          if (onYes != null) {
            onYes();
          }
          Get.back(); // Close the snackbar
        },
        child:  Text(
          'Yes'.tr,
          style: TextStyle(color: Colors.red),
        ),
      ),
      onTap: (_) => Get.back(), // Close on tap outside the button
    );
  }
}