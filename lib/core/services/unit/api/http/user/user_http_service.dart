import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msf/core/services/unit/api/HttpService.dart';
import '../../config/Config.dart';

class UserHttpService {

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

  Future<List<dynamic>> getUsers() async {
    String url = '${Config.httpAddress}/users/';
    try {
      final headers = _getHeaders();
      print('Fetching users with headers: $headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Get users response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error fetching users: ${response.statusCode} - ${response.body}");
        throw Exception('Error fetching users: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  Future<Map<String, dynamic>> createUser({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String rule,
  }) async {
    String url = '${Config.httpAddress}/create_users/';
    try {
      final headers = _getHeaders();
      final body = jsonEncode({
        'username': username,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'rule': rule,
      });
      print('Creating user with headers: $headers and body: $body');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      print('Create user response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error creating user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String rule,
  }) async {
    String url = '${Config.httpAddress}/users/$userId';
    try {
      final headers = _getHeaders();
      final body = jsonEncode({
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'rule': rule,
      });
      print('Updating user with headers: $headers and body: $body');
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      print('Update user response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error updating user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  Future<void> deleteUser(int userId) async {
    String url = '${Config.httpAddress}/users/$userId';
    try {
      final headers = _getHeaders();
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );
      print('Delete user response: ${response.statusCode} - ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Error deleting user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getActiveUsers() async {
    String url = '${Config.httpAddress}/active_users/';
    try {
      final headers = _getHeaders();
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Error fetching active users: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching active users: $e');
    }
  }

  Future<void> deleteActiveUser(int accessId) async {
    String url = '${Config.httpAddress}/active_users/$accessId';
    try {
      final headers = _getHeaders();
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw Exception('Error deleting active user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting active user: $e');
    }
  }
}