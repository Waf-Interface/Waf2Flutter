import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';

class WafWebsiteController extends GetxController {
  final HttpService _httpService = HttpService();
  final RxList<Map<String, dynamic>> rules = <Map<String, dynamic>>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedRuleContent = ''.obs;

  Future<void> fetchRules(String websiteId) async {
    try {
      isLoading.value = true;
      final rulesList = await _httpService.getWebsiteRules(websiteId);
      rules.assignAll(rulesList.map((rule) => Map<String, dynamic>.from(rule)));
      print("-----------======================------------");
      print(rulesList);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch rules: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRuleContent(String websiteId, String ruleName) async {
    try {
      isLoading.value = true;
      final rule = rules.firstWhere((r) => r['name'] == ruleName, orElse: () => {});
      selectedRuleContent.value = rule['content'] ?? '';
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch rule content: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createRule(String websiteId, String ruleName, String ruleContent) async {
    try {
      isLoading.value = true;
      await _httpService.createWebsiteRule(websiteId, ruleName, ruleContent);
      await fetchRules(websiteId);
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to create rule: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateRuleContent(String websiteId, String ruleName, String newContent) async {
    try {
      isLoading.value = true;
      await _httpService.updateWebsiteRule(websiteId, ruleName, newContent);
      await fetchRules(websiteId);
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update rule: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> toggleRule(String websiteId, String ruleName, String currentStatus) async {
    try {
      isLoading.value = true;
      final newStatus = currentStatus == 'active' ? 'disabled' : 'active';
      if (newStatus == 'disabled') {
        await _httpService.disableWebsiteRule(websiteId, ruleName);
      } else {
        await _httpService.enableWebsiteRule(websiteId, ruleName);
      }
      await fetchRules(websiteId);
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to toggle rule: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteRule(String websiteId, String ruleName) async {
    try {
      isLoading.value = true;
      await _httpService.deleteWebsiteRule(websiteId, ruleName);
      await fetchRules(websiteId);
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete rule: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createBackup(String websiteId, String backupName) async {
    try {
      isLoading.value = true;
      await _httpService.createWebsiteBackup(websiteId, backupName);
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to create backup: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> restoreBackup(String websiteId, String backupName) async {
    try {
      isLoading.value = true;
      await _httpService.restoreWebsiteBackup(websiteId, backupName);
      await fetchRules(websiteId);
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to restore backup: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getNginxConfig(String websiteId) async {
    try {
      isLoading.value = true;
      return await _httpService.getWebsiteNginxConfig(websiteId);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch nginx config: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return '';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateNginxConfig(String websiteId, String config) async {
    try {
      isLoading.value = true;
      await _httpService.updateWebsiteNginxConfig(websiteId, config);
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update nginx config: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getModsecMainConfig(String websiteId) async {
    try {
      isLoading.value = true;
      return await _httpService.getWebsiteModsecMainConfig(websiteId);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch modsec main config: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return '';
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getAuditLog(String websiteId) async {
    try {
      isLoading.value = true;
      return await _httpService.getWebsiteAuditLog(websiteId);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch audit log: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return '';
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getDebugLog(String websiteId) async {
    try {
      isLoading.value = true;
      return await _httpService.getWebsiteDebugLog(websiteId);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch debug log: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return '';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resetAuditLog(String websiteId) async {
    try {
      isLoading.value = true;
      await _httpService.resetWebsiteAuditLog(websiteId);
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to reset audit log: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resetDebugLog(String websiteId) async {
    try {
      isLoading.value = true;
      await _httpService.resetWebsiteDebugLog(websiteId);
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to reset debug log: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}