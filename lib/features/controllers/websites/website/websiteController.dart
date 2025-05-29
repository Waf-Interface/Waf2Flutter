import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/models/website.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';

class WebsiteController extends GetxController {
  final RxList<Website> websites = <Website>[].obs;
  final HttpService _httpService = HttpService();

  @override
  void onInit() {
    super.onInit();
    fetchWebsites();
  }

  void addWebsite(String name, String url, String zipPath) {
    websites.add(
        Website(
          name: name,
          url: url,
          author: "admin",
          status: ''.obs,
          addWebsiteStatus: 'Waiting for zip',
          initStatus: false,
          zipPath: zipPath,
        ));
  }

  void updateStatus(Website website, String newStatus) {
    website.addWebsiteStatus = newStatus;
  }

  void updateApiStatus(Website website, String newStatus) {
    website.status.value = newStatus;
  }

  void removeWebsite(Website website) {
    websites.remove(website);
  }

  Future<void> deployWebsite(Website website) async {
    try {
      String fileNameWithExtension = '${website.name}.zip';

      final response = await _httpService.deployFile(fileNameWithExtension);
      if (response.statusCode == 200) {
        website.addWebsiteStatus = 'Deployed';
        website.status.value = 'Deployed';
        Get.snackbar(
          "Deployment Successful",
          "Your website has been deployed successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          "Error",
          "Deployment failed. Please try again later.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred during the deployment: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> fetchWebsites() async {
    try {
      final websiteList = await _httpService.listWebsites();
      websites.assignAll(websiteList as List<Website>);
    } catch (e) {
      //   Get.snackbar(
      //     "Error",
      //     "Failed to fetch websites: $e",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red.withOpacity(0.7),
      //     colorText: Colors.white,
      //     duration: const Duration(seconds: 3),
      //   );
      // }
    }
  }

  Future<void> deleteWebsite(Website website) async {
    try {
      if (website.id == null) {
        throw Exception('Website ID is null');
      }
      await _httpService.deleteWebsite(website.id!);
      removeWebsite(website);
      Get.snackbar(
        "Website Deleted",
        "Website ${website.name} has been deleted",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete website: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}