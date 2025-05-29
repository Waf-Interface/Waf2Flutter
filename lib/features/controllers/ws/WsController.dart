import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/WebSocketService.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import 'package:msf/features/controllers/auth/LoginController.dart';
import 'package:msf/features/controllers/dashboard/ResourceUsageController.dart';

class WsController extends GetxController {
  final HttpService httpService = HttpService();
  final WebSocketService webSocketService = WebSocketService();

  var isLoading = true.obs;
  var isConnected = false.obs;
  Timer? _statusCheckTimer;
  var isReconnecting = false.obs;

  var logs = <String>[].obs;
  var auditLogs = <Map<String, dynamic>>[].obs;
  var nginxLogSummary = <String, dynamic>{}.obs;
  var deploymentStatus = <String, String>{}.obs;
  var modSecurityStatus = false.obs;
  var nginxLogs = <Map<String, dynamic>>[].obs;
  var summary = <String, dynamic>{}.obs;
  var traffic = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    ever(Get.find<LoginController>().loginSuccess, (bool isSuccess) {
      if (isSuccess) {
        connectWebSocket();
        _startPeriodicStatusCheck();
        print("WebSocket connection started");
      }
    });

    ever(webSocketService.isConnectedRx, (bool connected) {
      isConnected.value = connected;
      if (!connected && !isLoading.value && !isReconnecting.value) {
        showDisconnectedDialog();
      }
    });
  }

  Future<void> connectWebSocket() async {
    isLoading.value = true;
    isReconnecting.value = true;
    print("Attempting to connect WebSocket...");
    bool connected = await webSocketService.connect(processIncomingData);

    isConnected.value = connected;
    isLoading.value = false;
    isReconnecting.value = false;

    if (connected) {
      print("WebSocket connected successfully.");
      webSocketService.requestSystemInfo();
      webSocketService.requestShowAuditLogs();
    } else {
      print("Failed to connect to WebSocket. Check token or server availability.");
    }
  }

  void processIncomingData(String message) {
    try {
      Map<String, dynamic> data = jsonDecode(message);
      String messageType = data['type'];
      dynamic payload = data['payload'];

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
        case 'notification':
          _handleNotification(payload);
          break;
        case 'deployment_status':
          _handleDeploymentStatus(payload);
          break;
        case 'modsecurity_status':
          _handleModSecurityStatus(payload);
          break;
        case 'nginx_log':
          _handleNginxLog(payload);
          break;
        case 'summary':
          _handleSummary(payload);
          break;
        case 'traffic':
          _handleTraffic(payload);
          break;
        case 'error':
          print("Server error: ${jsonEncode(payload ?? 'No details provided')}");
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

  void _handleShowAuditLogs(dynamic payload) {
    if (payload is List) {
      auditLogs.value = payload.map((log) => log as Map<String, dynamic>).toList();
      print("Audit logs received: ${auditLogs.length} entries");
    } else if (payload is Map<String, dynamic> && payload['status'] == 'success') {
      auditLogs.value = List<Map<String, dynamic>>.from(payload['logs'] ?? payload['audit_logs']);
      print("Audit logs received: ${auditLogs.length} entries");
    } else {
      print("Failed to fetch audit logs: $payload");
    }
  }

  void _handleNginxLogSummary(Map<String, dynamic> data) {
    nginxLogSummary.value = data['summary'] ?? {};
    print("Nginx log summary received: $nginxLogSummary");
  }

  void _handleNotification(Map<String, dynamic> data) {
    print("Notification received: $data");
  }

  void _handleDeploymentStatus(Map<String, dynamic> data) {
    final websiteName = data['website_name'] as String?;
    final status = data['status'] as String?;
    if (websiteName != null && status != null) {
      deploymentStatus[websiteName] = status;
      print("Deployment status updated: $websiteName -> $status");
    } else {
      print("Invalid deployment status data: $data");
    }
  }

  void _handleModSecurityStatus(Map<String, dynamic> data) {
    if (data['status'] == 'success') {
      modSecurityStatus.value = data['mod_security_enabled'] as bool;
      print("ModSecurity status updated: ${modSecurityStatus.value}");
    } else {
      print("Failed to fetch ModSecurity status: ${data['message']}");
    }
  }

  void _handleNginxLog(Map<String, dynamic> data) {
    if (data['message'] == 'Nginx access log converted to JSON') {
      nginxLogs.value = List<Map<String, dynamic>>.from(data['logs']);
      print("Nginx logs received: ${nginxLogs.length} entries");
    } else {
      print("Failed to fetch nginx logs: ${data['message']}");
    }
  }

  void _handleSummary(Map<String, dynamic> data) {
    summary.value = data['summary'] ?? {};
    print("Summary received: $summary");
  }

  void _handleTraffic(Map<String, dynamic> data) {
    print("Raw traffic payload: $data");
    traffic.value = data['traffic'] ?? {};
    print("Traffic received: $traffic");
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

  // void requestDeploymentStatus(String websiteName) {
  //   webSocketService.requestDeploymentStatus(websiteName);
  // }

  void requestNotification() {
    webSocketService.requestNotification();
  }

  void requestModSecurityStatus() {
    webSocketService.requestModSecurityStatus();
  }

  void fetchNginxLog() {
    webSocketService.requestNginxLog();
  }

  void fetchSummary() {
    webSocketService.requestSummary();
  }

  void fetchTraffic() {
    webSocketService.requestTraffic();
  }

  void _startPeriodicStatusCheck() {
    _statusCheckTimer?.cancel();
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 13), (timer) async {
      if (isConnected.value) {
        print("Starting periodic status check cycle");
        webSocketService.requestSystemInfo();
        await Future.delayed(const Duration(seconds: 1));
        webSocketService.requestShowLogs();
        await Future.delayed(const Duration(seconds: 1));
        webSocketService.requestNginxLogSummary();
        await Future.delayed(const Duration(seconds: 1));
        webSocketService.requestNotification();
      //  await Future.delayed(const Duration(seconds: 1));
      //  webSocketService.requestDeploymentStatus("example.com");
        await Future.delayed(const Duration(seconds: 1));
        webSocketService.requestModSecurityStatus();
        await Future.delayed(const Duration(seconds: 1));
        webSocketService.requestNginxLog();
        await Future.delayed(const Duration(seconds: 1));
        webSocketService.requestSummary();
        await Future.delayed(const Duration(seconds: 1));
        webSocketService.requestTraffic();
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
    webSocketService.closeConnection();
    _statusCheckTimer?.cancel();
    print("WebSocket connection closed on controller dispose.");
    super.onClose();
  }
}