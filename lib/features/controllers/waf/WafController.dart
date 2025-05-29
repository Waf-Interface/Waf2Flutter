import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import 'package:file_saver/file_saver.dart';
import 'package:msf/features/controllers/log/NginxLogController.dart';
import 'package:msf/features/controllers/ws/WsController.dart';

class WafLogController extends GetxController {
  var logs = <Map<String, dynamic>>[].obs;
  var filteredLogs = <Map<String, dynamic>>[].obs;
  var selectedEntries = 10.obs;
  var searchText = ''.obs;
  var filterType = "All".obs;
  var isLoading = false.obs;
  var modStatus = false.obs;

  var warningsCount = 0.obs;
  var criticalCount = 0.obs;
  var messagesCount = 0.obs;
  var allCount = 0.obs;
  var lastRefresh = ''.obs;

  final HttpService httpService = HttpService();
  late final WsController wsController;
  final NginxLogController nginxLogController = NginxLogController();

  @override
  void onInit() {
    wsController = Get.find<WsController>();
    _syncWithWebSocket();
    fetchInitialLogs(); // Initial HTTP fetch as fallback
    super.onInit();
  }

  void _syncWithWebSocket() {
    ever(wsController.auditLogs, (List<Map<String, dynamic>> auditLogs) {
      _processLogUpdate(auditLogs);
    });

    ever(wsController.isConnected, (bool connected) {
      if (!connected) {
        isLoading.value = true;
      } else {
        isLoading.value = false;
        wsController.fetchAuditLogs();
        wsController.requestModSecurityStatus(); // Request status when reconnected
      }
    });

    ever(wsController.modSecurityStatus, (bool status) {
      modStatus.value = status;
      print("ModSecurity status synced: $status");
    });

    // Initial request
    if (wsController.isConnected.value) {
      wsController.fetchAuditLogs();
      wsController.requestModSecurityStatus();
    }
  }

  void fetchInitialLogs() async {
    isLoading.value = true;
    try {
      dynamic response = await httpService.fetchWafLogs();
      _processLogResponse(response);
    } catch (e) {
      print("Error fetching initial logs: $e");
      logs.value = [];
      filteredLogs.value = [];
    }
    isLoading.value = false;
  }

  void _processLogUpdate(List<Map<String, dynamic>> logData) {
    logs.value = logData.map<Map<String, dynamic>>((logEntry) {
      String summary = (logEntry['timestamp'] != null && logEntry['client_ip'] != null)
          ? '${logEntry['timestamp']} - ${logEntry['client_ip']}'
          : 'Log Entry';
      return {
        'summary': summary,
        'full': logEntry,
      };
    }).toList();

    _sortAndIndexLogs();
    _updateCounts();
    applyFilter();
    lastRefresh.value = DateFormat('HH:mm:ss').format(DateTime.now());
  }

  void _processLogResponse(dynamic response) {
    List<dynamic> logData;
    if (response is String) {
      var decoded = jsonDecode(response);
      logData = (decoded is Map && decoded.containsKey("logs")) ? decoded["logs"] : decoded is List ? decoded : [];
    } else if (response is Map<String, dynamic>) {
      logData = response["logs"] ?? [];
    } else if (response is List) {
      logData = response;
    } else {
      logData = [];
    }

    _processLogUpdate(logData.cast<Map<String, dynamic>>());
  }

  void _sortAndIndexLogs() {
    logs.sort((a, b) {
      DateTime dateA = DateTime.tryParse(a['full']['timestamp'] ?? '') ?? DateTime(1970);
      DateTime dateB = DateTime.tryParse(b['full']['timestamp'] ?? '') ?? DateTime(1970);
      return dateB.compareTo(dateA);
    });

    for (int i = 0; i < logs.length; i++) {
      logs[i]['#'] = (i + 1).toString();
    }
  }

  bool logMatches(Map fullLog, String search) {
    search = search.toLowerCase();
    if ((fullLog['timestamp']?.toString().toLowerCase() ?? '').contains(search)) return true;
    if ((fullLog['client_ip']?.toString().toLowerCase() ?? '').contains(search)) return true;
    if (fullLog.containsKey('alerts')) {
      for (var alert in fullLog['alerts']) {
        if ((alert['message']?.toString().toLowerCase() ?? '').contains(search)) return true;
      }
    }
    return false;
  }

