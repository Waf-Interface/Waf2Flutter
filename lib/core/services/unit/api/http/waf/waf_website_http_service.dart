import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msf/core/services/unit/api/HttpService.dart';
import 'package:msf/core/services/unit/api/config/Config.dart';

class WafWebsitesHttpService {
  late HttpService _httpService;
  final String baseUrl = '${Config.httpAddress}/waf/website';

  void setHttpService(HttpService httpService) {
    _httpService = httpService;
  }

  Future<Map<String, dynamic>> createRuleWebsite(String websiteId, String ruleName, String ruleContent) async {
    final url = '$baseUrl/$websiteId/rule';
    print('Request URL: $url');
    print('Access Token: ${_httpService.accessToken}');
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
      body: jsonEncode({
        'name': ruleName,
        'content': ruleContent,
      }),
    );
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to create rule: ${response.body}');
  }

  Future<Map<String, dynamic>> updateRule(String websiteId, String ruleName, String ruleContent) async {
    final url = '$baseUrl/$websiteId/rule/$ruleName';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
      body: jsonEncode({
        'name': ruleName,
        'content': ruleContent,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to update rule: ${response.body}');
  }

  Future<bool> deleteRule(String websiteId, String ruleName) async {
    final url = '$baseUrl/$websiteId/rule/$ruleName';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'] == 'success';
    }
    throw Exception('Failed to delete rule: ${response.body}');
  }

  Future<bool> disableRule(String websiteId, String ruleName) async {
    final url = '$baseUrl/$websiteId/rule/$ruleName/disable';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'] == 'success';
    }
    throw Exception('Failed to disable rule: ${response.body}');
  }

  Future<bool> enableRule(String websiteId, String ruleName) async {
    final url = '$baseUrl/$websiteId/rule/$ruleName/enable';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'] == 'success';
    }
    throw Exception('Failed to enable rule: ${response.body}');
  }

  Future<List<dynamic>> getRules(String websiteId) async {
    final url = '$baseUrl/$websiteId/rules';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['rules'];
    }
    throw Exception('Failed to fetch rules: ${response.body}');
  }

  Future<Map<String, dynamic>> createBackup(String websiteId, String backupName) async {
    final url = '$baseUrl/$websiteId/backup';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
      body: jsonEncode({
        'name': backupName,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to create backup: ${response.body}');
  }

  Future<bool> restoreBackup(String websiteId, String backupName) async {
    final url = '$baseUrl/$websiteId/restore/$backupName';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'] == 'success';
    }
    throw Exception('Failed to restore backup: ${response.body}');
  }

  Future<String> getNginxConfig(String websiteId) async {
    final url = '$baseUrl/$websiteId/nginx-config';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['config'];
    }
    throw Exception('Failed to fetch nginx config: ${response.body}');
  }

  Future<bool> updateNginxConfig(String websiteId, String config) async {
    final url = '$baseUrl/$websiteId/nginx-config';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
      body: jsonEncode({
        'config': config,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'] == 'success';
    }
    throw Exception('Failed to update nginx config: ${response.body}');
  }

  Future<String> getModsecMainConfig(String websiteId) async {
    final url = '$baseUrl/$websiteId/modsec-main-config';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['config'];
    }
    throw Exception('Failed to fetch modsec main config: ${response.body}');
  }

  Future<String> getAuditLog(String websiteId) async {
    final url = '$baseUrl/$websiteId/audit-log';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['log'];
    }
    throw Exception('Failed to fetch audit log: ${response.body}');
  }

  Future<String> getDebugLog(String websiteId) async {
    final url = '$baseUrl/$websiteId/debug-log';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['log'];
    }
    throw Exception('Failed to fetch debug log: ${response.body}');
  }

  Future<bool> resetAuditLog(String websiteId) async {
    final url = '$baseUrl/$websiteId/audit-log/reset';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'] == 'success';
    }
    throw Exception('Failed to reset audit log: ${response.body}');
  }

  Future<bool> resetDebugLog(String websiteId) async {
    final url = '$baseUrl/$websiteId/debug-log/reset';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        if (_httpService.accessToken != null) 'Authorization': 'Bearer ${_httpService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'] == 'success';
    }
    throw Exception('Failed to reset debug log: ${response.body}');
  }
}