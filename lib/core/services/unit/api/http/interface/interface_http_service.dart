import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msf/core/services/unit/api/HttpService.dart';
import '../../config/Config.dart';

class InterfaceHttpService {

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

  Future<Map<String, dynamic>> addVirtualIp({
    required String ipAddress,
    required String netmask,
    required String interface,
  }) async {
    String url = '${Config.httpAddress}/vips/add';
    try {
      final headers = _getHeaders();
      final body = jsonEncode({
        'ip_address': ipAddress,
        'netmask': netmask,
        'interface': interface,
      });
      print('Adding virtual IP with headers: $headers and body: $body');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      print('Add virtual IP response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add virtual IP: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding virtual IP: $e');
    }
  }

  Future<List<dynamic>> listVirtualIps() async {
    String url = '${Config.httpAddress}/vips/list';
    try {
      final headers = _getHeaders();
      print('Listing virtual IPs with headers: $headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('List virtual IPs response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to list virtual IPs: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error listing virtual IPs: $e');
    }
  }

  Future<Map<String, dynamic>> deleteVirtualIp(int vipId) async {
    String url = '${Config.httpAddress}/vips/delete/$vipId';
    try {
      final headers = _getHeaders();
      print('Deleting virtual IP with headers: $headers');
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );
      print('Delete virtual IP response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to delete virtual IP: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting virtual IP: $e');
    }
  }

  Future<Map<String, dynamic>> releaseVirtualIp(int vipId) async {
    String url = '${Config.httpAddress}/vips/release/$vipId';
    try {
      final headers = _getHeaders();
      print('Releasing virtual IP with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );
      print('Release virtual IP response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to release virtual IP: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error releasing virtual IP: $e');
    }
  }
}