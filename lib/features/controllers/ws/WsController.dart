import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/auth/LoginController.dart';
import 'package:msf/core/services/unit/api/WebSocketService.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import '../dashboard/ResourceUsageController.dart';

class WsController extends GetxController {
  final HttpService httpService = HttpService();
  final WebSocketService webSocketService = WebSocketService();

  var isLoading = true.obs;
  var isConnected = false.obs;
  Timer? _statusCheckTimer;

  var logs = <String>[].obs;
  var auditLogs = <String>[].obs;
  var nginxLogSummary = {}.obs;

  @override
  void onInit() {
    super.onInit();
    ever(Get.find<LoginController>().loginSuccess, (bool isSuccess) {
      if (isSuccess) {
        connectWebSocket();
        _startPeriodicStatusCheck();
        print("--------------------------WebSocket connection started");
      }
    });
  }

  Future<void> connectWebSocket() async {
    isLoading.value = true;
    print("Attempting to connect WebSocket...");
    bool connected = await webSocketService.wsConnect(processIncomingData);

    isConnected.value = connected;
    isLoading.value = false;

    if (connected) {
      print("WebSocket connected successfully.");
      webSocketService.requestSystemInfo();
    } else {
      showDisconnectedDialog();
      print("Failed to connect to WebSocket. Check token or server availability.");
    }
  }

  void processIncomingData(String message) {
    //print("WebSocket received data: $message");
    try {
      Map<String, dynamic> data = jsonDecode(message);
      String messageType = data['type'];
      Map<String, dynamic> payload = data['payload'];

      switch (messageType) {
        case 'system_info':
          _updateResourceUsage(payload);
          break;
        case 'show_logs':
          _handleShowLogs(payload);
          break;
        case 'show_audit_logs':
          _handleShowAuditLogs(payload);
          break;
        case 'nginx_log_summary':
          _handleNginxLogSummary(payload);
          break;
        case 'user_info':
          _handleUserInfo(payload);
          break;
        case 'notification':
          _handleNotification(payload);
          break;
        default:
          print("Unknown message type: $messageType");
      }
    } catch (e) {
      print("Failed to process incoming data: $e");
    }
  }

  void _updateResourceUsage(Map<String, dynamic> data) {
    final resourceUsageController = Get.find<ResourceUsageController>();
    resourceUsageController.updateUsageData(data);
  }

  void _handleShowLogs(Map<String, dynamic> data) {
    if (data['status'] == 'success') {
      logs.value = List<String>.from(data['logs']);
      print("Logs received: ${logs.length} entries");
    } else {
      print("Failed to fetch logs: ${data['detail']}");
    }
  }

  void _handleShowAuditLogs(Map<String, dynamic> data) {
    if (data['status'] == 'success') {
      auditLogs.value = List<String>.from(data['audit_logs']);
      print("Audit logs received: ${auditLogs.length} entries");
    } else {
      print("Failed to fetch audit logs: ${data['detail']}");
    }
  }

  void _handleNginxLogSummary(Map<String, dynamic> data) {
    nginxLogSummary.value = data['summary'];
    print("Nginx log summary received: $nginxLogSummary");
  }

  void _handleUserInfo(Map<String, dynamic> data) {
    print("User info received: $data");
  }

  void _handleNotification(Map<String, dynamic> data) {
    print("Notification received: $data");
  }

  void fetchLogs() {
    webSocketService.requestShowLogs();
  }

  void fetchAuditLogs() {
    webSocketService.requestShowAuditLogs();
  }

  void fetchNginxLogSummary() {
    webSocketService.requestNginxLogSummary();
  }

  void _startPeriodicStatusCheck() {
    _statusCheckTimer?.cancel();
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (isConnected.value) {
        print("---------------------------------------------sending periodic system_info");
        webSocketService.requestSystemInfo();
      } else {
        timer.cancel();
        print("WebSocket connection lost. Stopping status checks.");
        connectWebSocket();
      }
    });
  }

  void showDisconnectedDialog() {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        AlertDialog(
          title: const Text("Connection Lost"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Connection to the server was lost. Attempting to reconnect..."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                connectWebSocket();
              },
              child: const Text("Retry"),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }

  @override
  void onClose() {
    super.onClose();
    webSocketService.closeConnection();
    _statusCheckTimer?.cancel();
    print("WebSocket connection closed on controller dispose.");
  }
}