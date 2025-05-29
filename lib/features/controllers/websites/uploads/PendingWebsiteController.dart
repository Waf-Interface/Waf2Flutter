import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:msf/core/models/PendingWebsite.dart';
import 'package:msf/core/models/website.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import 'package:msf/features/controllers/websites/website/websiteController.dart';

class PendingWebsiteController extends GetxController {
  final RxList<PendingWebsite> pendingWebsites = <PendingWebsite>[].obs;
  final HttpService _httpService = HttpService();
  final WebsiteController websiteController = Get.find<WebsiteController>();

  void addPendingWebsite(String name, String url) {
    final pendingWebsite = PendingWebsite(name: name, url: url);
    pendingWebsites.add(pendingWebsite);
  }

  void removePendingWebsite(PendingWebsite website) {
    pendingWebsites.remove(website);
  }

  Future<void> uploadZipFile(PendingWebsite website, String applicationName) async {
    try {
      // Reuse logic from UploadController
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result == null) {
        Get.snackbar("No File Selected", "Please choose a zip file to upload.");
        return;
      }

      List<int> fileBytes = result.files.single.bytes!;
      String? filePath;
      if (kIsWeb) {
        filePath = null;
      } else {
        filePath = result.files.single.path;
      }

      website.deploymentStatus.value = 'Uploading...';
      final response = await _httpService.uploadFile(filePath, applicationName, fileBytes);

      if (response.statusCode == 200) {
        website.deploymentStatus.value = 'Ready to deploy!';
        Get.snackbar("Upload Successful", "Your file has been uploaded successfully!");
      } else {
        website.deploymentStatus.value = 'Upload failed';
        Get.snackbar("Upload Failed", "Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      website.deploymentStatus.value = 'Upload failed';
      Get.snackbar("Upload Failed", "Error: $e");
    }
  }

  Future<void> deployWebsite(PendingWebsite website) async {
    try {
      website.deploymentStatus.value = 'Deploying...';
      // Assuming deployFile returns a response indicating success
      final response = await _httpService.deployFile(website.name);

      if (response.statusCode == 200) {
        website.deploymentStatus.value = 'Deployed';
        Get.snackbar("Deployment Successful", "Website deployed successfully!");

        // Add to server-synced Website list
        websiteController.addWebsite(website.name, website.url, '');
        // Remove from pending list after successful deployment
        pendingWebsites.remove(website);
      } else {
        website.deploymentStatus.value = 'Deployment failed';
        Get.snackbar("Deployment Failed", "Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      website.deploymentStatus.value = 'Deployment failed';
      Get.snackbar("Deployment Failed", "Error: $e");
    }
  }
}