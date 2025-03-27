import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/custom_dropdown.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/utills/colorconfig.dart';
import 'package:msf/features/controllers/waf/WafController.dart';

class WafLogScreen extends StatelessWidget {
  final WafLogController controller = Get.find<WafLogController>();
  final TextEditingController searchController = TextEditingController();

  BoxDecoration getLogDecoration(Map<String, dynamic> log, BuildContext context) {
    if (log.containsKey('full') && log['full'] is Map) {
      var full = log['full'] as Map;
      if (full.containsKey('alerts')) {
        List alerts = full['alerts'];
        bool isCritical = alerts.any((w) {
          String msg = w['message']?.toString().toLowerCase() ?? '';
          return msg.contains('sqli') || msg.contains('anomaly') || msg.contains('rce');
        });
        Color baseColor = isCritical ? Colors.redAccent : Colors.yellowAccent;
        return BoxDecoration(
          color: baseColor.withOpacity(0.3),
          border: Border.all(color: baseColor, width: 1),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: baseColor.withOpacity(0.5),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        );
      }
    }
    return const BoxDecoration();
  }

  Widget buildFormattedLog(Map<String, dynamic> fullLog) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Timestamp: ${fullLog['timestamp'] ?? 'N/A'}"),
        Text("IP: ${fullLog['client_ip'] ?? 'N/A'}"),
        Text("Method: ${fullLog['method'] ?? 'N/A'}"),
        Text("Path: ${fullLog['path'] ?? 'N/A'}"),
        if (fullLog.containsKey('alerts') && (fullLog['alerts'] as List).isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text("Alerts:", style: TextStyle(fontWeight: FontWeight.bold)),
          ...List.generate((fullLog['alerts'] as List).length, (index) {
            var alert = fullLog['alerts'][index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rule ID: ${alert['id'] ?? 'N/A'}"),
                  Text("Message: ${alert['msg'] ?? 'N/A'}"),
                  Text("Severity: ${alert['severity'] ?? 'N/A'}"),
                  Text("File: ${alert['file'] ?? 'N/A'}"),
                  Text("Line: ${alert['line'] ?? 'N/A'}"),
                ],
              ),
            );
          }),
        ] else ...[
          const SizedBox(height: 8),
          const Text("No alerts"),
        ],
      ],
    );
  }

  void showLogDetails(BuildContext context, Map<String, dynamic> log) {
    bool showRaw = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Log Details"),
                IconButton(
                  icon: const Icon(Icons.code),
                  onPressed: () {
                    setState(() {
                      showRaw = !showRaw;
                    });
                  },
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: showRaw
                  ? Text(
                const JsonEncoder.withIndent('  ').convert(log['full']),
                style: const TextStyle(fontFamily: 'monospace'),
              )
                  : buildFormattedLog(log['full']),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              ),
            ],
          );
        });
      },
    );
  }

  void showFilterOptions(BuildContext context) {
    final filterOptions = ["All", "Warning", "Critical", "IP", "Message"];
    String tempSelected = controller.filterType.value;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Filter Options"),
              content: DropdownButton<String>(
                value: tempSelected,
                items: filterOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      tempSelected = val;
                    });
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    controller.filterType.value = tempSelected;
                    controller.applyFilter();
                    Get.back();
                  },
                  child: const Text("Apply"),
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showClearLogsConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Clear All Logs"),
          content: const Text("This will clear all logs. Proceed?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                 controller.clearLogs();
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(WafLogController());

    return PageBuilder(
      sectionWidgets: [
        Container(
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
                      const Text("Waf Logs"),
                      Obx(() => Text("Showing last ${controller.filteredLogs.length} logs")),
                    ],
                  ),
                  Row(
                    children: [
                      CustomIconbuttonWidget(
                        backColor: primaryColor,
                        onPressed: controller.downloadLogs,
                        title: "Download Full Log",
                        icon: Icons.download,
                      ),
                      const SizedBox(width: 10),
                      CustomIconbuttonWidget(
                        backColor: Colors.red,
                        onPressed: () => showClearLogsConfirmation(context),
                        title: "Clear All Logs",
                        icon: Icons.delete,
                      ),
                    ],
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
                      value: controller.selectedEntries.value,
                      onchangeValue: (newVal) {
                        int value = int.tryParse(newVal.toString()) ?? 10;
                        controller.selectedEntries.value = value;
                        controller.applyFilter();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      width: 200,
                      child: DashboardTextfield(
                        textEditingController: searchController,
                        onChanged: (val) {
                          controller.searchText.value = val;
                          controller.applyFilter();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => showFilterOptions(context),
                    child: const Text(
                      "Filter",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: controller.refreshLogs,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.filteredLogs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No logs available. Check data source or filters.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("#")),
                        DataColumn(label: Text("Timestamp")),
                        DataColumn(label: Text("IP Address")),
                        DataColumn(label: Text("Logs")),
                        DataColumn(label: Text("Results")),
                      ],
                      rows: controller.filteredLogs.map((log) {
                        BoxDecoration deco = getLogDecoration(log, context);
                        String results = log['full'].containsKey('alerts') && (log['full']['alerts'] as List).isNotEmpty
                            ? (log['full']['alerts'] as List).map((a) => a['msg'] ?? 'N/A').join(', ')
                            : 'No alerts';
                        return DataRow(
                          cells: [
                            DataCell(
                              GestureDetector(
                                onTap: () => showLogDetails(context, log),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: deco,
                                  child: Text(log['#'].toString()),
                                ),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () => showLogDetails(context, log),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: deco,
                                  child: Text(log['full']['timestamp'] ?? 'N/A'),
                                ),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () => showLogDetails(context, log),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: deco,
                                  child: Text(log['full']['client_ip'] ?? 'N/A'),
                                ),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () => showLogDetails(context, log),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: deco,
                                  child: Text(log['summary']),
                                ),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () => showLogDetails(context, log),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: deco,
                                  child: Text(results),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ],
    );
  }
}