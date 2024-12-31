import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  void questionSnackbar(
          {required String question,
          required String snackBarTitle,
          required String snackBarMessage}) =>
      Get.dialog(
        AlertDialog(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actionsAlignment: MainAxisAlignment.center,
          title: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white10,
                  ),
                ),
                child: Icon(
                  Icons.question_mark,
                  color: Colors.white60,
                  size: 50,
                ),
              ),
            ],
          ),
          content: Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();

                snackbarMaker(
                    'Canceled'.tr, 'You have canceled the action.'.tr);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                snackbarMaker(snackBarTitle, snackBarMessage);
              },
              child: Text(
                'Confirm',
                style: TextStyle(color: Get.theme.primaryColor),
              ),
            ),
          ],
        ),
      );

  void snackbarMaker(String title, String message) => Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        maxWidth: 450,
        margin: const EdgeInsets.all(10),
        colorText: Colors.white,
        duration: const Duration(seconds: 1000),
        isDismissible: false,
        mainButton: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('YES'.tr),
        ),
      );
}