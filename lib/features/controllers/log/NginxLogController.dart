import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';

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
  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    _fetchAllData();
    _startRefreshTimer();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _fetchAllData();
    });
  }

  Future<void> _fetchAllData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchNginxLogs(),
        fetchNginxLogSummary(),
        fetchDailyTraffic(),
      ]);
    } catch (e) {
      print("Error fetching all data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNginxLogs() async {
    try {
      final logs = await _httpService.fetchNginxLogs();
      nginxLogs.value = logs.asMap().entries.map((entry) {
        int index = entry.key + 1;
        var log = entry.value;
        log['#'] = index;
        log['summary'] = "${log['request']} - ${log['status']}";
        return log;
      }).toList();
      applyFilter();
    } catch (e) {
      print("Error in fetching logs: $e");
      nginxLogs.value = [];
    }
  }

  Future<void> fetchNginxLogSummary() async {
    try {
      final summary = await _httpService.fetchNginxLogSummary();
      logSummary.value = summary;
    } catch (e) {
      print("Error in fetching log summary: $e");
      logSummary.value = {};
    }
  }

  Future<void> fetchDailyTraffic() async {
    try {
      final traffic = await _httpService.fetchDailyTraffic();
      dailyTraffic.value = traffic;
    } catch (e) {
      print("Error in fetching daily traffic: $e");
      dailyTraffic.value = {};
    }
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
    _fetchAllData();
  }
}