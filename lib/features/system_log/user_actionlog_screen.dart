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

class UserActionLogScreen extends StatelessWidget {
  final LogController controller = Get.find<LogController>();
  final TextEditingController searchController = TextEditingController();

  BoxDecoration getLogDecoration(Map<String, dynamic> log, BuildContext context) {
    return BoxDecoration(
      border: Border.all(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 4,
          offset: const Offset(2, 2),
        ),
      ],
    );
  }

  Widget buildLogDetails(Map<String, dynamic> log) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Timestamp: ${log['timestamp'] ?? 'N/A'}"),
        Text("Level: ${log['level'] ?? 'N/A'}"),
        Text("Message: ${log['message'] ?? 'N/A'}"),
      ],
    );
  }

  void showLogDetails(BuildContext context, Map<String, dynamic> log) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text("Log Details".tr),
          content: SingleChildScrollView(child: buildLogDetails(log)),
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

  void showFilterOptions(BuildContext context) {
    final filterOptions = ["All".tr, "Warning".tr, "Critical".tr, "IP".tr, "Message".tr];
    String tempSelected = controller.filterType.value;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text("Filter Options".tr),
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
                tempSelected = val;
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.filterType.value = tempSelected;
                controller.applyLoginLogFilter(searchController.text);
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
                             Text("User Action Logs".tr),
                            Obx(() => Text(
                                "Showing last ${controller.filteredLoginLogs.length} logs")),
                          ],
                        ),
                        CustomIconbuttonWidget(
                          backColor: ColorConfig.primaryColor,
                          onPressed: () =>
                              controller.downloadLogs(controller.filteredLoginLogs),
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
                              controller.applyLoginLogFilter(searchController.text);
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
                                controller.applyLoginLogFilter(val);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // ElevatedButton(
                        //   onPressed: () => showFilterOptions(context),
                        //   child: const Text("Filter",
                        //       style: TextStyle(color: Colors.white)),
                        // ),
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
                            DataColumn(label: Text("Logs".tr)),
                          ],
                          rows: controller.filteredLoginLogs.asMap().map((index, log) {
                            BoxDecoration deco = getLogDecoration(log, context);
                            return MapEntry(
                              index,
                              DataRow(
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
                                      child: Text((index + 1).toString()),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: deco,
                                      child: Text(
                                        log["message"]?.toString() ?? "No message".tr,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).values.toList(),
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