  void clearLogs() async {
    isLoading.value = true;
    try {
      bool success = await httpService.clearAuditLogs();
      if (success) {
        logs.clear();
        filteredLogs.clear();
        wsController.auditLogs.clear();
        Get.snackbar("Success", "All logs cleared successfully");
      } else {
        Get.snackbar("Error", "Failed to clear logs");
      }
    } catch (e) {
      print("Error clearing logs: $e");
      Get.snackbar("Error", "An error occurred while clearing logs");
    }
    isLoading.value = false;
  }

  void _updateCounts() {
    int totalCritical = logs.where((log) {
      Map fullLog = log['full'];
      if (fullLog.containsKey('alerts')) {
        List alerts = fullLog['alerts'];
        return alerts.any((w) {
          String msg = (w['message'] ?? '').toString().toLowerCase();
          return msg.contains('sqli') || msg.contains('anomaly') || msg.contains('rce');
        });
      }
      return false;
    }).length;

    int totalWarnings = logs.where((log) {
      Map fullLog = log['full'];
      if (fullLog.containsKey('alerts')) {
        List alerts = fullLog['alerts'];
        bool isCritical = alerts.any((w) {
          String msg = (w['message'] ?? '').toString().toLowerCase();
          return msg.contains('sqli') || msg.contains('anomaly') || msg.contains('rce');
        });
        return !isCritical && alerts.isNotEmpty;
      }
      return false;
    }).length;

    int totalMessages = logs.where((log) {
      Map fullLog = log['full'];
      return !fullLog.containsKey('alerts') || (fullLog['alerts'] as List).isEmpty;
    }).length;

    warningsCount.value = totalWarnings;
    criticalCount.value = totalCritical;
    messagesCount.value = totalMessages;
    allCount.value = logs.length;
  }

  Map<String, int> getRuleTriggerCounts() {
    Map<String, int> ruleCounts = {};
    for (var log in logs) {
      var fullLog = log['full'];
      if (fullLog.containsKey('alerts')) {
        for (var alert in fullLog['alerts']) {
          String ruleId = alert['id']?.toString() ?? 'Unknown';
          ruleCounts[ruleId] = (ruleCounts[ruleId] ?? 0) + 1;
        }
      }
    }
    return ruleCounts;
  }

  void applyFilter() {
    filteredLogs.value = logs.where((log) {
      String searchLower = searchText.value.toLowerCase();
      var fullLog = log['full'];
      bool baseMatches = log['summary'].toString().toLowerCase().contains(searchLower) ||
          logMatches(fullLog, searchLower);
      bool typeMatches = true;
      if (filterType.value != "All") {
        if (filterType.value == "Warning") {
          typeMatches = fullLog.containsKey('alerts') && (fullLog['alerts'] as List).isNotEmpty;
        } else if (filterType.value == "Critical") {
          if (fullLog.containsKey('alerts')) {
            List alerts = fullLog['alerts'];
            typeMatches = alerts.any((w) {
              String msg = w['message']?.toString().toLowerCase() ?? '';
              return msg.contains('sqli') || msg.contains('anomaly') || msg.contains('rce');
            });
          } else {
            typeMatches = false;
          }
        } else if (filterType.value == "IP") {
          typeMatches = (fullLog['client_ip']?.toString().toLowerCase() ?? '').contains(searchLower);
        } else if (filterType.value == "Message") {
          if (fullLog.containsKey('alerts')) {
            List alerts = fullLog['alerts'];
            typeMatches = alerts.any((w) {
              return (w['message']?.toString().toLowerCase() ?? '').contains(searchLower);
            });
          } else {
            typeMatches = false;
          }
        }
      }
      return baseMatches && typeMatches;
    }).take(selectedEntries.value).toList();
  }

  void downloadLogs() async {
    final jsonString = jsonEncode(logs);
    final bytes = Uint8List.fromList(utf8.encode(jsonString));
    await FileSaver.instance.saveFile(
      name: "waf_logs",
      bytes: bytes,
      ext: "json",
      customMimeType: "application/json",
    );
  }
  void fetchLogs() async {
    isLoading.value = true;
    try {
      dynamic response = await httpService.fetchWafLogs();
      _processLogResponse(response);
    } catch (e) {
      print("Error fetching initial logs: $e");
      logs.value = [];
      filteredLogs.value = [];
    }
    isLoading.value = false;
  }
  void refreshLogs() {
    wsController.fetchAuditLogs();
    nginxLogController.dailyTraffic();
  }
  void refreshLogsForce() {
    fetchLogs();
    nginxLogController.fetchDailyTraffic();
    nginxLogController.refreshLogs();
  }

  void updateStatus() {
    wsController.requestModSecurityStatus();
  }

  @override
  void onClose() {
    super.onClose();
  }
}