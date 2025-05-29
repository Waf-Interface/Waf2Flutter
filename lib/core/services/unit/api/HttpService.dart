import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:msf/core/models/website.dart';
import 'package:msf/core/services/unit/api/http/app/app_http_service.dart';
import 'package:msf/core/services/unit/api/http/auth/auth_http_service.dart';
import 'package:msf/core/services/unit/api/http/interface/interface_http_service.dart';
import 'package:msf/core/services/unit/api/http/log/log_http_service.dart';
import 'package:msf/core/services/unit/api/http/update/update_http_service.dart';
import 'package:msf/core/services/unit/api/http/user/user_http_service.dart';
import 'package:msf/core/services/unit/api/http/waf/waf_http_service.dart';
import 'package:msf/core/services/unit/api/http/waf/waf_website_http_service.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;

  final _authService = AuthHttpService();
  final _appService = AppHttpService();
  final _logService = LogHttpService();
  final _userService = UserHttpService();
  final _wafService = WafHttpService();
  final _updateService = UpdateHttpService();
  final _interfaceService = InterfaceHttpService();
  final _wafWebsitesService = WafWebsitesHttpService();

  HttpService._internal() {
    HttpOverrides.global = MyHttpOverrides();
    _authService.setHttpService(this);
    _appService.setHttpService(this);
    _logService.setHttpService(this);
    _userService.setHttpService(this);
    _wafService.setHttpService(this);
    _interfaceService.setHttpService(this);
    _updateService.setHttpService(this);
    _wafWebsitesService.setHttpService(this);
  }

  String? sessionId;
  String? accessToken;

  Future<void> login(String username, String password) => _authService.login(username, password);
  Future<bool> verifyOtp(int otp) => _authService.verifyOtp(otp);

  Future<List<Map<String, dynamic>>> fetchNginxLogs() => _appService.fetchNginxLogs();
  Future<bool> clearAuditLogs() => _logService.clearAuditLogs();
  Future<Map<String, dynamic>> fetchNginxLogSummary() => _logService.fetchNginxLogSummary();
  Future<Map<String, dynamic>> fetchDailyTraffic() => _logService.fetchDailyTraffic();

  Future<http.Response> uploadFile(String? filePath, String applicationName, List<int> fileBytes) =>
      _appService.uploadFile(filePath, applicationName, fileBytes);
  Future<http.Response> deployFile(String fileName) => _appService.deployFile(fileName);
  Future<http.Response> getAppList() => _appService.getAppList();
  Future<dynamic> getNetworkInterfaces() => _appService.getNetworkInterfaces();
  Future<dynamic> getNetworkRoutes() => _appService.getNetworkRoutes();
  Future<Map<String, dynamic>> addGateway(String interfaceName) => _appService.addGateway(interfaceName);

  Future<List<Map<String, dynamic>>> fetchAppLogs() => _logService.fetchAppLogs();
  Future<List<Map<String, dynamic>>> fetchLoginLogs() => _logService.fetchLoginLogs();
  Future<List<dynamic>> fetchWafLogs() => _logService.fetchWafLogs();
  Future<bool> updateConfigFile(String fileKey, String newContents) => _wafService.updateConfigFile(fileKey, newContents);
  Future<List<dynamic>> getUsers() => _userService.getUsers();

  Future<Map<String, dynamic>> createUser({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String rule,
  }) =>
      _userService.createUser(
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
        email: email,
        rule: rule,
      );
  Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String rule,
  }) =>
      _userService.updateUser(
        userId: userId,
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
        rule: rule,
      );
  Future<void> deleteUser(int userId) => _userService.deleteUser(userId);

  Future<List<Map<String, dynamic>>> getActiveUsers() => _userService.getActiveUsers();
  Future<void> deleteActiveUser(int accessId) => _userService.deleteActiveUser(accessId);
  Future<Map<String, dynamic>> checkUpdateStatus() => _updateService.checkUpdateStatus();
  Future<Map<String, dynamic>> updateCrs() => _updateService.updateCrs();
  Future<bool> deleteRule(String ruleName) => _wafService.deleteRule(ruleName);
  Future<bool> setSecRuleEngine(String value) => _wafService.setSecRuleEngine(value);
  Future<bool> setSecResponseBodyAccess(bool value) => _wafService.setSecResponseBodyAccess(value);
  Future<String?> getSecAuditLog() => _wafService.getSecAuditLog();
  Future<bool> restoreBackupRules() => _wafService.restoreBackupRules();
  Future<void> backupRules() => _wafService.backupRules();
  Future<bool> logUserAccess(String username) => _wafService.logUserAccess(username);
  Future<bool> toggleModSecurity(String power) => _wafService.toggleModSecurity(power);
  Future<bool> checkModSecurityStatus() => _wafService.checkModSecurityStatus();
  Future<List<String>> fetchRules() => _wafService.fetchRules();
  Future<bool> createNewRule(String ruleName, String ruleBody) => _wafService.createNewRule(ruleName, ruleBody);
  Future<String> getRuleContent(String ruleName) => _wafService.getRuleContent(ruleName);
  Future<bool> updateRule(String ruleName, String ruleBody) => _wafService.updateRule(ruleName, ruleBody);
  Future<List<dynamic>> fetchRulesStatus() => _wafService.fetchRulesStatus();
  Future<bool> toggleRuleStatus(String ruleName, String newStatus) =>
      _wafService.toggleRuleStatus(ruleName, newStatus);
  Future<bool> authenticateWaf(String username, String password) => _wafService.authenticateWaf(username, password);

  Future<String?> getConfigFile(String fileKey) => _wafService.getConfigFile(fileKey);
  Future<bool> restoreConfigFile(String fileKey) => _wafService.restoreConfigFile(fileKey);
  Future<bool> restoreAllConfigFiles() => _wafService.restoreAllConfigFiles();

  Future<Map<String, dynamic>> addVirtualIp({
    required String ipAddress,
    required String netmask,
    required String interface,
  }) =>
      _interfaceService.addVirtualIp(ipAddress: ipAddress, netmask: netmask, interface: interface);
  Future<List<dynamic>> listVirtualIps() => _interfaceService.listVirtualIps();
  Future<Map<String, dynamic>> deleteVirtualIp(int vipId) => _interfaceService.deleteVirtualIp(vipId);
  Future<Map<String, dynamic>> releaseVirtualIp(int vipId) => _interfaceService.releaseVirtualIp(vipId);

  Future<List<Website>> listWebsites() => _appService.listWebsites();
  Future<Website> getWebsite(String websiteId) => _appService.getWebsite(websiteId);
  Future<Website> updateWebsiteStatus(String websiteId, String status) => _appService.updateWebsiteStatus(websiteId, status);
  Future<Website> getWebsiteByName(String name) => _appService.getWebsiteByName(name);
  Future<void> deleteWebsite(String websiteId) => _appService.deleteWebsite(websiteId);

  Future<Map<String, dynamic>> createWebsiteRule(String websiteId, String ruleName, String ruleContent) =>
      _wafWebsitesService.createRuleWebsite(websiteId, ruleName, ruleContent);
  Future<Map<String, dynamic>> updateWebsiteRule(String websiteId, String ruleName, String ruleContent) =>
      _wafWebsitesService.updateRule(websiteId, ruleName, ruleContent);
  Future<bool> deleteWebsiteRule(String websiteId, String ruleName) =>
      _wafWebsitesService.deleteRule(websiteId, ruleName);
  Future<bool> disableWebsiteRule(String websiteId, String ruleName) =>
      _wafWebsitesService.disableRule(websiteId, ruleName);
  Future<bool> enableWebsiteRule(String websiteId, String ruleName) =>
      _wafWebsitesService.enableRule(websiteId, ruleName);
  Future<List<dynamic>> getWebsiteRules(String websiteId) =>
      _wafWebsitesService.getRules(websiteId);
  Future<Map<String, dynamic>> createWebsiteBackup(String websiteId, String backupName) =>
      _wafWebsitesService.createBackup(websiteId, backupName);
  Future<bool> restoreWebsiteBackup(String websiteId, String backupName) =>
      _wafWebsitesService.restoreBackup(websiteId, backupName);
  Future<String> getWebsiteNginxConfig(String websiteId) =>
      _wafWebsitesService.getNginxConfig(websiteId);
  Future<bool> updateWebsiteNginxConfig(String websiteId, String config) =>
      _wafWebsitesService.updateNginxConfig(websiteId, config);
  Future<String> getWebsiteModsecMainConfig(String websiteId) =>
      _wafWebsitesService.getModsecMainConfig(websiteId);
  Future<String> getWebsiteAuditLog(String websiteId) =>
      _wafWebsitesService.getAuditLog(websiteId);
  Future<String> getWebsiteDebugLog(String websiteId) =>
      _wafWebsitesService.getDebugLog(websiteId);
  Future<bool> resetWebsiteAuditLog(String websiteId) =>
      _wafWebsitesService.resetAuditLog(websiteId);
  Future<bool> resetWebsiteDebugLog(String websiteId) =>
      _wafWebsitesService.resetDebugLog(websiteId);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}