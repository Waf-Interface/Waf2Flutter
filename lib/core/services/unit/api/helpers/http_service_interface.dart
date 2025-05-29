import 'package:http/http.dart' as http;
import 'package:msf/core/models/website.dart';

abstract class HttpService {
  String? get sessionId;
  set sessionId(String? value);
  String? get accessToken;
  set accessToken(String? value);

  Future<void> login(String username, String password);
  Future<bool> verifyOtp(int otp);
  Future<List<Map<String, dynamic>>> fetchNginxLogs();
  Future<bool> clearAuditLogs();
  Future<Map<String, dynamic>> fetchNginxLogSummary();
  Future<Map<String, dynamic>> fetchDailyTraffic();

  Future<http.Response> uploadFile(String? filePath, String applicationName, List<int> fileBytes);
  Future<http.Response> deployFile(String fileName);
  Future<http.Response> getAppList();
  Future<dynamic> getNetworkInterfaces();
  Future<dynamic> getNetworkRoutes();
  Future<Map<String, dynamic>> addGateway(String interfaceName);

  Future<List<Map<String, dynamic>>> fetchAppLogs();
  Future<List<Map<String, dynamic>>> fetchLoginLogs();
  Future<List<dynamic>> fetchWafLogs();
  Future<bool> updateConfigFile(String fileKey, String newContents);
  Future<List<dynamic>> getUsers();

  Future<Map<String, dynamic>> createUser({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String rule,
  });
  Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String rule,
  });
  Future<void> deleteUser(int userId);

  Future<List<Map<String, dynamic>>> getActiveUsers();
  Future<void> deleteActiveUser(int accessId);
  Future<Map<String, dynamic>> checkUpdateStatus();
  Future<Map<String, dynamic>> updateCrs();
  Future<bool> deleteRule(String ruleName);
  Future<bool> setSecRuleEngine(String value);
  Future<bool> setSecResponseBodyAccess(bool value);
  Future<String?> getSecAuditLog();
  Future<bool> restoreBackupRules();
  Future<void> backupRules();
  Future<bool> logUserAccess(String username);
  Future<bool> toggleModSecurity(String power);
  Future<bool> checkModSecurityStatus();
  Future<List<String>> fetchRules();
  Future<bool> createNewRule(String ruleName, String ruleBody);
  Future<String> getRuleContent(String ruleName);
  Future<bool> updateRule(String ruleName, String ruleBody);
  Future<List<dynamic>> fetchRulesStatus();
  Future<bool> toggleRuleStatus(String ruleName, String newStatus);
  Future<bool> authenticateWaf(String username, String password);

  Future<String?> getConfigFile(String fileKey);
  Future<bool> restoreConfigFile(String fileKey);
  Future<bool> restoreAllConfigFiles();

  Future<Map<String, dynamic>> addVirtualIp({
    required String ipAddress,
    required String netmask,
    required String interface,
  });
  Future<List<dynamic>> listVirtualIps();
  Future<Map<String, dynamic>> deleteVirtualIp(int vipId);
  Future<Map<String, dynamic>> releaseVirtualIp(int vipId);

  Future<List<Website>> listWebsites();
  Future<Website> getWebsite(String websiteId);
  Future<Website> updateWebsiteStatus(String websiteId, String status);
  Future<Website> getWebsiteByName(String name);
  Future<void> deleteWebsite(String websiteId);

  Future<Map<String, dynamic>> createWebsiteRule(String websiteId, String ruleName, String ruleContent);
  Future<Map<String, dynamic>> updateWebsiteRule(String websiteId, String ruleName, String ruleContent);
  Future<bool> deleteWebsiteRule(String websiteId, String ruleName);
  Future<bool> disableWebsiteRule(String websiteId, String ruleName);
  Future<bool> enableWebsiteRule(String websiteId, String ruleName);
  Future<List<dynamic>> getWebsiteRules(String websiteId);
  Future<Map<String, dynamic>> createWebsiteBackup(String websiteId, String backupName);
  Future<bool> restoreWebsiteBackup(String websiteId, String backupName);
  Future<String> getWebsiteNginxConfig(String websiteId);
  Future<bool> updateWebsiteNginxConfig(String websiteId, String config);
  Future<String> getWebsiteModsecMainConfig(String websiteId);
  Future<String> getWebsiteAuditLog(String websiteId);
  Future<String> getWebsiteDebugLog(String websiteId);
  Future<bool> resetWebsiteAuditLog(String websiteId);
  Future<bool> resetWebsiteDebugLog(String websiteId);
}