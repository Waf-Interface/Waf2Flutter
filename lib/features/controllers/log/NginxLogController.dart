import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import 'package:msf/features/controllers/ws/WsController.dart';

class NginxLogController extends GetxController {
  var nginxLogs = <Map<String, dynamic>>[].obs;
  var logSummary = <String, dynamic>{}.obs;
  var dailyTraffic = <String, dynamic>{}.obs;
  var filteredLogs = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;

  var filterType = 'All'.obs;
  var filterRequestType = 'All'.obs;
  var filterStatusCode = 'All'.obs;
  var selectedEntries = 10.obs;
  var searchText = ''.obs;

  final HttpService _httpService = HttpService();
  late final WsController wsController;
  Timer? _refreshTimer;

  @override
  void onInit() {
    wsController = Get.find<WsController>();
    _syncWithWebSocket();
    fetchDailyTraffic();
    super.onInit();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  void _syncWithWebSocket() {
    ever(wsController.nginxLogs, (List<Map<String, dynamic>> logs) {
      _processNginxLogs(logs);
    });

    ever(wsController.summary, (Map<String, dynamic> summary) {
      logSummary.value = summary;
      print("Log summary updated: $summary");
    });

    ever(wsController.isConnected, (bool connected) {
      if (!connected) {
        isLoading.value = true;
      } else {
        isLoading.value = false;
        fetchWebSocketData(); // Request WebSocket data when reconnected
      }
    });

    // Initial WebSocket request
    if (wsController.isConnected.value) {
      fetchWebSocketData();
    }

    _startRefreshTimer();
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      fetchAllData();
    });
  }

  void fetchAllData() {
    fetchWebSocketData();
    fetchDailyTraffic();
  }

  void fetchWebSocketData() {
    wsController.fetchNginxLog();
    wsController.fetchSummary();
  }

  Future<void> fetchDailyTraffic() async {
    try {
      final traffic = await _httpService.fetchDailyTraffic();
      dailyTraffic.value = traffic;
      print("Daily traffic updated via HTTP: $traffic");
    } catch (e) {
      print("Error fetching daily traffic: $e");
      dailyTraffic.value = {};
    }
  }  Future<void> fetchLogs() async {
    try {
      final logs = await _httpService.fetchNginxLogs();
      nginxLogs.value = logs;
      print("Daily traffic updated via HTTP: $logs");
    } catch (e) {
      print("Error fetching daily traffic: $e");
      dailyTraffic.value = {};
    }
  }

  void _processNginxLogs(List<Map<String, dynamic>> logs) {
    nginxLogs.value = logs.asMap().entries.map((entry) {
      int index = entry.key + 1;
      var log = Map<String, dynamic>.from(entry.value);
      log['#'] = index;
      log['summary'] = "${log['request']} - ${log['status']}";
      return log;
    }).toList();
    applyFilter();
    isLoading.value = false;
  }

  void applyFilter() {
    filteredLogs.value = nginxLogs.where((log) {
      bool matchesSearchText = log.toString().toLowerCase().contains(searchText.value.toLowerCase());
      bool matchesFilterType = _matchesFilterType(log);
      bool matchesRequestType = _matchesRequestType(log);
      bool matchesStatusCode = _matchesStatusCode(log);
      return matchesSearchText && matchesFilterType && matchesRequestType && matchesStatusCode;
    }).toList().take(selectedEntries.value).toList();
  }

  bool _matchesFilterType(Map<String, dynamic> log) {
    if (filterType.value == 'All') return true;

    bool typeMatches = false;

    if (filterType.value == 'Warning' && log.containsKey('modsecurity_warnings')) {
      typeMatches = (log['modsecurity_warnings'] as List).isNotEmpty;
    } else if (filterType.value == 'Critical' && log.containsKey('modsecurity_warnings')) {
      typeMatches = (log['modsecurity_warnings'] as List).any((warning) {
        return warning['message']?.toString().toLowerCase().contains('sqli') ?? false;
      });
    } else if (filterType.value == 'IP' && log.containsKey('ip')) {
      typeMatches = true;
    }

    return typeMatches;
  }

  bool _matchesRequestType(Map<String, dynamic> log) {
    if (filterRequestType.value == 'All') return true;
    return log['request']?.toString().toUpperCase() == filterRequestType.value;
  }

  bool _matchesStatusCode(Map<String, dynamic> log) {
    if (filterStatusCode.value == 'All') return true;
    return log['status']?.toString() == filterStatusCode.value;
  }

  void downloadLogs() async {
    try {
      final jsonString = jsonEncode(filteredLogs);
      final bytes = Uint8List.fromList(utf8.encode(jsonString));
      await FileSaver.instance.saveFile(
        name: "nginx_logs",
        bytes: bytes,
        ext: "json",
        mimeType: MimeType.json,
      );
    } catch (e) {
      print("Error downloading logs: $e");
      Get.snackbar("Error", "Failed to download logs: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void refreshLogs() {
    nginxLogs.clear();
    filteredLogs.clear();
    fetchAllData();
    fetchDailyTraffic();
    fetchLogs();
  }
}