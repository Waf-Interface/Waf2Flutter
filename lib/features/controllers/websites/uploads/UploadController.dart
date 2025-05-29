import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/models/website.dart';
import 'package:msf/features/controllers/websites/website/websiteController.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';

class UploadController extends GetxController {
  final RxString statusMessage = ''.obs;
  final HttpService _httpService = HttpService();
  var isUploading = false.obs;

  Future<void> uploadZipFile({
    required String applicationName,
    required Website website,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result != null) {
      List<int> fileBytes = result.files.single.bytes!;
      String? filePath;
      if (!kIsWeb) {
        filePath = result.files.single.path;
      }

      try {
        isUploading.value = true;
        final response = await _httpService.uploadFile(filePath, applicationName, fileBytes);
        if (response.statusCode == 200) {
          statusMessage.value = 'Upload successful!';
          website.status.value = 'Uploaded';

          Get.snackbar(
            "Upload Successful",
            "Your file has been uploaded successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.7),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          await Future.delayed(Duration(milliseconds: 268));
          website.status.value = 'Ready to deploy!';
          Get.snackbar(
            "Deployment Ready",
            "Your application is ready to deploy.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue.withOpacity(0.7),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        } else {
          statusMessage.value = 'Upload failed: ${response.statusCode}';
          String errorMessage = 'An error occurred during the upload.';

          try {
            final errorResponse = jsonDecode(response.body);
            errorMessage = errorResponse['error'] ?? 'Unknown error';
          } catch (e) {
            print('Error parsing server response: $e');
          }

          Get.snackbar(
            "Upload Failed",
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } catch (error) {
        String errorMessage = 'An error occurred during the upload.';
        if (error is SocketException) {
          errorMessage = 'Network error: Please check your internet connection.';
        } else if (error is TimeoutException) {
          errorMessage = 'Server timeout: Please try again later.';
        }

        statusMessage.value = 'Upload failed: $errorMessage';
        print('Error occurred: $error');

        Get.snackbar(
          "Upload Failed",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } finally {
        isUploading.value = false;
      }
    } else {
      statusMessage.value = 'No file selected.';
      Get.snackbar(
        "No File Selected",
        "Please choose a zip file to upload.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void cancelUpload() {
    statusMessage.value = 'Upload canceled.';
    Get.back();
  }

}