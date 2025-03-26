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
    if ((fullLog['timestamp']?.toString().toLowerCase() ?? '').contains(search))
      return true;
    if ((fullLog['ip']?.toString().toLowerCase() ?? '').contains(search))
      return true;
    if (fullLog.containsKey('modsecurity_warnings')) {
      for (var warning in fullLog['modsecurity_warnings']) {
        if ((warning['message']?.toString().toLowerCase() ?? '')
            .contains(search)) return true;
      }
    }
    return false;
  }

  void fetchLogs() async {
    isLoading.value = true;
    List<dynamic> logData = await httpService.fetchWafLogs();
    logs.value = logData.map((logEntry) {
      String summary = (logEntry['timestamp'] != null && logEntry['ip'] != null)
          ? '${logEntry['timestamp']} - ${logEntry['ip']}'
          : 'Log Entry';
      return {
        'summary': summary,
        'full': logEntry,
      };
    }).toList();

    logs.sort((a, b) {
      DateTime dateA = DateTime.tryParse(a['full']['timestamp'] ?? '') ?? DateTime(1970);
      DateTime dateB = DateTime.tryParse(b['full']['timestamp'] ?? '') ?? DateTime(1970);
      return dateB.compareTo(dateA);
    });

    for (int i = 0; i < logs.length; i++) {
      logs[i]['#'] = i + 1;
    }

    _updateCounts();
    applyFilter();
    lastRefresh.value = DateFormat('HH:mm:ss').format(DateTime.now());
    isLoading.value = false;
  }



  void _updateCounts() {
    int totalCritical = logs.where((log) {
      Map fullLog = log['full'];
      if (fullLog.containsKey('modsecurity_warnings')) {
        List warnings = fullLog['modsecurity_warnings'];
        return warnings.any((w) {
          String msg = (w['message'] ?? '').toString().toLowerCase();
          return msg.contains('sqli') || msg.contains('anomaly');
        });
      }
      return false;
    }).length;

    int totalWarnings = logs.where((log) {
      Map fullLog = log['full'];
      if (fullLog.containsKey('modsecurity_warnings')) {
        List warnings = fullLog['modsecurity_warnings'];
        bool isCritical = warnings.any((w) {
          String msg = (w['message'] ?? '').toString().toLowerCase();
          return msg.contains('sqli') || msg.contains('anomaly');
        });
        return !isCritical;
      }
      return false;
    }).length;

    int totalMessages = logs.where((log) {
      Map fullLog = log['full'];
      return !fullLog.containsKey('modsecurity_warnings');
    }).length;

    warningsCount.value = totalWarnings;
    criticalCount.value = totalCritical;
    messagesCount.value = totalMessages;
    allCount.value = logs.length;
  }

  void applyFilter() {
    filteredLogs.value = logs.where((log) {
      String searchLower = searchText.value.toLowerCase();
      var fullLog = log['full'];
      bool baseMatches = log['summary']
          .toString()
          .toLowerCase()
          .contains(searchLower) ||
          logMatches(fullLog, searchLower);
      bool typeMatches = true;
      if (filterType.value != "All") {
        if (filterType.value == "Warning") {
          typeMatches = fullLog.containsKey('modsecurity_warnings');
        } else if (filterType.value == "Critical") {
          if (fullLog.containsKey('modsecurity_warnings')) {
            List warnings = fullLog['modsecurity_warnings'];
            typeMatches = warnings.any((w) {
              String msg = w['message']?.toString().toLowerCase() ?? '';
              return msg.contains('sqli') || msg.contains('anomaly');
            });
          } else {
            typeMatches = false;
          }
        } else if (filterType.value == "IP") {
          typeMatches = (fullLog['ip']?.toString().toLowerCase() ?? '')
              .contains(searchLower);
        } else if (filterType.value == "Message") {
          if (fullLog.containsKey('modsecurity_warnings')) {
            List warnings = fullLog['modsecurity_warnings'];
            typeMatches = warnings.any((w) {
              return (w['message']?.toString().toLowerCase() ?? '')
                  .contains(searchLower);
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
  Map<String, int> getRuleTriggerCounts() {
    Map<String, int> counts = {};
    for (var log in logs) {
      Map full = log['full'] ?? {};
      String timestamp = full['timestamp']?.toString() ?? "";
      if (timestamp.contains("/nginx/rules/")) {
        int start = timestamp.indexOf("/nginx/rules/");
        if (start != -1) {
          int ruleStart = start + "/nginx/rules/".length;
          int endIndex = timestamp.indexOf(RegExp(r'["\s]'), ruleStart);
          if (endIndex == -1) {
            endIndex = timestamp.length;
          }
          String ruleName = timestamp.substring(ruleStart, endIndex);
          counts[ruleName] = (counts[ruleName] ?? 0) + 1;
        }
      }
    }
    return counts;
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
