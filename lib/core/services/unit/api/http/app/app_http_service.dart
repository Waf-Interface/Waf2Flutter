import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:msf/core/models/website.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import '../../config/Config.dart';

class AppHttpService {

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

  Future<List<Map<String, dynamic>>> fetchNginxLogs() async {
    String url = '${Config.httpAddress}/nginx_log';
    try {
      final headers = _getHeaders();
      print('Fetching Nginx logs with headers: $headers');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({}),
      );
      print('Nginx logs response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(jsonData['logs'] ?? []);
      } else {
        print("Failed to fetch Nginx logs: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching Nginx logs: $e");
      return [];
    }
  }

  Future<http.Response> uploadFile(String? filePath, String applicationName, List<int> fileBytes) async {
    try {
      final uri = Uri.parse('${Config.httpAddress}/upload');
      final request = http.MultipartRequest('POST', uri);
      if (_httpService.accessToken != null) request.headers['Authorization'] = 'Bearer ${_httpService.accessToken}';
      print('Uploading file with headers: ${request.headers}');
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: applicationName,
        contentType: MediaType.parse('application/zip'),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('Upload file response: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      throw Exception('Error during file upload: $e');
    }
  }

  Future<http.Response> deployFile(String fileName) async {
    try {
      final url = Uri.parse('${Config.httpAddress}/deploy/$fileName');
      final headers = _getHeaders();
      print('Deploying file with headers: $headers');
      final response = await http.get(
        url,
        headers: headers,
      );
      print('Deploy file response: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      throw Exception('Error during deployment request: $e');
    }
  }

  Future<http.Response> getAppList() async {
    try {
      final url = Uri.parse('${Config.httpAddress}/app_list');
      final headers = _getHeaders();
      print('Getting app list with headers: $headers');
      final response = await http.get(
        url,
        headers: headers,
      );
      print('Get app list response: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      throw Exception('Error during app list request: $e');
    }
  }

  Future<List<Website>> fetchAppList() async {
    try {
      final url = Uri.parse('${Config.httpAddress}/app_list');
      final headers = _getHeaders();
      print('Fetching app list with headers: $headers');
      final response = await http.get(
        url,
        headers: headers,
      );
      print('Fetch app list response: ${response.statusCode} - ${response.body}');
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

  Future<dynamic> getNetworkInterfaces() async {
    String url = '${Config.httpAddress}/sys/network/interfaces';
    try {
      final headers = _getHeaders();
      print('Fetching network interfaces with headers: $headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Network interfaces response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error fetching network interfaces: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching network interfaces: $e');
    }
  }

  Future<dynamic> getNetworkRoutes() async {
    String url = '${Config.httpAddress}/sys/network/routes';
    try {
      final headers = _getHeaders();
      print('Fetching network routes with headers: $headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Network routes response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error fetching network routes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching network routes: $e');
    }
  }

  Future<Map<String, dynamic>> addGateway(String interfaceName) async {
    String url = '${Config.httpAddress}/sys/network/gateway';
    try {
      final headers = _getHeaders();
      final body = jsonEncode({'interface': interfaceName});
      print('Adding gateway with headers: $headers and body: $body');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      print('Add gateway response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error adding gateway: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding gateway: $e');
    }
  }
}