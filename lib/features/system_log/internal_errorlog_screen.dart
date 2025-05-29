import 'dart:ui'; // برای BackdropFilter
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/custom_dropdown.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/log/LogContorller.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

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
    logLevels.insert(0, "All".tr);

    Get.defaultDialog(
      title: "Select Filter".tr,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
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
          }),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              controller.applyAppLogFilter(searchController.text);
              Get.back(); // Close the dialog
            },
            child:  Text("Apply".tr),
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
          title:  Text("Log Details".tr),
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
              child:  Text("Close".tr),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PageBuilder(
      sectionWidgets: [
        Obx(() {
          final isCinematic = themeController.isCinematic.value;
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: isCinematic
                  ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: isCinematic
                    ? BoxDecoration(
                  color: ColorConfig.glassColor,
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.01)
                        : Colors.black.withOpacity(0.0),
                  ),
                  borderRadius: BorderRadius.circular(10),
                )
                    : BoxDecoration(
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
                             Text("Internal Error Logs".tr),
                            Obx(() => Text(
                                "Showing last ${controller.filteredAppLogs.length} logs")),
                          ],
                        ),
                        CustomIconbuttonWidget(
                          backColor: ColorConfig.primaryColor,
                          onPressed: () =>
                              controller.downloadLogs(controller.filteredAppLogs),
                          title: "Download Full Log".tr,
                          icon: Icons.download,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                         Text("Show".tr),
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
                          child:  Text("Filter".tr,
                              style: TextStyle(color: Colors.white)),
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
                          columns:  [
                            DataColumn(label: Text("#")),
                            DataColumn(label: Text("Timestamp".tr)),
                            DataColumn(label: Text("Level".tr)),
                            DataColumn(label: Text("Message".tr)),
                          ],
                          rows: List<DataRow>.generate(
                            controller.filteredAppLogs.reversed.length,
                                (index) {
                              final log =
                              controller.filteredAppLogs.reversed.toList()[index];
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
                                        log["message"] ?? 'No Message'.tr,
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
                    }),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}