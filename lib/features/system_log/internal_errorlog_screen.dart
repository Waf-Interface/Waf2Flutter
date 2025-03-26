import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/custom_dropdown.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/utills/colorconfig.dart';
import 'package:msf/features/controllers/log/LogContorller.dart';

class InternalErrorLogScreen extends StatelessWidget {
  final LogController controller = Get.find<LogController>();
  final TextEditingController searchController = TextEditingController();

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
  void showFilterDialog(BuildContext context) {
    List<String> logLevels = controller.filteredAppLogs
        .map((log) => log['level'].toString().toUpperCase().trim())
        .toSet()
        .toList();

    logLevels.sort();
    logLevels.insert(0, "All");

    Get.defaultDialog(
      title: "Select Filter",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
                () {
              if (!logLevels.contains(controller.filterType.value)) {
                controller.filterType.value = logLevels.first;
              }

              return DropdownButton<String>(
                value: controller.filterType.value,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.filterType.value = newValue;
                  }
                },
                items: logLevels.map((filter) {
                  return DropdownMenuItem(
                    value: filter,
                    child: Text(filter),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              controller.applyAppLogFilter(searchController.text);
              Get.back(); // Close the dialog
            },
            child: const Text("Apply"),
          ),
        ],
      ),
    );
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
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: getLogColor(level),
        ),
      ),
    );
  }

  void showLogDetails(BuildContext context, Map<String, dynamic> log) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Log Details"),
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
                      const Text("Internal Error Logs"),
                      Obx(() => Text("Showing last ${controller.filteredAppLogs.length} logs")),
                    ],
                  ),
                  CustomIconbuttonWidget(
                    backColor: primaryColor,
                    onPressed: () => controller.downloadLogs(controller.filteredAppLogs),
                    title: "Download Full Log",
                    icon: Icons.download,
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
                        controller.applyAppLogFilter(searchController.text);
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
                          controller.applyAppLogFilter(val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      showFilterDialog(context);
                    },
                    child: const Text("Filter", style: TextStyle(color: Colors.white)),
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
                } else {
                  return DataTable(
                    columns: const [
                      DataColumn(label: Text("#")),
                      DataColumn(label: Text("Timestamp")),
                      DataColumn(label: Text("Level")),
                      DataColumn(label: Text("Message")),
                    ],
                    rows: List<DataRow>.generate(
                      controller.filteredAppLogs.reversed.length, // Newest logs on top
                          (index) {
                        final log = controller.filteredAppLogs.reversed.toList()[index];
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
                  );
                }
              })
            ],
          ),
        ),
      ],
    );
  }
}