import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';
import 'package:msf/features/controllers/waf/WafController.dart';

class RadarChartWidget extends StatelessWidget {
  final WafLogController controller = Get.find<WafLogController>();

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
                 Text(
                  "WAF Radar Overview".tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 250,
                  child: RadarChart(
                    RadarChartData(
                      radarShape: RadarShape.polygon,
                      titlePositionPercentageOffset: 0.2,
                      dataSets: [
                        RadarDataSet(
                          fillColor: Colors.blue.withOpacity(0.3),
                          borderColor: Colors.blue,
                          entryRadius: 3,
                          borderWidth: 2,
                          dataEntries: [
                            RadarEntry(
                                value: controller.criticalCount.value.toDouble()),
                            RadarEntry(
                                value: controller.warningsCount.value.toDouble()),
                            RadarEntry(
                                value: controller.messagesCount.value.toDouble()),
                          ],
                        ),
                      ],
                      radarBackgroundColor: Colors.transparent,
                      radarBorderData: BorderSide(color: Colors.grey, width: 1),
                      tickCount: 5,
                      tickBorderData:
                      BorderSide(color: Colors.grey.shade400, width: 1),
                      titleTextStyle: TextStyle(color: Colors.white, fontSize: 12),
                      getTitle: (index, angle) {
                        switch (index) {
                          case 0:
                            return RadarChartTitle(
                                text: "Critical Errors".tr, angle: angle);
                          case 1:
                            return RadarChartTitle(text: "Warnings".tr, angle: angle);
                          case 2:
                            return RadarChartTitle(text: "Messages".tr, angle: angle);
                          default:
                            return RadarChartTitle(text: "", angle: angle);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}