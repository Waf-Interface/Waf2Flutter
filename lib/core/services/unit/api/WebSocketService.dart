import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import 'config/Config.dart';
import 'dart:convert';
import 'dart:io';


//=---------------------------
//Uncompleted Usage Of Some Of Api's That We Update It Soon !
//=----------------------------
class WebSocketService {
  WebSocketChannel? channel;
  bool _isConnected = false;
  final HttpService _httpService = HttpService();

  bool get isConnected => _isConnected;

  void _setUpHttpOverrides() {
    HttpOverrides.global = MyHttpOverrides();
  }

  Future<bool> wsConnect(Function(String) onMessageReceived) async {
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
          print("WebSocket connection error: $error");
          _isConnected = false;
          channel?.sink.close();
        },
        onDone: () {
          print("WebSocket connection closed.");
          _isConnected = false;
        },
      );

      _isConnected = true;
      print("WebSocket connected successfully with token: $token");
      return true;
    } catch (e) {
      print("Failed to connect to WebSocket: $e");
      _isConnected = false;
      return false;
    }
  }

  void sendMessage(String message, {String messageType = 'default'}) {
    if (_isConnected && channel != null) {
      final msg = {
        'type': messageType,
        'payload': message,
      };
      String encodedMessage = jsonEncode(msg);
      channel!.sink.add(encodedMessage);
      print("Sent WebSocket message: $encodedMessage");
    } else {
      print('Cannot send message: WebSocket is not connected.');
    }
  }

  void requestSystemInfo() {
    sendMessage("start_system_info", messageType: 'system_info');
  }

  void requestShowLogs() {
    sendMessage("show_logs", messageType: 'show_logs');
  }

  void requestShowAuditLogs() {
    sendMessage("show_audit_logs", messageType: 'show_audit_logs');
  }

  void requestNginxLogSummary() {
    sendMessage("nginx_log_summary", messageType: 'nginx_log_summary');
  }

  void closeConnection() {
    channel?.sink.close();
    _isConnected = false;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}