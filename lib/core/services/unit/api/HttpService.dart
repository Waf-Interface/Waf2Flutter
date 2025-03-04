import 'dart:convert';
import 'dart:io';
import 'package:file_saver/file_saver.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:msf/core/models/website.dart';
import 'config/Config.dart';

class HttpService {
  String? sessionId;

  HttpService() {
    HttpOverrides.global = MyHttpOverrides();
  }

  Future<void> login(String username, String password) async {
    String url = '${Config.httpAddress}/login';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['login_status'] == 'pending') {
          sessionId = jsonData['id'];
          String otp = jsonData['otp'];
          print("OTP sent: $otp, session id: $sessionId");
        } else {
          print("Unexpected login status: ${jsonData['login_status']}");
        }
      } else {
        print("Login failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during login request: $e");
    }
  }

  Future<bool> verifyOtp(int otp) async {
    String url = '${Config.httpAddress}/verify_otp';
    if (sessionId == null) {
      print("Session ID not found");
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'session_id': sessionId!, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['login_status'] == 'success') {
          print("Login success");
          return true;
        } else {
          print("Unexpected response: ${jsonData['login_status']}");
        }
      } else {
        print(
            "OTP verification failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during OTP verification: $e");
    }
    return false;
  }

  Future<http.Response> uploadFile(
      String? filePath, String applicationName, List<int> fileBytes) async {
    try {
      final uri = Uri.parse('${Config.httpAddress}/upload');
      final request = http.MultipartRequest('POST', uri);

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: applicationName,
        contentType: MediaType.parse('application/zip'),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return response;
    } catch (e) {
      throw Exception('Error during file upload: $e');
    }
  }
  Future<bool> deleteRule(String ruleName) async {
    String url = '${Config.httpAddress}/waf/delete_rule/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': 'test',
          'password': 'test',
          'rule': ruleName,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error deleting rule: $e");
      return false;
    }
  }

  Future<http.Response> deployFile(String fileName) async {
    try {
      final url = Uri.parse('${Config.httpAddress}/deploy/$fileName');
      final response = await http.get(url);
      return response;
    } catch (e) {
      throw Exception('Error during deployment request: $e');
    }
  }

  Future<http.Response> getAppList() async {
    try {
      final url = Uri.parse('${Config.httpAddress}/app_list');
      final response = await http.get(url);
      return response;
    } catch (e) {
      throw Exception('Error during app list request: $e');
    }
  }

  Future<List<Website>> fetchAppList() async {
    try {
      final url = Uri.parse('${Config.httpAddress}/app_list');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> apps = jsonDecode(response.body)['applications'];
        return apps.map((data) => Website.fromJson(data)).toList();
      } else {
        throw Exception('Failed to fetch applications');
      }
    } catch (e) {
      throw Exception('Error fetching applications: $e');
    }
  }
  Future<bool> restoreBackupRules() async {
    String url = '${Config.httpAddress}/waf/restore_backup_rules/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error restoring backup rules: $e");
      return false;
    }
  }

  Future<void> backupRules() async {
    String url = '${Config.httpAddress}/waf/backup_rules/';
    try {
      final response = await http.get(Uri.parse(url));
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



}

Future<bool> authenticateWaf(String username, String password) async {
  String url = '${Config.httpAddress}/waf/auth/';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    return response.statusCode == 200;
  } catch (e) {
    print("Error during WAF authentication: $e");
    return false;
  }
}


//*-------Section for ----------------------------------------------------------------------

Future<bool> logUserAccess(String username) async {
  String url = '${Config.httpAddress}/waf/log_user/';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );
    return response.statusCode == 200;
  } catch (e) {
    print("Error logging user access: $e");
    return false;
  }
}

Future<bool> toggleModSecurity(String power) async {
  String url = '${Config.httpAddress}/waf/set_engine/';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body:
      jsonEncode({'username': 'test', 'password': 'test', 'power': power}),
    );
    return response.statusCode == 200;
  } catch (e) {
    print("Error toggling ModSecurity: $e");
    return false;
  }
}

Future<bool> checkModSecurityStatus() async {
  String url = '${Config.httpAddress}/waf/status/';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['mod_security_enabled'] ?? false;
    }
  } catch (e) {
    print("Error checking ModSecurity status: $e");
  }
  return false;
}


Future<List<dynamic>> fetchWafLogs() async {
  String url = '${Config.httpAddress}/waf/show_audit_logs/';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      var auditLogs = jsonData['audit_logs'] ?? [];
      if (auditLogs is String) {
        List<dynamic> decodedLogs = jsonDecode(auditLogs);
        return decodedLogs;
      } else if (auditLogs is List) {
        return auditLogs;
      }
    }
  } catch (e) {
    print("Error fetching WAF logs: $e");
  }
  return [];
}

Future<List<String>> fetchRules() async {
  String url = '${Config.httpAddress}/waf/show_modsec_rules/';
  try {
    final response = await http.get(Uri.parse(url));

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
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'rule': ruleName, 'body': ruleBody,
      'username': 'test',
      'password': 'test',}),
    );
    return response.statusCode == 200;
  } catch (e) {
    print("Error creating new WAF rule: $e");
    return false;
  }
}

Future<String> getRuleContent(String ruleName) async {
  String url = '${Config.httpAddress}/waf/load_rule/$ruleName';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

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
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': 'test',
        'password': 'test',
        'body': ruleBody,
      }),
    );
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
    final response = await http.get(Uri.parse(url));
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
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': 'test',
        'password': 'test',
        'rule': ruleName,
        'status': newStatus,
      }),
    );
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



class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
