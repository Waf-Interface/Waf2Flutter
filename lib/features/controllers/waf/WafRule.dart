import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';

class WafRuleController extends GetxController {
  var rules = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedRuleContent = ''.obs;
  var searchQuery = "".obs;
  HttpService httpService = HttpService();
  @override
  void onInit() {
    fetchWafRules();
    super.onInit();
  }

  Future<void> fetchWafRules() async {
    isLoading.value = true;
    var fetchedRules = await httpService.fetchRulesStatus();
    rules.assignAll(List<Map<String, dynamic>>.from(fetchedRules));
    print(List<Map<String, dynamic>>.from(fetchedRules));
    isLoading.value = false;
  }

  Future<bool> addNewRule(String ruleName, String ruleBody) async {
    isLoading.value = true;
    bool success = await httpService.createNewRule(ruleName, ruleBody);
    if (success) {
      await fetchWafRules();
    }
    isLoading.value = false;
    return success;
  }

  Future<void> fetchRuleContent(String ruleName) async {
    isLoading.value = true;
    var content = await httpService.getRuleContent(ruleName);
    selectedRuleContent.value = content;
    isLoading.value = false;
  }

  Future<bool> updateRuleContent(String ruleName, String ruleBody) async {
    isLoading.value = true;
    bool success = await httpService.updateRule(ruleName, ruleBody);
    isLoading.value = false;
    return success;
  }

  Future<bool> toggleRule(String ruleName, String currentStatus) async {
    String newStatus = currentStatus == "enabled" ? "disable" : "enable";
    isLoading.value = true;
    bool success = await httpService.toggleRuleStatus(ruleName, newStatus);
    if (success) {
      await fetchWafRules();
    }
    isLoading.value = false;
    return success;
  }

  Future<void> downloadBackup() async {
    await httpService.backupRules();
  }

  Future<bool> restoreBackup() async {
    isLoading.value = true;
    bool success = await httpService.restoreBackupRules();
    if (success) {
      await fetchWafRules();
    }
    isLoading.value = false;
    return success;
  }

  Future<bool> deleteRule(String ruleName) async {
    isLoading.value = true;
    bool success = await httpService.deleteRule(ruleName);
    if (success) {
      await fetchWafRules();
    }
    isLoading.value = false;
    return success;
  }


}
