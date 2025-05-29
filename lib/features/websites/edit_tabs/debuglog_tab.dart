import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/widgets/custom_dropdown.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/utills/_colorconfig.dart';
import 'package:msf/features/controllers/waf/WafWebsite.dart';

class DebugLogTab extends StatefulWidget {
  const DebugLogTab({super.key});

  @override
  State<DebugLogTab> createState() => _DebugLogTabState();
}

class _DebugLogTabState extends State<DebugLogTab> {
  late final WafWebsiteController wafController;
  final TextEditingController searchController = TextEditingController();
  final RxList<Map<String, dynamic>> debugLogs = <Map<String, dynamic>>[].obs;
  final RxInt selectedEntries = 10.obs;
  final RxString filterType = 'All'.obs;
  final String websiteId = Get.arguments ?? '';

  @override
  void initState() {
    super.initState();
    wafController = Get.put(WafWebsiteController());
    _fetchDebugLogs();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDebugLogs() async {
    if (websiteId.isNotEmpty) {
      try {
        final logString = await wafController.getDebugLog(websiteId);
        print('Debug Log Raw: $logString'); // Debug log
        final logs = _parseLogString(logString);
        debugLogs.assignAll(logs);
      } catch (e) {
        print('Error fetching debug logs: $e');
        Get.snackbar(
          "Error",
          "Failed to fetch debug logs: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "No website ID provided",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  List<Map<String, dynamic>> _parseLogString(String logString) {
    // Assuming logs are line-separated with a simple format: "timestamp level message"
    final lines = logString.split('\n').where((line) => line.trim().isNotEmpty).toList();
    return lines.map((line) {
      final parts = line.split(' ').where((part) => part.isNotEmpty).toList();
      return {
        'timestamp': parts.length > 0 ? parts[0] : 'N/A',
        'level': parts.length > 1 ? parts[1] : 'N/A',
        'message': parts.length > 2 ? parts.sublist(2).join(' ') : 'No Message',
      };
    }).toList();
  }

  void applyFilter(String searchQuery) {
    final filteredLogs = _parseLogString(wafController.getDebugLog(websiteId).toString());
    final filtered = filteredLogs.where((log) {
      final matchesSearch = log['message']!.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = filterType.value == 'All' || log['level'] == filterType.value;
      return matchesSearch && matchesFilter;
    }).toList();
    debugLogs.assignAll(filtered.take(selectedEntries.value).toList());
  }

  void showFilterDialog(BuildContext context) {
    final logLevels = debugLogs.map((log) => log['level'].toString().toUpperCase().trim()).toSet().toList()
      ..sort()
      ..insert(0, "All");

    Get.defaultDialog(
      title: "Select Filter",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            if (!logLevels.contains(filterType.value)) {
              filterType.value = logLevels.first;
            }
            return DropdownButton<String>(
              value: filterType.value,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  filterType.value = newValue;
                }
              },
              items: logLevels.map((filter) {
                return DropdownMenuItem(value: filter, child: Text(filter));
              }).toList(),
            );
          }),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              applyFilter(searchController.text);
              Get.back();
            },
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }

  Color getLogColor(String? level) {
    switch (level?.toLowerCase()) {
      case 'error':
        return Colors.redAccent;
      case 'info':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  Widget buildLogLevelBadge(String? level) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getLogColor(level).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: getLogColor(level), width: 1.5),
      ),
      child: Text(
        level?.toUpperCase() ?? 'N/A',
        style: TextStyle(fontWeight: FontWeight.bold, color: getLogColor(level)),
      ),
    );
  }

  void showLogDetails(BuildContext context, Map<String, dynamic> log) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Debug Log Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Timestamp: ${log['timestamp'] ?? 'N/A'}"),
              const SizedBox(height: 8),
              buildLogLevelBadge(log['level']),
              const SizedBox(height: 8),
              Text("Message: ${log['message'] ?? 'N/A'}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Debug Logs"),
                    Obx(() => Text("Showing last ${debugLogs.length} logs")),
                  ],
                ),
                CustomIconbuttonWidget(
                  backColor: primaryColor,
                  onPressed: () => _fetchDebugLogs(), // Refresh instead of download for simplicity
                  title: "Refresh",
                  icon: Icons.refresh,
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Show"),
                const SizedBox(width: 5),
                Obx(
                      () => CustomDropdownWidget(
                    list: [5, 10, 25, 50, 100],
                    value: selectedEntries.value,
                    onchangeValue: (newVal) {
                      int value = int.tryParse(newVal.toString()) ?? 10;
                      selectedEntries.value = value;
                      applyFilter(searchController.text);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    width: 200,
                    child: DashboardTextfield(
                      textEditingController: searchController,
                      onChanged: (val) => applyFilter(val),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => showFilterDialog(context),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: const Text("Filter", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _fetchDebugLogs,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (wafController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("#")),
                      DataColumn(label: Text("Timestamp")),
                      DataColumn(label: Text("Level")),
                      DataColumn(label: Text("Message")),
                    ],
                    rows: List<DataRow>.generate(
                      debugLogs.reversed.length,
                          (index) {
                        final log = debugLogs.reversed.toList()[index];
                        return DataRow(
                          onSelectChanged: (selected) {
                            if (selected ?? false) {
                              showLogDetails(context, log);
                            }
                          },
                          cells: [
                            DataCell(Text((index + 1).toString())),
                            DataCell(Text(log["timestamp"] ?? 'N/A')),
                            DataCell(buildLogLevelBadge(log["level"])),
                            DataCell(
                              SizedBox(
                                width: 200,
                                child: Text(
                                  log["message"] ?? 'No Message',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}