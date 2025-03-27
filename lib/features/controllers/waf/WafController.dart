import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import 'package:file_saver/file_saver.dart';

class WafLogController extends GetxController {
  var logs = <Map<String, dynamic>>[].obs;
  var filteredLogs = <Map<String, dynamic>>[].obs;
  var selectedEntries = 10.obs;
  var searchText = ''.obs;
  var filterType = "All".obs;
  var isLoading = false.obs;
  var modStatus = false.obs;
  Timer? timer;

  HttpService httpService = HttpService();

  var warningsCount = 0.obs;
  var criticalCount = 0.obs;
  var messagesCount = 0.obs;
  var allCount = 0.obs;
  var lastRefresh = ''.obs;

  @override
  void onInit() {
    fetchLogs();
    updateStatus();
    timer = Timer.periodic(const Duration(seconds: 60), (_) => updateStatus());
    super.onInit();
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

  void fetchLogs() async {
    isLoading.value = true;

    try {
      dynamic response = await httpService.fetchWafLogs();
      print("Raw response type: ${response.runtimeType}");
      print("Raw response content: $response");

      List<dynamic> logData;
      if (response is String) {
        var decoded = jsonDecode(response);
        if (decoded is Map<String, dynamic> && decoded.containsKey("logs")) {
          logData = decoded["logs"] ?? [];
          print("Decoded Map, logs length: ${logData.length}");
        } else if (decoded is List) {
          logData = decoded;
          print("Decoded List, length: ${logData.length}");
        } else {
          logData = [];
          print("Decoded unexpected type: ${decoded.runtimeType}");
        }
      } else if (response is Map<String, dynamic>) {
        logData = response["logs"] ?? [];
        print("Response is Map, logs length: ${logData.length}");
      } else if (response is List) {
        logData = response;
        print("Response is List, length: ${logData.length}");
      } else {
        logData = [];
        print("Unexpected response type: ${response.runtimeType}");
      }

      print("Number of log entries: ${logData.length}");

      logs.value = logData.map<Map<String, dynamic>>((logEntry) {
        String summary = (logEntry['timestamp'] != null && logEntry['client_ip'] != null)
            ? '${logEntry['timestamp']} - ${logEntry['client_ip']}'
            : 'Log Entry';
        return {
          'summary': summary,
          'full': logEntry,
        };
      }).toList();

      print("Mapped logs count: ${logs.length}");

      logs.sort((a, b) {
        DateTime dateA = DateTime.tryParse(a['full']['timestamp'] ?? '') ?? DateTime(1970);
        DateTime dateB = DateTime.tryParse(b['full']['timestamp'] ?? '') ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });

      for (int i = 0; i < logs.length; i++) {
        logs[i]['#'] = (i + 1).toString();
      }

      _updateCounts();
      applyFilter();
    } catch (e) {
      print("Error fetching logs: $e");
      logs.value = [];
      filteredLogs.value = [];
    }

    lastRefresh.value = DateFormat('HH:mm:ss').format(DateTime.now());
    isLoading.value = false;
  }

  void clearLogs() async {
    isLoading.value = true;
    try {
      bool success = await httpService.clearAuditLogs();
      if (success) {
        logs.clear();
        filteredLogs.clear();
        Get.snackbar("Success", "All logs cleared successfully", snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", "Failed to clear logs", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error clearing logs: $e");
      Get.snackbar("Error", "An error occurred while clearing logs", snackPosition: SnackPosition.BOTTOM);
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
      if (fullLog != null && fullLog.containsKey('alerts')) {
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

  void refreshLogs() {
    logs.clear();
    filteredLogs.clear();
    fetchLogs();
  }

  void updateStatus() async {
    bool status = await httpService.checkModSecurityStatus();
    modStatus.value = status;
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}