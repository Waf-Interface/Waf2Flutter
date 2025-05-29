import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import 'package:msf/core/services/unit/api/config/Config.dart';
import 'dart:convert';
import 'dart:io';

class WebSocketService {
  WebSocketChannel? channel;
  final RxBool _isConnected = false.obs;
  final HttpService _httpService = HttpService();

  bool get isConnected => _isConnected.value;
  RxBool get isConnectedRx => _isConnected;

  void _setUpHttpOverrides() {
    HttpOverrides.global = MyHttpOverrides();
  }

  Future<bool> connect(Function(String) onMessageReceived) async {
    if (_isConnected.value) return true;

    _setUpHttpOverrides();

    try {
      final token = _httpService.accessToken;
      if (token == null) {
        print("No access token available. Cannot connect to WebSocket.");
        return false;
      }

      final url = Uri.parse('${Config.websocketAddress}?token=$token');
      print("Connecting to WebSocket: $url");
      channel = WebSocketChannel.connect(url);

      channel!.stream.listen(
            (message) {
          onMessageReceived(message);
        },
        onError: (error) {
          print("WebSocket error: $error");
          _isConnected.value = false;
        },
        onDone: () {
          print("WebSocket connection closed by server. Code: ${channel?.closeCode}, Reason: ${channel?.closeReason}");
          _isConnected.value = false;
          _attemptReconnect(onMessageReceived);
        },
        cancelOnError: false,
      );

      _isConnected.value = true;
      print("WebSocket connected successfully with token: $token");
      return true;
    } catch (e) {
      print("Failed to connect to WebSocket: $e");
      _isConnected.value = false;
      _attemptReconnect(onMessageReceived);
      return false;
    }
  }

  void _attemptReconnect(Function(String) onMessageReceived) async {
    if (!_isConnected.value) {
      print("Attempting to reconnect in 5 seconds...");
      await Future.delayed(const Duration(seconds: 5));
      await connect(onMessageReceived);
    }
  }

  void sendMessage({required String messageType, Map<String, dynamic>? payload}) {
    if (_isConnected.value && channel != null) {
      final msg = payload != null ? {'type': messageType, ...payload} : {'type': messageType};
      String encodedMessage = jsonEncode(msg);
      channel!.sink.add(encodedMessage);
      print("Sent WebSocket message: $encodedMessage");
    } else {
      print('Cannot send message: WebSocket is not connected.');
    }
  }

  void requestSystemInfo() {
    sendMessage(messageType: 'system_info');
  }

  void requestShowLogs() {
    sendMessage(messageType: 'show_logs');
  }

  void requestShowAuditLogs() {
    sendMessage(messageType: 'show_audit_logs');
  }

  void requestNginxLogSummary() {
    sendMessage(messageType: 'nginx_log_summary');
  }

  void requestNotification() {
    sendMessage(messageType: 'notification');
  }

  // void requestDeploymentStatus(String websiteName) {
  //   sendMessage(messageType: 'deployment_status', payload: {'website_name': websiteName});
  // }

  void requestModSecurityStatus() {
    sendMessage(messageType: 'modsecurity_status');
  }

  void requestNginxLog() {
    sendMessage(messageType: 'nginx_log');
  }

  void requestSummary() {
    sendMessage(messageType: 'summary');
  }

  void requestTraffic() {
    sendMessage(messageType: 'traffic');
  }

  void closeConnection() {
    channel?.sink.close();
    _isConnected.value = false;
    print("WebSocket connection closed manually.");
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}