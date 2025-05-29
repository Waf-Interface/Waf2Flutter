import 'dart:convert';
import 'dart:ui'; // برای BackdropFilter
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/custom_dropdown.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/log/NginxLogController.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class NginxLogScreen extends StatelessWidget {
  final NginxLogController controller = Get.put(NginxLogController());
  final TextEditingController searchController = TextEditingController();

  BoxDecoration getLogDecoration(Map<String, dynamic> log, BuildContext context) {
    if (log.containsKey('modsecurity_warnings'.tr) && (log['modsecurity_warnings'.tr] as List).isNotEmpty) {
      List warnings = log['modsecurity_warnings'.tr];
      bool isCritical = warnings.any((w) {
        String msg = w['message']?.toString().toLowerCase() ?? '';
        return msg.contains('sqli') || msg.contains('anomaly');
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
    return const BoxDecoration();
  }

  Widget buildFormattedLog(Map<String, dynamic> log) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Timestamp: ${log['timestamp'] ?? 'N/A'}"),
        Text("IP: ${log['ip'] ?? 'N/A'}"),
        Text("Request: ${log['request'] ?? 'N/A'}"),
        Text("Status: ${log['status'] ?? 'N/A'}"),
        Text("Bytes: ${log['bytes'] ?? 'N/A'}"),
        Text("Referrer: ${log['referrer'] ?? 'N/A'}"),
        Text("User-Agent: ${log['user_agent'] ?? 'N/A'}"),
        if (log.containsKey('modsecurity_warnings') && (log['modsecurity_warnings'] as List).isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text("Warnings:", style: TextStyle(fontWeight: FontWeight.bold)),
          ...List.generate((log['modsecurity_warnings'] as List).length, (index) {
            var warning = log['modsecurity_warnings'][index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text("- ${warning['message'] ?? ''}"),
            );
          }),
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
                 Text("Log Details".tr),
                IconButton(
                  icon: const Icon(Icons.code),
                  onPressed: () {
                    setState(() {
                      showRaw = !showRaw;
                    });
                  },
                )
              ],
            ),
            content: SingleChildScrollView(
              child: showRaw
                  ? Text(
                const JsonEncoder.withIndent('  ').convert(log),
                style: const TextStyle(fontFamily: 'monospace'),
              )
                  : buildFormattedLog(log),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child:  Text("Close".tr),
              )
            ],
          );
        });
      },
    );
  }

  void showFilterOptions(BuildContext context) {
    final requestTypes = ["All", "GET", "POST", "DELETE", "PUT"];
    final statusCodes = ["All", "200", "404", "403", "500"];
    String tempRequestType = controller.filterRequestType.value;
    String tempStatusCode = controller.filterStatusCode.value;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title:  Text("Filter Options".tr),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: tempRequestType,
                    items: requestTypes.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text("Request: $option"),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          tempRequestType = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: tempStatusCode,
                    items: statusCodes.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text("Status: $option"),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          tempStatusCode = val;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    controller.filterRequestType.value = tempRequestType;
                    controller.filterStatusCode.value = tempStatusCode;
                    controller.applyFilter();
                    Get.back();
                  },
                  child:  Text("Apply".tr),
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  child:  Text("Close".tr),
                ),
              ],
            );
          },
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
        SingleChildScrollView(
          child: Obx(() {
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
                               Text("Nginx Logs".tr),
                              Obx(() => Text("Showing last ${controller.filteredLogs.length} logs")),
                            ],
                          ),
                          CustomIconbuttonWidget(
                            backColor: ColorConfig.primaryColor,
                            onPressed: controller.downloadLogs,
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
                            child:  Text(
                              "Filter".tr,
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
                        } else {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width - 32,
                              ),
                              child: DataTable(
                                columnSpacing: 0,
                                horizontalMargin: 0,
                                columns:  [
                                  DataColumn(label: Expanded(child: Text("#", textAlign: TextAlign.center))),
                                  DataColumn(label: Expanded(child: Text("Timestamp".tr, textAlign: TextAlign.center))),
                                  DataColumn(label: Expanded(child: Text("IP Address".tr, textAlign: TextAlign.center))),
                                  DataColumn(label: Expanded(child: Text("Request".tr, textAlign: TextAlign.center))),
                                  DataColumn(label: Expanded(child: Text("Status".tr, textAlign: TextAlign.center))),
                                  DataColumn(label: Expanded(child: Text("Bytes".tr, textAlign: TextAlign.center))),
                                  DataColumn(label: Expanded(child: Text("Referrer".tr, textAlign: TextAlign.center))),
                                  DataColumn(label: Expanded(child: Text("User-Agent".tr, textAlign: TextAlign.center))),
                                  DataColumn(label: Expanded(child: Text("Summary".tr, textAlign: TextAlign.center))),
                                ],
                                rows: controller.filteredLogs.map((log) {
                                  BoxDecoration deco = getLogDecoration(log, context);
                                  return DataRow(
                                    onSelectChanged: (selected) {
                                      if (selected ?? false) {
                                        showLogDetails(context, log);
                                      }
                                    },
                                    cells: [
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: deco,
                                          child: Center(child: Text(log['#'].toString())),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: deco,
                                          child: Center(child: Text(log['timestamp'] ?? 'N/A')),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: deco,
                                          child: Center(child: Text(log['ip'] ?? 'N/A')),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: deco,
                                          child: Center(child: Text(log['request'] ?? 'N/A')),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: deco,
                                          child: Center(child: Text(log['status'] ?? 'N/A')),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: deco,
                                          child: Center(child: Text(log['bytes'] ?? 'N/A')),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: deco,
                                          child: Center(child: Text(log['referrer'] ?? 'N/A')),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: deco,
                                          child: Center(child: Text(log['user_agent'] ?? 'N/A')),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: deco,
                                          child: Center(child: Text(log['summary'] ?? 'N/A')),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
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
        ),
      ],
    );
  }
}