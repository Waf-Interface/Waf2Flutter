import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/waf/WafController.dart';

class RadarChartWidget extends StatelessWidget {
  final WafLogController controller = Get.find<WafLogController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "WAF Radar Overview",
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
                        RadarEntry(value: controller.criticalCount.value.toDouble()),
                        RadarEntry(value: controller.warningsCount.value.toDouble()),
                        RadarEntry(value: controller.messagesCount.value.toDouble()),
                      ],
                    ),
                  ],
                  radarBackgroundColor: Colors.transparent,
                  radarBorderData: BorderSide(color: Colors.grey, width: 1),
                  tickCount: 5,
                  tickBorderData: BorderSide(color: Colors.grey.shade400, width: 1),
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 12),
                  getTitle: (index, angle) {
                    switch (index) {
                      case 0:
                        return RadarChartTitle(text: "Critical Errors", angle: angle);
                      case 1:
                        return RadarChartTitle(text: "Warnings", angle: angle);
                      case 2:
                        return RadarChartTitle(text: "Messages", angle: angle);
                      default:
                        return RadarChartTitle(text: "", angle: angle);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
