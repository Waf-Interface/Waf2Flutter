import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';
import 'package:msf/features/controllers/update/UpdateController.dart';

class UpdateStatusWidget extends StatelessWidget {
  final UpdateController controller = Get.find<UpdateController>();

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Update Status'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                          await controller.fetchUpdateStatus();
                        },
                        tooltip: 'Refresh Status'.tr,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (controller.isLoading.value)
                  Center(child: CircularProgressIndicator())
                else if (controller.updateStatus.isEmpty ||
                    controller.updateStatus['modules'] == null)
                  Center(
                    child: Text(
                      'please refresh to check..'.tr,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  Column(
                    children: (controller.updateStatus['modules'] as Map)
                        .entries
                        .map<Widget>((entry) {
                      final moduleName = entry.key;
                      final moduleInfo = entry.value as Map;
                      final currentVersion = moduleInfo['current'] ?? 'unknown';
                      final latestVersion = moduleInfo['latest'] ?? 'unknown';
                      final needsUpdate = moduleInfo['needs_update'] ?? false;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Tooltip(
                                message: 'Current: $currentVersion',
                                child: Text(
                                  moduleName.toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: needsUpdate
                                        ? Colors.orange.withOpacity(0.2)
                                        : Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    needsUpdate ? latestVersion : currentVersion,
                                    style: TextStyle(
                                      color:
                                      needsUpdate ? Colors.orange : Colors.green,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                if (needsUpdate && moduleName == 'crs') ...[
                                  SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () => controller.updateCrs(),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      minimumSize: Size(0, 0),
                                    ),
                                    child: Text('Update'.tr,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white)),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}