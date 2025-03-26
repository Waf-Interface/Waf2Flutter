import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';

class NginxLogController extends GetxController {
  var nginxLogs = <Map<String, dynamic>>[].obs;
  var filteredLogs = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  var filterType = 'All'.obs;
  var filterRequestType = 'All'.obs; // فیلتر نوع درخواست
  var filterStatusCode = 'All'.obs;  // فیلتر کد وضعیت
  var selectedEntries = 10.obs;
  var searchText = ''.obs;

  final HttpService _httpService = HttpService();

  @override
  void onInit() {
    super.onInit();
    fetchNginxLogs();
  }

  Future<void> fetchNginxLogs() async {
    isLoading.value = true;
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
    } finally {
      isLoading.value = false;
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
        mimeType: MimeType.json, // استفاده از MimeType به جای customMimeType
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
    fetchNginxLogs();
  }
}