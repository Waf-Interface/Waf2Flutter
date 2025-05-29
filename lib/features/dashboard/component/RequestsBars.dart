import 'dart:ui'; // برای BackdropFilter
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/waf/WafController.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class RequestsBars extends StatelessWidget {
  const RequestsBars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WafLogController controller = Get.find<WafLogController>();
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
            width: double.infinity,
            height: 350,
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
              color: ColorConfig.secondryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Obx(() {
              int total = controller.allCount.value;
              double warningsProgress =
              total > 0 ? controller.warningsCount.value / total : 0;
              double criticalProgress =
              total > 0 ? controller.criticalCount.value / total : 0;
              double messagesProgress =
              total > 0 ? controller.messagesCount.value / total : 0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Log Statistics".tr,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  _buildStatBar(
                    label: "All Requests".tr,
                    value: total.toString(),
                    progress: 1.0,
                    barColor: Colors.grey,
                    context: context,
                  ),
                  const SizedBox(height: 16),
                  _buildStatBar(
                    label: "Warnings".tr,
                    value: controller.warningsCount.value.toString(),
                    progress: warningsProgress,
                    barColor: Colors.yellowAccent,
                    context: context,
                  ),
                  const SizedBox(height: 16),
                  _buildStatBar(
                    label: "Critical".tr,
                    value: controller.criticalCount.value.toString(),
                    progress: criticalProgress,
                    barColor: Colors.redAccent,
                    context: context,
                  ),
                  const SizedBox(height: 16),
                  _buildStatBar(
                    label: "Messages".tr,
                    value: controller.messagesCount.value.toString(),
                    progress: messagesProgress,
                    barColor: Colors.blueAccent,
                    context: context,
                  ),
                ],
              );
            }),
          ),
        ),
      );
    });
  }

  Widget _buildStatBar({
    required String label,
    required String value,
    required double progress,
    required Color barColor,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white)),
            Text(value, style: const TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 4),
        LayoutBuilder(
          builder: (context, constraints) {
            double fullWidth = constraints.maxWidth;
            double filledWidth = fullWidth * progress;
            return Stack(
              children: [
                Container(
                  width: fullWidth,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  width: filledWidth,
                  height: 20,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}