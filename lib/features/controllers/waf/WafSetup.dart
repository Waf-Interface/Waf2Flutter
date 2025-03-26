import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';

class WafSetupController extends GetxController {

  late HttpService _httpService;
  void setHttpService(HttpService service) {
    _httpService = service;
  }


  var isLoading = false.obs;
  var secAuditLog = ''.obs;
  var configFileContents = <String, String>{}.obs;
  var restoreStatus = <String, bool>{}.obs;
  var allFilesRestored = false.obs;


  /// [value] should be "On", "Off", or "DetectionOnly".
  Future<bool> setSecRuleEngine(String value) async {
    isLoading.value = true;
    bool result = await _httpService.setSecRuleEngine(value);
    isLoading.value = false;
    return result;
  }

  /// [value] is a boolean that will be translated to "On" or "Off" on the backend.
  Future<bool> setSecResponseBodyAccess(bool value) async {
    isLoading.value = true;
    bool result = await _httpService.setSecResponseBodyAccess(value);
    isLoading.value = false;
    return result;
  }

  Future<void> fetchSecAuditLog() async {
    isLoading.value = true;
    String? log = await _httpService.getSecAuditLog();
    if (log != null) {
      secAuditLog.value = log;
    } else {
      secAuditLog.value = 'No audit log available';
    }
    isLoading.value = false;
  }

  Future<void> fetchConfigFile(String fileKey) async {
    isLoading.value = true;
    String? contents = await _httpService.getConfigFile(fileKey);
    if (contents != null) {
      configFileContents[fileKey] = contents;
    } else {
      configFileContents[fileKey] = 'Failed to load $fileKey contents';
    }
    isLoading.value = false;
  }

  Future<bool> restoreConfigFile(String fileKey) async {
    isLoading.value = true;
    bool success = await _httpService.restoreConfigFile(fileKey);
    restoreStatus[fileKey] = success;
    isLoading.value = false;
    return success;
  }

  Future<bool> restoreAllConfigFiles() async {
    isLoading.value = true;
    bool success = await _httpService.restoreAllConfigFiles();
    allFilesRestored.value = success;
    if (success) {
      restoreStatus.clear();
    }
    isLoading.value = false;
    return success;
  }

  Future<bool> updateConfigFile(String fileKey, String newContents) async {
    isLoading.value = true;
    bool success = await _httpService.updateConfigFile(fileKey, newContents);
    if (success) {
      configFileContents[fileKey] = newContents;
    }
    isLoading.value = false;
    return success;
  }
}