import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';

class LogController extends GetxController {
  var appLogs = <Map<String, dynamic>>[].obs;
  var loginLogs = <Map<String, dynamic>>[].obs;
  var filteredAppLogs = <Map<String, dynamic>>[].obs;
  var filteredLoginLogs = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  var filterType = 'All'.obs;
  var selectedEntries = 10.obs;

  final HttpService _httpService = HttpService();

  @override
  void onInit() {
    super.onInit();
    fetchAppLogs();
    fetchLoginLogs();
  }

  Future<void> fetchAppLogs() async {
    isLoading.value = true;
    appLogs.value = await _httpService.fetchAppLogs();
    filteredAppLogs.value = appLogs;
    isLoading.value = false;
  }

  Future<void> fetchLoginLogs() async {
    isLoading.value = true;
    loginLogs.value = await _httpService.fetchLoginLogs();
    filteredLoginLogs.value = loginLogs;
    isLoading.value = false;
  }

  void applyAppLogFilter(String searchText) {
    filteredAppLogs.value = appLogs.where((log) {
      bool matchesSearchText = log.toString().toLowerCase().contains(searchText.toLowerCase());
      bool matchesFilterType = _matchesFilterType(log, 'app');
      return matchesSearchText && matchesFilterType;
    }).toList();
  }

  void applyLoginLogFilter(String searchText) {
    filteredLoginLogs.value = loginLogs.where((log) {
      bool matchesSearchText = log.toString().toLowerCase().contains(searchText.toLowerCase());
      bool matchesFilterType = _matchesFilterType(log, 'login');
      return matchesSearchText && matchesFilterType;
    }).toList();
  }

  bool _matchesFilterType(Map<String, dynamic> log, String logType) {
    if (filterType.value == 'All') return true;

    bool typeMatches = false;

    if (logType == 'app') {
      if (filterType.value == 'Warning' && log.containsKey('modsecurity_warnings')) {
        typeMatches = true;
      } else if (filterType.value == 'Critical' && log.containsKey('modsecurity_warnings')) {
        typeMatches = (log['modsecurity_warnings'] as List).any((warning) {
          return warning['message']?.toString().toLowerCase().contains('sqli') ?? false;
        });
      } else if (filterType.value == 'IP' && log.containsKey('ip')) {
        typeMatches = true;
      }
    } else if (logType == 'login') {
      if (filterType.value == 'IP' && log.containsKey('ip')) {
        typeMatches = true;
      }
    }

    return typeMatches;
  }

  void downloadLogs(List<Map<String, dynamic>> logs) async {
    final jsonString = jsonEncode(logs);
    final bytes = Uint8List.fromList(utf8.encode(jsonString));
    await FileSaver.instance.saveFile(
      name: "logs",
      bytes: bytes,
      ext: "json",
      customMimeType: "application/json",
    );
  }

  void refreshLogs() {
    appLogs.clear();
    loginLogs.clear();
    filteredAppLogs.clear();
    filteredLoginLogs.clear();
    fetchAppLogs();
    fetchLoginLogs();
  }
}
