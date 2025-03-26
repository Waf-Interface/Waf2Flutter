import 'dart:convert';
import 'package:file_saver/file_saver.dart';
import 'package:http/http.dart' as http;
import 'package:msf/core/services/unit/api/HttpService.dart';
import '../../config/Config.dart';

class WafHttpService {

  //Fixing error late init..
  late HttpService _httpService;
  void setHttpService(HttpService service) {
    _httpService = service;
  }
  Map<String, String> _getHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (_httpService.accessToken != null) headers['Authorization'] = 'Bearer ${_httpService.accessToken}';
    return headers;
  }

  Future<bool> deleteRule(String ruleName) async {
    String url = '${Config.httpAddress}/waf/delete_rule/';
    try {
      final headers = _getHeaders();
      print('Deleting rule with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'username': 'test',
          'password': 'test',
          'rule': ruleName,
        }),
      );
      print('Delete rule response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print("Error deleting rule: $e");
      return false;
    }
  }

  Future<bool> setSecRuleEngine(String value) async {
    String url = '${Config.httpAddress}/waf/set_sec_rule_engine/';
    try {
      final headers = _getHeaders();
      print('Setting SecRuleEngine with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({'value': value}),
      );
      print('Set SecRuleEngine response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to set SecRuleEngine: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error in setSecRuleEngine: $e");
      return false;
    }
  }

  Future<bool> setSecResponseBodyAccess(bool value) async {
    String url = '${Config.httpAddress}/waf/set_sec_response_body_access/';
    try {
      final headers = _getHeaders();
      print('Setting SecResponseBodyAccess with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({'value': value}),
      );
      print('Set SecResponseBodyAccess response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to set SecResponseBodyAccess: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error in setSecResponseBodyAccess: $e");
      return false;
    }
  }

  Future<String?> getSecAuditLog() async {
    String url = '${Config.httpAddress}/waf/get_sec_audit_log/';
    try {
      final headers = _getHeaders();
      print('Getting SecAuditLog with headers: $headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Get SecAuditLog response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['SecAuditLog'];
      } else {
        print("Failed to fetch SecAuditLog: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error in getSecAuditLog: $e");
      return null;
    }
  }

  Future<bool> restoreBackupRules() async {
    String url = '${Config.httpAddress}/waf/restore_backup_rules/';
    try {
      final headers = _getHeaders();
      print('Restoring backup rules with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );
      print('Restore backup rules response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print("Error restoring backup rules: $e");
      return false;
    }
  }

  Future<void> backupRules() async {
    String url = '${Config.httpAddress}/waf/backup_rules/';
    try {
      final headers = _getHeaders();
      print('Backing up rules with headers: $headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Backup rules response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes.buffer.asUint8List();
        await FileSaver.instance.saveFile(
          name: "rule_backup",
          bytes: bytes,
          ext: "zip",
          customMimeType: "application/zip",
        );
      } else {
        print("Failed to download backup: ${response.body}");
      }
    } catch (e) {
      print("Error downloading backup rules: $e");
    }
  }

  Future<bool> logUserAccess(String username) async {
    String url = '${Config.httpAddress}/waf/log_user/';
    try {
      final headers = _getHeaders();
      print('Logging user access with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({'username': username}),
      );
      print('Log user access response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print("Error logging user access: $e");
      return false;
    }
  }

  Future<bool> toggleModSecurity(String power) async {
    String url = '${Config.httpAddress}/waf/set_engine/';
    try {
      final headers = _getHeaders();
      print('Toggling ModSecurity with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'username': 'test',
          'password': 'test',
          'power': power,
        }),
      );
      print('Toggle ModSecurity response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print("Error toggling ModSecurity: $e");
      return false;
    }
  }

  Future<bool> checkModSecurityStatus() async {
    String url = '${Config.httpAddress}/waf/status/';
    try {
      final headers = _getHeaders();
      print('Checking ModSecurity status with headers: $headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Check ModSecurity status response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['mod_security_enabled'] ?? false;
      }
      return false;
    } catch (e) {
      print("Error checking ModSecurity status: $e");
      return false;
    }
  }

  Future<List<String>> fetchRules() async {
    String url = '${Config.httpAddress}/waf/show_modsec_rules/';
    try {
      final headers = _getHeaders();
      print('Fetching rules with headers: $headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Fetch rules response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['modsec_rules']);
      } else {
        print("Failed to fetch rules: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching WAF rules: $e");
      return [];
    }
  }

  Future<bool> createNewRule(String ruleName, String ruleBody) async {
    String url = '${Config.httpAddress}/waf/new_rule/';
    try {
      final headers = _getHeaders();
      print('Creating new rule with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'username': 'test',
          'password': 'test',
          'rule': ruleName,
          'body': ruleBody,
        }),
      );
      print('Create new rule response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print("Error creating new WAF rule: $e");
      return false;
    }
  }

  Future<String> getRuleContent(String ruleName) async {
    String url = '${Config.httpAddress}/waf/load_rule/$ruleName';
    try {
      final headers = _getHeaders();
      print('Getting rule content with headers: $headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Get rule content response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['rule_content'] ?? 'No content found.';
      } else {
        return 'Error fetching rule content.';
      }
    } catch (e) {
      return 'Error fetching rule content: $e';
    }
  }

  Future<bool> updateRule(String ruleName, String ruleBody) async {
    String url = '${Config.httpAddress}/waf/update_rule/$ruleName';
    try {
      final headers = _getHeaders();
      print('Updating rule with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'username': 'test',
          'password': 'test',
          'body': ruleBody,
        }),
      );
      print('Update rule response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to update rule: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error updating rule: $e");
      return false;
    }
  }

  Future<List<dynamic>> fetchRulesStatus() async {
    String url = '${Config.httpAddress}/waf/rule/status';
    try {
      final headers = _getHeaders();
      print('Fetching rules status with headers: $headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Fetch rules status response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return data['rules'];
      } else {
        print("Failed to fetch rule statuses: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching rule statuses: $e");
      return [];
    }
  }

  Future<bool> toggleRuleStatus(String ruleName, String newStatus) async {
    String url = '${Config.httpAddress}/waf/rule/enable_disable/';
    try {
      final headers = _getHeaders();
      print('Toggling rule status with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'username': 'test',
          'password': 'test',
          'rule': ruleName,
          'status': newStatus,
        }),
      );
      print('Toggle rule status response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to toggle rule status: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error toggling rule status: $e");
      return false;
    }
  }

  Future<bool> authenticateWaf(String username, String password) async {
    String url = '${Config.httpAddress}/waf/auth/';
    try {
      final headers = {'Content-Type': 'application/json'};
      print('Authenticating WAF with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({'username': username, 'password': password}),
      );
      print('Authenticate WAF response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print("Error during WAF authentication: $e");
      return false;
    }
  }


  Future<String?> getConfigFile(String fileKey) async {
    String url = '${Config.httpAddress}/waf/get_config_file/$fileKey';
    try {
      final headers = _getHeaders();
      print('Getting config file with headers: $headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Get config file response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['contents'] as String?;
      } else {
        print("Failed to fetch config file: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error fetching config file: $e");
      return null;
    }
  }

  Future<bool> restoreConfigFile(String fileKey) async {
    String url = '${Config.httpAddress}/waf/restore_config_file/$fileKey';
    try {
      final headers = _getHeaders();
      print('Restoring config file with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );
      print('Restore config file response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to restore config file: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error restoring config file: $e");
      return false;
    }
  }

  Future<bool> restoreAllConfigFiles() async {
    String url = '${Config.httpAddress}/waf/restore_all_config_files/';
    try {
      final headers = _getHeaders();
      print('Restoring all config files with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );
      print('Restore all config files response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to restore all config files: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error restoring all config files: $e");
      return false;
    }
  }
  Future<bool> updateConfigFile(String fileKey, String newContents) async {
    String url = '${Config.httpAddress}/waf/update_config/$fileKey';
    try {
      final headers = _getHeaders();
      print('Updating config file with headers: $headers');
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: newContents,
      );
      print('Update config file response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to update config file: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error updating config file: $e");
      return false;
    }
  }
}