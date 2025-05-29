import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/status_widget.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/user/UserController.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class ActiveConnectionsScreen extends StatelessWidget {
  const ActiveConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PageBuilder(
      sectionWidgets: [
        Obx(() => Row(
          children: [
            const Text("Active Connections "),
            StatusWidget(
              title: controller.activeUsers.length.toString(),
              backgrounColor: ColorConfig.primaryColor,
              titleColor: Colors.white,
            ),
          ],
        )),
        const SizedBox(height: 20),
        Obx(() {
          final isCinematic = themeController.isCinematic.value;
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: isCinematic
                  ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                decoration: isCinematic
                    ? BoxDecoration(
                  color: ColorConfig.glassColor,
                  border: Border.all(
                    color: isDarkMode ? Colors.white.withOpacity(0.01) : Colors.black.withOpacity(0.0),
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
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return DataTable(
                        sortColumnIndex: controller.sortColumnIndex?.value,
                        sortAscending: controller.isAscending.value,
                        columns: [
                          DataColumn(
                            label: const Text("#"),
                            numeric: false,
                            headingRowAlignment: MainAxisAlignment.start,
                            onSort: (columnIndex, ascending) =>
                                controller.sortData(columnIndex, ascending),
                          ),
                          DataColumn(
                            label: const Text("Username"),
                            numeric: false,
                            headingRowAlignment: MainAxisAlignment.start,
                            onSort: (columnIndex, ascending) =>
                                controller.sortData(columnIndex, ascending),
                          ),
                          DataColumn(
                            label: const Text("Rule"),
                            numeric: false,
                            headingRowAlignment: MainAxisAlignment.start,
                            onSort: (columnIndex, ascending) =>
                                controller.sortData(columnIndex, ascending),
                          ),
                          const DataColumn(
                            label: Text("Action"),
                            numeric: false,
                            headingRowAlignment: MainAxisAlignment.start,
                          ),
                        ],
                        rows: controller.activeUsers.map((activeUser) {
                          return DataRow(cells: [
                            DataCell(Text(
                                (controller.activeUsers.indexOf(activeUser) + 1)
                                    .toString(),
                                textAlign: TextAlign.left)),
                            DataCell(Text(activeUser['username'] ?? 'N/A',
                                textAlign: TextAlign.left)),
                            DataCell(Text(activeUser['rule'] ?? 'N/A',
                                textAlign: TextAlign.left)),
                            DataCell(
                              ElevatedButton(
                                onPressed: () =>
                                    controller.deleteActiveUser(activeUser['id'] ?? 0),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Delete"),
                              ),
                            ),
                          ]);
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