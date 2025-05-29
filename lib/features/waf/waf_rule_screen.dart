import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/services/unit/api/config/Config.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/core/utills/responsive.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';
import 'package:msf/features/controllers/waf/WafRule.dart';
import 'package:msf/features/waf/components/add_new_rule.dart';

class WafRuleScreen extends StatelessWidget {
  WafRuleScreen({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Menu_Controller menuController = Get.find<Menu_Controller>();
  final WafRuleController wafController = Get.find<WafRuleController>();
  final ThemeController themeController = Get.find<ThemeController>();

  final TextEditingController searchController = TextEditingController();

  Widget _buildIpContainer(BuildContext context, String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      final isCinematic = themeController.isCinematic.value;
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: isCinematic
              ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
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
            child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
      );
    });
  }

  Widget _buildSearchContainer(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      final isCinematic = themeController.isCinematic.value;
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: isCinematic
              ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  "Search among rules:".tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: Responsive.isDesktop(context)
                      ? screenWidth * 0.4
                      : screenWidth * 0.8,
                  height: 60,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Type rule name...".tr,
                      fillColor: const Color(0xFF404456),
                      filled: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onChanged: (value) {
                      wafController.searchQuery.value = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String extractIp(String address) {
    String ip = address;
    if (ip.startsWith("http://")) {
      ip = ip.substring(7);
    } else if (ip.startsWith("https://")) {
      ip = ip.substring(8);
    }
    if (ip.contains(":")) {
      ip = ip.split(":")[0];
    }
    return ip;
  }

  Widget _buildIpRow(BuildContext context) {
    final ip = extractIp(Config.httpAddress.toString());

    if (Responsive.isMobile(context)) {
      return Column(
        children: [
          _buildIpContainer(context, "Your IP Server: $ip"),
          const SizedBox(height: 10),
          _buildSearchContainer(context),
        ],
      );
    } else {
      return IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildIpContainer(context, "Your IP Server: $ip"),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 7,
              child: _buildSearchContainer(context),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildCreateNewRule(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Widget container = Obx(() {
      final isCinematic = themeController.isCinematic.value;
      return GestureDetector(
        onTap: () {
          Get.to(() => AddNewRule());
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: isCinematic
                ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
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
              child: Row(
                children: [
                  const Icon(Icons.add),
                  const SizedBox(width: 60),
                  Text(
                    "Create New Rule".tr,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    if (Responsive.isMobile(context)) {
      return SizedBox(height: 80, child: container);
    }
    return container;
  }

  Widget _buildBackupRestoreContainer(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      textStyle: const TextStyle(color: Colors.white),
    );

    Widget containerContent = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            wafController.downloadBackup();
          },
          style: buttonStyle,
          icon: const Icon(Icons.download, color: Colors.white),
          label:  Text("Download".tr, style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            bool success = await wafController.restoreBackup();
            if (success) {
              Get.snackbar("Success".tr, "Rules restored successfully".tr);
            } else {
              Get.snackbar("Error".tr, "Failed to restore rules".tr);
            }
          },
          style: buttonStyle,
          icon: const Icon(Icons.restore, color: Colors.white),
          label:  Text("Restore".tr, style: TextStyle(color: Colors.white)),
        ),
      ],
    );

    return Obx(() {
      final isCinematic = themeController.isCinematic.value;
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: isCinematic
              ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
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
            child: containerContent,
          ),
        ),
      );
    });
  }

  Widget _buildTopActionRow(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return Column(
        children: [
          _buildCreateNewRule(context),
          const SizedBox(height: 16),
          _buildBackupRestoreContainer(context),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(flex: 65, child: _buildCreateNewRule(context)),
          const SizedBox(width: 16),
          Expanded(flex: 35, child: _buildBackupRestoreContainer(context)),
        ],
      );
    }
  }

  void _showEditRuleDialog(BuildContext context, String ruleName) async {
    await wafController.fetchRuleContent(ruleName);
    TextEditingController textController = TextEditingController(
      text: wafController.selectedRuleContent.value,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          title: Text("Edit Rule: $ruleName"),
          content: Obx(() => wafController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : TextField(
            controller: textController,
            maxLines: 6,
            decoration:  InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter rule content...".tr,
            ),
          )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text("Cancel".tr),
            ),
            TextButton(
              onPressed: () async {
                bool updated = await wafController.updateRuleContent(
                  ruleName,
                  textController.text,
                );
                Navigator.pop(context);
                if (updated) {
                  Get.snackbar("Success".tr, "Rule updated successfully".tr);
                } else {
                  Get.snackbar("Error".tr, "Failed to update rule".tr);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return PageBuilder(
      sectionWidgets: [
        _buildIpRow(context),
        const SizedBox(height: 16),
        _buildTopActionRow(context),
        const SizedBox(height: 16),
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
                     Text(
                      "Manage ModSecurity rules and configuration".tr,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (wafController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var filteredRules = wafController.rules
                          .where((rule) => rule["name"]
                          .toString()
                          .toLowerCase()
                          .contains(wafController.searchQuery.value.toLowerCase()))
                          .toList();

                      return DataTable(
                        columnSpacing: 16.0,
                        columns:  [
                          DataColumn(
                            label: Text(
                              "Rule Name".tr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text("Status".tr),
                          ),
                          DataColumn(
                            label: Text("Edit Rule".tr),
                          ),
                          DataColumn(
                            label: Text("Remove".tr),
                          ),
                        ],
                        rows: filteredRules.map((rule) {
                          return DataRow(
                            cells: [
                              DataCell(Text(rule["name"] ?? "")),
                              DataCell(
                                Tooltip(
                                  message: "This shows the status of the rule (enabled/disabled)".tr,
                                  child: Switch(
                                    activeColor: Colors.green,
                                    activeTrackColor: Colors.green.withOpacity(0.5),
                                    inactiveThumbColor: Colors.red,
                                    inactiveTrackColor: Colors.red.withOpacity(0.5),
                                    value: (rule["status"] ?? "") == "enabled".tr,
                                    onChanged: (bool value) async {
                                      bool success = await wafController.toggleRule(
                                        rule["name"],
                                        rule["status"],
                                      );
                                      if (success) {
                                        Get.snackbar("Success".tr, "Rule status updated.".tr);
                                      } else {
                                        Get.snackbar("Error".tr, "Failed to update rule status.".tr);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 100,
                                  child: CustomIconbuttonWidget(
                                    title: "Edit Rule".tr,
                                    icon: Icons.edit_square,
                                    backColor: Colors.green[200]!,
                                    titleColor: Colors.green[900]!,
                                    iconColor: Colors.green[900]!,
                                    onPressed: () => _showEditRuleDialog(context, rule["name"]),
                                  ),
                                ),
                              ),
                              DataCell(
                                Tooltip(
                                  message: "You can delete this rule via this key".tr,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      bool success = await wafController.deleteRule(rule["name"]);
                                      if (success) {
                                        Get.snackbar("Success".tr, "Rule deleted successfully".tr);
                                      } else {
                                        Get.snackbar("Error".tr, "Failed to delete rule".tr);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
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