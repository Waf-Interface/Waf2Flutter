import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msf/core/services/unit/api/HttpService.dart';
import '../../config/Config.dart';

class AuthHttpService {

  //Fixing error late init..
  late HttpService _httpService;

  void setHttpService(HttpService service) {
    _httpService = service;
  }
  Future<void> login(String username, String password) async {
    String url = '${Config.httpAddress}/login';
    try {
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({'username': username, 'password': password}),
      );

      print('Login response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['login_status'] == 'pending') {
          _httpService.sessionId = jsonData['id'];
          String otp = jsonData['otp'];
          print("OTP sent: $otp, session id: ${_httpService.sessionId}");
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
    if (_httpService.sessionId == null) {
      print("Session ID not found");
      return false;
    }

    try {
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({'session_id': _httpService.sessionId!, 'otp': otp}),
      );

      print('Verify OTP response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['login_status'] == 'success') {
          _httpService.accessToken = jsonData['access_token'];
          print("Login success, token stored: ${_httpService.accessToken}");
          return true;
        } else {
          print("Unexpected response: ${jsonData['login_status']}");
        }
      } else {
        print("OTP verification failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during OTP verification: $e");
    }
    return false;
  }
}