import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msf/core/services/unit/api/HttpService.dart';
import '../../config/Config.dart';

class LogHttpService {

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

  Future<List<Map<String, dynamic>>> fetchAppLogs() async {
    try {
      final url = Uri.parse('${Config.httpAddress}/logs/app');
      final headers = _getHeaders();
      print('Fetching app logs with headers: $headers');
      final response = await http.get(
        url,
        headers: headers,
      );
      print('Fetch app logs response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(List<Map<String, dynamic>>.from(jsonData['logs'] ?? []));
        return List<Map<String, dynamic>>.from(jsonData['logs'] ?? []);
      } else {
        print("Failed to fetch app logs: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching app logs: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchLoginLogs() async {
    try {
      final url = Uri.parse('${Config.httpAddress}/logs/login');
      final headers = _getHeaders();
      print('Fetching login logs with headers: $headers');
      final response = await http.get(
        url,
        headers: headers,
      );
      print('Fetch login logs response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(List<Map<String, dynamic>>.from(jsonData['logs'] ?? []));
        return List<Map<String, dynamic>>.from(jsonData['logs'] ?? []);
      } else {
        print("Failed to fetch login logs: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching login logs: $e");
      return [];
    }
  }

  Future<List<dynamic>> fetchWafLogs() async {
    String url = '${Config.httpAddress}/waf/show_audit_logs/';
    try {
      final headers = _getHeaders();
      print('Fetching WAF logs with headers: $headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Fetch WAF logs response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        var auditLogs = jsonData['audit_logs'] ?? [];
        if (auditLogs is String) {
          List<dynamic> decodedLogs = jsonDecode(auditLogs);
          return decodedLogs;
        } else if (auditLogs is List) {
          return auditLogs;
        }
      }
      return [];
    } catch (e) {
      print("Error fetching WAF logs: $e");
      return [];
    }
  }
}